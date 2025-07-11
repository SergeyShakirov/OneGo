const express = require('express');
const { body, validationResult, query } = require('express-validator');
const { Op } = require('sequelize');
const { Service, User, Category, Review } = require('../models');
const auth = require('../middleware/auth');
const logger = require('../utils/logger');

const router = express.Router();

// Validation middleware
const createServiceValidation = [
  body('title').trim().isLength({ min: 3, max: 100 }),
  body('description').trim().isLength({ min: 10, max: 1000 }),
  body('price').isFloat({ min: 0 }),
  body('categoryId').isUUID(),
  body('priceType').optional().isIn(['fixed', 'hourly', 'daily']),
  body('duration').optional().isInt({ min: 1 }),
  body('location').optional().trim().isLength({ max: 100 }),
];

// Get all services with filtering and pagination
router.get('/', async (req, res) => {
  try {
    const {
      page = 1,
      limit = 10,
      search,
      categoryId,
      minPrice,
      maxPrice,
      location,
      sortBy = 'createdAt',
      sortOrder = 'DESC',
    } = req.query;

    const offset = (page - 1) * limit;
    const whereClause = { status: 'active' };

    // Search filter
    if (search) {
      whereClause[Op.or] = [
        { title: { [Op.iLike]: `%${search}%` } },
        { description: { [Op.iLike]: `%${search}%` } },
      ];
    }

    // Category filter
    if (categoryId) {
      whereClause.categoryId = categoryId;
    }

    // Price range filter
    if (minPrice || maxPrice) {
      whereClause.price = {};
      if (minPrice) whereClause.price[Op.gte] = minPrice;
      if (maxPrice) whereClause.price[Op.lte] = maxPrice;
    }

    // Location filter
    if (location) {
      whereClause.location = { [Op.iLike]: `%${location}%` };
    }

    const services = await Service.findAndCountAll({
      where: whereClause,
      include: [
        {
          model: User,
          as: 'provider',
          attributes: ['id', 'firstName', 'lastName', 'avatar', 'rating', 'reviewCount'],
        },
        {
          model: Category,
          as: 'category',
          attributes: ['id', 'name', 'slug'],
        },
      ],
      order: [[sortBy, sortOrder]],
      limit: parseInt(limit),
      offset: parseInt(offset),
    });

    res.json({
      success: true,
      services: services.rows,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: services.count,
        totalPages: Math.ceil(services.count / limit),
      },
    });
  } catch (error) {
    logger.error('Get services error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while fetching services.',
    });
  }
});

// Get service by ID
router.get('/:id', async (req, res) => {
  try {
    const service = await Service.findByPk(req.params.id, {
      include: [
        {
          model: User,
          as: 'provider',
          attributes: ['id', 'firstName', 'lastName', 'avatar', 'rating', 'reviewCount', 'bio', 'location'],
        },
        {
          model: Category,
          as: 'category',
          attributes: ['id', 'name', 'slug'],
        },
        {
          model: Review,
          as: 'reviews',
          include: [
            {
              model: User,
              as: 'reviewer',
              attributes: ['id', 'firstName', 'lastName', 'avatar'],
            },
          ],
          order: [['createdAt', 'DESC']],
          limit: 5,
        },
      ],
    });

    if (!service) {
      return res.status(404).json({
        error: 'Service not found',
        message: 'The requested service was not found.',
      });
    }

    res.json({
      success: true,
      service,
    });
  } catch (error) {
    logger.error('Get service by ID error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while fetching the service.',
    });
  }
});

