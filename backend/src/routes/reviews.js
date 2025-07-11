const express = require('express');
const { body, validationResult } = require('express-validator');
const { Review, Booking, User, Service } = require('../models');
const auth = require('../middleware/auth');
const logger = require('../utils/logger');

const router = express.Router();

// Create review
router.post('/', auth, [
  body('bookingId').isUUID(),
  body('rating').isInt({ min: 1, max: 5 }),
  body('comment').optional().trim().isLength({ max: 1000 }),
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        error: 'Validation Error',
        details: errors.array(),
      });
    }

    const { bookingId, rating, comment } = req.body;

    // Check if booking exists and user is the customer
    const booking = await Booking.findByPk(bookingId, {
      include: [
        {
          model: Service,
          as: 'service',
          include: [
            {
              model: User,
              as: 'provider',
            },
          ],
        },
      ],
    });

    if (!booking) {
      return res.status(404).json({
        error: 'Booking not found',
        message: 'The specified booking was not found.',
      });
    }

    if (booking.customerId !== req.user.id) {
      return res.status(403).json({
        error: 'Forbidden',
        message: 'You can only review bookings you made.',
      });
    }

    if (booking.status !== 'completed') {
      return res.status(400).json({
        error: 'Invalid booking status',
        message: 'You can only review completed bookings.',
      });
    }

    // Check if review already exists
    const existingReview = await Review.findOne({ where: { bookingId } });
    if (existingReview) {
      return res.status(409).json({
        error: 'Review exists',
        message: 'You have already reviewed this booking.',
      });
    }

    const review = await Review.create({
      bookingId,
      serviceId: booking.serviceId,
      reviewerId: req.user.id,
      rating,
      comment,
    });

    // Update service rating
    const service = booking.service;
    const reviews = await Review.findAll({
      where: { serviceId: service.id },
      attributes: ['rating'],
    });

    const avgRating = reviews.reduce((sum, r) => sum + r.rating, 0) / reviews.length;
    await service.update({
      rating: avgRating,
      reviewCount: reviews.length,
    });

    // Update provider rating
    const provider = service.provider;
    const allProviderReviews = await Review.findAll({
      include: [
        {
          model: Service,
          as: 'service',
          where: { providerId: provider.id },
        },
      ],
      attributes: ['rating'],
    });

    const providerAvgRating = allProviderReviews.reduce((sum, r) => sum + r.rating, 0) / allProviderReviews.length;
    await provider.update({
      rating: providerAvgRating,
      reviewCount: allProviderReviews.length,
    });

    logger.info(`New review created for booking ${bookingId} by ${req.user.email}`);

    res.status(201).json({
      success: true,
      message: 'Review created successfully',
      review,
    });
  } catch (error) {
    logger.error('Create review error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while creating the review.',
    });
  }
});

// Get reviews for a service
router.get('/service/:serviceId', async (req, res) => {
  try {
    const { page = 1, limit = 10 } = req.query;
    const offset = (page - 1) * limit;

    const reviews = await Review.findAndCountAll({
      where: { 
        serviceId: req.params.serviceId,
        isPublic: true,
      },
      include: [
        {
          model: User,
          as: 'reviewer',
          attributes: ['id', 'firstName', 'lastName', 'avatar'],
        },
        {
          model: Booking,
          as: 'booking',
          attributes: ['id', 'bookingNumber', 'createdAt'],
        },
      ],
      order: [['createdAt', 'DESC']],
      limit: parseInt(limit),
      offset: parseInt(offset),
    });

    res.json({
      success: true,
      reviews: reviews.rows,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: reviews.count,
        totalPages: Math.ceil(reviews.count / limit),
      },
    });
  } catch (error) {
    logger.error('Get service reviews error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while fetching reviews.',
    });
  }
});

// Update review
router.put('/:id', auth, [
  body('rating').optional().isInt({ min: 1, max: 5 }),
  body('comment').optional().trim().isLength({ max: 1000 }),
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        error: 'Validation Error',
        details: errors.array(),
      });
    }

    const review = await Review.findByPk(req.params.id);
    if (!review) {
      return res.status(404).json({
        error: 'Review not found',
        message: 'The requested review was not found.',
      });
    }

    if (review.reviewerId !== req.user.id) {
      return res.status(403).json({
        error: 'Forbidden',
        message: 'You can only update your own reviews.',
      });
    }

    const { rating, comment } = req.body;
    const updates = {};
    if (rating !== undefined) updates.rating = rating;
    if (comment !== undefined) updates.comment = comment;

    await review.update(updates);

    logger.info(`Review updated: ${review.id} by ${req.user.email}`);

    res.json({
      success: true,
      message: 'Review updated successfully',
      review,
    });
  } catch (error) {
    logger.error('Update review error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while updating the review.',
    });
  }
});

// Provider response to review
router.put('/:id/response', auth, [
  body('response').trim().isLength({ min: 1, max: 500 }),
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        error: 'Validation Error',
        details: errors.array(),
      });
    }

    const review = await Review.findByPk(req.params.id, {
      include: [
        {
          model: Service,
          as: 'service',
          attributes: ['providerId'],
        },
      ],
    });

    if (!review) {
      return res.status(404).json({
        error: 'Review not found',
        message: 'The requested review was not found.',
      });
    }

    if (review.service.providerId !== req.user.id) {
      return res.status(403).json({
        error: 'Forbidden',
        message: 'You can only respond to reviews for your own services.',
      });
    }

    const { response } = req.body;

    await review.update({
      responseFromProvider: response,
      respondedAt: new Date(),
    });

    logger.info(`Provider responded to review: ${review.id} by ${req.user.email}`);

    res.json({
      success: true,
      message: 'Response added successfully',
      review,
    });
  } catch (error) {
    logger.error('Provider response error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while adding the response.',
    });
  }
});

module.exports = router;
