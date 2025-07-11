const express = require('express');
const { body, validationResult } = require('express-validator');
const { Conversation, Message, User } = require('../models');
const auth = require('../middleware/auth');
const logger = require('../utils/logger');

const router = express.Router();

// Get user conversations
router.get('/conversations', auth, async (req, res) => {
  try {
    const conversations = await Conversation.findAll({
      include: [
        {
          model: User,
          as: 'participants',
          where: { id: req.user.id },
          through: { attributes: [] },
        },
        {
          model: Message,
          as: 'messages',
          limit: 1,
          order: [['createdAt', 'DESC']],
          include: [
            {
              model: User,
              as: 'sender',
              attributes: ['id', 'firstName', 'lastName', 'avatar'],
            },
          ],
        },
      ],
      order: [['lastMessageAt', 'DESC']],
    });

    // Get other participants for each conversation
    for (let conversation of conversations) {
      const otherParticipants = await conversation.getParticipants({
        where: { id: { [require('sequelize').Op.ne]: req.user.id } },
        attributes: ['id', 'firstName', 'lastName', 'avatar'],
      });
      conversation.dataValues.otherParticipants = otherParticipants;
    }

    res.json({
      success: true,
      conversations,
    });
  } catch (error) {
    logger.error('Get conversations error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while fetching conversations.',
    });
  }
});

// Get conversation messages
router.get('/:id/messages', auth, async (req, res) => {
  try {
    const { page = 1, limit = 50 } = req.query;
    const offset = (page - 1) * limit;

    // Check if user is participant in this conversation
    const conversation = await Conversation.findByPk(req.params.id, {
      include: [
        {
          model: User,
          as: 'participants',
          where: { id: req.user.id },
          through: { attributes: [] },
        },
      ],
    });

    if (!conversation) {
      return res.status(404).json({
        error: 'Conversation not found',
        message: 'The requested conversation was not found or you do not have access to it.',
      });
    }

    const messages = await Message.findAndCountAll({
      where: { conversationId: req.params.id },
      include: [
        {
          model: User,
          as: 'sender',
          attributes: ['id', 'firstName', 'lastName', 'avatar'],
        },
      ],
      order: [['createdAt', 'DESC']],
      limit: parseInt(limit),
      offset: parseInt(offset),
    });

    res.json({
      success: true,
      messages: messages.rows.reverse(), // Reverse to show oldest first
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: messages.count,
        totalPages: Math.ceil(messages.count / limit),
      },
    });
  } catch (error) {
    logger.error('Get messages error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while fetching messages.',
    });
  }
});

// Send message
router.post('/:id/messages', auth, [
  body('content').trim().isLength({ min: 1, max: 1000 }),
  body('messageType').optional().isIn(['text', 'image', 'file']),
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        error: 'Validation Error',
        details: errors.array(),
      });
    }

    const { content, messageType, attachment } = req.body;

    // Check if user is participant in this conversation
    const conversation = await Conversation.findByPk(req.params.id, {
      include: [
        {
          model: User,
          as: 'participants',
          where: { id: req.user.id },
          through: { attributes: [] },
        },
      ],
    });

    if (!conversation) {
      return res.status(404).json({
        error: 'Conversation not found',
        message: 'The requested conversation was not found or you do not have access to it.',
      });
    }

    const message = await Message.create({
      conversationId: req.params.id,
      senderId: req.user.id,
      content,
      messageType: messageType || 'text',
      attachment,
    });

    // Update conversation last message time
    await conversation.update({ lastMessageAt: new Date() });

    // Include sender info in response
    const messageWithSender = await Message.findByPk(message.id, {
      include: [
        {
          model: User,
          as: 'sender',
          attributes: ['id', 'firstName', 'lastName', 'avatar'],
        },
      ],
    });

    logger.info(`Message sent in conversation ${req.params.id} by ${req.user.email}`);

    res.status(201).json({
      success: true,
      message: messageWithSender,
    });
  } catch (error) {
    logger.error('Send message error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while sending the message.',
    });
  }
});

// Create or get conversation
router.post('/conversations', auth, [
  body('participantId').isUUID(),
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        error: 'Validation Error',
        details: errors.array(),
      });
    }

    const { participantId } = req.body;

    if (participantId === req.user.id) {
      return res.status(400).json({
        error: 'Invalid participant',
        message: 'You cannot create a conversation with yourself.',
      });
    }

    // Check if participant exists
    const participant = await User.findByPk(participantId);
    if (!participant) {
      return res.status(404).json({
        error: 'User not found',
        message: 'The specified participant was not found.',
      });
    }

    // Check if conversation already exists
    const existingConversation = await Conversation.findOne({
      include: [
        {
          model: User,
          as: 'participants',
          where: { id: { [require('sequelize').Op.in]: [req.user.id, participantId] } },
          through: { attributes: [] },
        },
      ],
      having: require('sequelize').literal('COUNT("participants"."id") = 2'),
      group: ['Conversation.id'],
    });

    if (existingConversation) {
      return res.json({
        success: true,
        conversation: existingConversation,
        isNew: false,
      });
    }

    // Create new conversation
    const conversation = await Conversation.create({
      conversationType: 'direct',
    });

    // Add participants
    await conversation.addParticipants([req.user.id, participantId]);

    logger.info(`New conversation created between ${req.user.email} and ${participant.email}`);

    res.status(201).json({
      success: true,
      conversation,
      isNew: true,
    });
  } catch (error) {
    logger.error('Create conversation error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while creating the conversation.',
    });
  }
});

// Mark messages as read
router.put('/:id/read', auth, async (req, res) => {
  try {
    const { messageIds } = req.body;

    if (!Array.isArray(messageIds)) {
      return res.status(400).json({
        error: 'Invalid data',
        message: 'messageIds must be an array.',
      });
    }

    // Check if user is participant in this conversation
    const conversation = await Conversation.findByPk(req.params.id, {
      include: [
        {
          model: User,
          as: 'participants',
          where: { id: req.user.id },
          through: { attributes: [] },
        },
      ],
    });

    if (!conversation) {
      return res.status(404).json({
        error: 'Conversation not found',
        message: 'The requested conversation was not found or you do not have access to it.',
      });
    }

    // Update messages as read
    await Message.update(
      { isRead: true, readAt: new Date() },
      {
        where: {
          id: messageIds,
          conversationId: req.params.id,
          senderId: { [require('sequelize').Op.ne]: req.user.id }, // Don't mark own messages as read
        },
      }
    );

    res.json({
      success: true,
      message: 'Messages marked as read',
    });
  } catch (error) {
    logger.error('Mark messages as read error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while marking messages as read.',
    });
  }
});

module.exports = router;