// Create new service (providers only)
router.post('/', auth, createServiceValidation, async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        error: 'Validation Error',
        details: errors.array(),
      });
    }

    // Check if user is a provider
    if (req.user.role !== 'provider' && req.user.role !== 'admin') {
      return res.status(403).json({
        error: 'Forbidden',
        message: 'Only service providers can create services.',
      });
    }

    const {
      title,
      description,
      price,
      categoryId,
      priceType,
      duration,
      location,
      tags,
      requirements,
      cancellationPolicy,
    } = req.body;

    // Verify category exists
    const category = await Category.findByPk(categoryId);
    if (!category) {
      return res.status(400).json({
        error: 'Invalid category',
        message: 'The specified category does not exist.',
      });
    }

    const service = await Service.create({
      title,
      description,
      price,
      categoryId,
      providerId: req.user.id,
      priceType,
      duration,
      location,
      tags: tags || [],
      requirements,
      cancellationPolicy,
    });

    logger.info(`New service created: ${service.title} by ${req.user.email}`);

    res.status(201).json({
      success: true,
      message: 'Service created successfully',
      service,
    });
  } catch (error) {
    logger.error('Create service error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while creating the service.',
    });
  }
});

// Update service (provider only)
router.put('/:id', auth, createServiceValidation, async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        error: 'Validation Error',
        details: errors.array(),
      });
    }

    const service = await Service.findByPk(req.params.id);
    if (!service) {
      return res.status(404).json({
        error: 'Service not found',
        message: 'The requested service was not found.',
      });
    }

    // Check if user owns the service
    if (service.providerId !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        error: 'Forbidden',
        message: 'You can only update your own services.',
      });
    }

    const {
      title,
      description,
      price,
      categoryId,
      priceType,
      duration,
      location,
      tags,
      requirements,
      cancellationPolicy,
      status,
    } = req.body;

    // Verify category exists if being updated
    if (categoryId && categoryId !== service.categoryId) {
      const category = await Category.findByPk(categoryId);
      if (!category) {
        return res.status(400).json({
          error: 'Invalid category',
          message: 'The specified category does not exist.',
        });
      }
    }

    const updates = {};
    if (title !== undefined) updates.title = title;
    if (description !== undefined) updates.description = description;
    if (price !== undefined) updates.price = price;
    if (categoryId !== undefined) updates.categoryId = categoryId;
    if (priceType !== undefined) updates.priceType = priceType;
    if (duration !== undefined) updates.duration = duration;
    if (location !== undefined) updates.location = location;
    if (tags !== undefined) updates.tags = tags;
    if (requirements !== undefined) updates.requirements = requirements;
    if (cancellationPolicy !== undefined) updates.cancellationPolicy = cancellationPolicy;
    if (status !== undefined && req.user.role === 'admin') updates.status = status;

    await service.update(updates);

    logger.info(`Service updated: ${service.title} by ${req.user.email}`);

    res.json({
      success: true,
      message: 'Service updated successfully',
      service,
    });
  } catch (error) {
    logger.error('Update service error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while updating the service.',
    });
  }
});

// Delete service (provider only)
router.delete('/:id', auth, async (req, res) => {
  try {
    const service = await Service.findByPk(req.params.id);
    if (!service) {
      return res.status(404).json({
        error: 'Service not found',
        message: 'The requested service was not found.',
      });
    }

    // Check if user owns the service
    if (service.providerId !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        error: 'Forbidden',
        message: 'You can only delete your own services.',
      });
    }

    await service.destroy();

    logger.info(`Service deleted: ${service.title} by ${req.user.email}`);

    res.json({
      success: true,
      message: 'Service deleted successfully',
    });
  } catch (error) {
    logger.error('Delete service error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while deleting the service.',
    });
  }
});

// Get user's services
router.get('/user/my-services', auth, async (req, res) => {
  try {
    const { page = 1, limit = 10, status } = req.query;
    const offset = (page - 1) * limit;

    const whereClause = { providerId: req.user.id };
    if (status) {
      whereClause.status = status;
    }

    const services = await Service.findAndCountAll({
      where: whereClause,
      include: [
        {
          model: Category,
          as: 'category',
          attributes: ['id', 'name', 'slug'],
        },
      ],
      order: [['createdAt', 'DESC']],
      limit: parseInt(limit),
      offset: parseInt(offset),
    });

    res.json({
      success: true,
      services: services.rows,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: services.count,
        totalPages: Math.ceil(services.count / limit),
      },
    });
  } catch (error) {
    logger.error('Get user services error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while fetching your services.',
    });
  }
});

module.exports = router;
