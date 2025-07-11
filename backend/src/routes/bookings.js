const express = require('express');
const { body, validationResult } = require('express-validator');
const { Booking, Service, User } = require('../models');
const auth = require('../middleware/auth');
const logger = require('../utils/logger');

const router = express.Router();

// Validation middleware
const createBookingValidation = [
  body('serviceId').isUUID(),
  body('startDate').isISO8601(),
  body('endDate').optional().isISO8601(),
  body('notes').optional().trim().isLength({ max: 500 }),
];

// Get user bookings
router.get('/', auth, async (req, res) => {
  try {
    const { page = 1, limit = 10, status, role = 'customer' } = req.query;
    const offset = (page - 1) * limit;

    let whereClause = {};
    if (role === 'customer') {
      whereClause.customerId = req.user.id;
    } else if (role === 'provider') {
      whereClause.providerId = req.user.id;
    }

    if (status) {
      whereClause.status = status;
    }

    const bookings = await Booking.findAndCountAll({
      where: whereClause,
      include: [
        {
          model: Service,
          as: 'service',
          attributes: ['id', 'title', 'price', 'priceType', 'images'],
        },
        {
          model: User,
          as: 'customer',
          attributes: ['id', 'firstName', 'lastName', 'avatar', 'phone'],
        },
        {
          model: User,
          as: 'provider',
          attributes: ['id', 'firstName', 'lastName', 'avatar', 'phone'],
        },
      ],
      order: [['createdAt', 'DESC']],
      limit: parseInt(limit),
      offset: parseInt(offset),
    });

    res.json({
      success: true,
      bookings: bookings.rows,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: bookings.count,
        totalPages: Math.ceil(bookings.count / limit),
      },
    });
  } catch (error) {
    logger.error('Get bookings error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while fetching bookings.',
    });
  }
});

// Get booking by ID
router.get('/:id', auth, async (req, res) => {
  try {
    const booking = await Booking.findByPk(req.params.id, {
      include: [
        {
          model: Service,
          as: 'service',
          include: [
            {
              model: User,
              as: 'provider',
              attributes: ['id', 'firstName', 'lastName', 'avatar', 'phone', 'rating'],
            },
          ],
        },
        {
          model: User,
          as: 'customer',
          attributes: ['id', 'firstName', 'lastName', 'avatar', 'phone'],
        },
        {
          model: User,
          as: 'provider',
          attributes: ['id', 'firstName', 'lastName', 'avatar', 'phone'],
        },
      ],
    });

    if (!booking) {
      return res.status(404).json({
        error: 'Booking not found',
        message: 'The requested booking was not found.',
      });
    }

    // Check if user has access to this booking
    if (booking.customerId !== req.user.id && booking.providerId !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        error: 'Forbidden',
        message: 'You do not have access to this booking.',
      });
    }

    res.json({
      success: true,
      booking,
    });
  } catch (error) {
    logger.error('Get booking by ID error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while fetching the booking.',
    });
  }
});

// Create new booking
router.post('/', auth, createBookingValidation, async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        error: 'Validation Error',
        details: errors.array(),
      });
    }

    const { serviceId, startDate, endDate, notes } = req.body;

    // Get service details
    const service = await Service.findByPk(serviceId, {
      include: [
        {
          model: User,
          as: 'provider',
          attributes: ['id', 'firstName', 'lastName', 'email'],
        },
      ],
    });

    if (!service) {
      return res.status(404).json({
        error: 'Service not found',
        message: 'The requested service was not found.',
      });
    }

    if (service.status !== 'active') {
      return res.status(400).json({
        error: 'Service unavailable',
        message: 'This service is currently unavailable for booking.',
      });
    }

    // Calculate total price
    let totalPrice = service.price;
    if (service.priceType === 'hourly' && endDate) {
      const hours = Math.ceil((new Date(endDate) - new Date(startDate)) / (1000 * 60 * 60));
      totalPrice = service.price * hours;
    } else if (service.priceType === 'daily' && endDate) {
      const days = Math.ceil((new Date(endDate) - new Date(startDate)) / (1000 * 60 * 60 * 24));
      totalPrice = service.price * days;
    }

    const booking = await Booking.create({
      serviceId,
      customerId: req.user.id,
      providerId: service.providerId,
      startDate,
      endDate,
      totalPrice,
      notes,
    });

    // Update service booking count
    await service.increment('bookingCount');

    logger.info(`New booking created: ${booking.bookingNumber} by ${req.user.email}`);

    res.status(201).json({
      success: true,
      message: 'Booking created successfully',
      booking,
    });
  } catch (error) {
    logger.error('Create booking error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while creating the booking.',
    });
  }
});

// Update booking status
router.put('/:id/status', auth, [
  body('status').isIn(['pending', 'confirmed', 'in_progress', 'completed', 'cancelled']),
  body('notes').optional().trim(),
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        error: 'Validation Error',
        details: errors.array(),
      });
    }

    const { status, notes } = req.body;

    const booking = await Booking.findByPk(req.params.id);
    if (!booking) {
      return res.status(404).json({
        error: 'Booking not found',
        message: 'The requested booking was not found.',
      });
    }

    // Check permissions
    const canUpdate = (
      (booking.providerId === req.user.id && ['confirmed', 'in_progress', 'completed'].includes(status)) ||
      (booking.customerId === req.user.id && status === 'cancelled') ||
      req.user.role === 'admin'
    );

    if (!canUpdate) {
      return res.status(403).json({
        error: 'Forbidden',
        message: 'You do not have permission to update this booking status.',
      });
    }

    const updates = { status };
    
    if (status === 'completed') {
      updates.completedAt = new Date();
    } else if (status === 'cancelled') {
      updates.cancelledAt = new Date();
      if (notes) updates.cancellationReason = notes;
    }

    if (notes && booking.providerId === req.user.id) {
      updates.providerNotes = notes;
    } else if (notes && booking.customerId === req.user.id) {
      updates.customerNotes = notes;
    }

    await booking.update(updates);

    logger.info(`Booking status updated: ${booking.bookingNumber} to ${status} by ${req.user.email}`);

    res.json({
      success: true,
      message: 'Booking status updated successfully',
      booking,
    });
  } catch (error) {
    logger.error('Update booking status error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while updating the booking status.',
    });
  }
});

// Cancel booking
router.delete('/:id', auth, async (req, res) => {
  try {
    const { reason } = req.body;

    const booking = await Booking.findByPk(req.params.id);
    if (!booking) {
      return res.status(404).json({
        error: 'Booking not found',
        message: 'The requested booking was not found.',
      });
    }

    // Check if user can cancel this booking
    if (booking.customerId !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        error: 'Forbidden',
        message: 'You can only cancel your own bookings.',
      });
    }

    if (booking.status === 'completed' || booking.status === 'cancelled') {
      return res.status(400).json({
        error: 'Cannot cancel',
        message: 'This booking cannot be cancelled.',
      });
    }

    await booking.update({
      status: 'cancelled',
      cancelledAt: new Date(),
      cancellationReason: reason,
    });

    logger.info(`Booking cancelled: ${booking.bookingNumber} by ${req.user.email}`);

    res.json({
      success: true,
      message: 'Booking cancelled successfully',
    });
  } catch (error) {
    logger.error('Cancel booking error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while cancelling the booking.',
    });
  }
});

module.exports = router;
