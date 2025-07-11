const express = require('express');
const { Category } = require('../models');
const auth = require('../middleware/auth');
const logger = require('../utils/logger');

const router = express.Router();

// Get all categories
router.get('/', async (req, res) => {
  try {
    const categories = await Category.findAll({
      where: { isActive: true },
      order: [['sortOrder', 'ASC'], ['name', 'ASC']],
    });

    res.json({
      success: true,
      categories,
    });
  } catch (error) {
    logger.error('Get categories error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while fetching categories.',
    });
  }
});

// Get category by ID
router.get('/:id', async (req, res) => {
  try {
    const category = await Category.findByPk(req.params.id);

    if (!category) {
      return res.status(404).json({
        error: 'Category not found',
        message: 'The requested category was not found.',
      });
    }

    res.json({
      success: true,
      category,
    });
  } catch (error) {
    logger.error('Get category by ID error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while fetching the category.',
    });
  }
});

// Create category (admin only)
router.post('/', auth, async (req, res) => {
  try {
    if (req.user.role !== 'admin') {
      return res.status(403).json({
        error: 'Forbidden',
        message: 'Only administrators can create categories.',
      });
    }

    const { name, slug, description, icon, sortOrder } = req.body;

    const category = await Category.create({
      name,
      slug,
      description,
      icon,
      sortOrder: sortOrder || 0,
    });

    logger.info(`New category created: ${category.name} by ${req.user.email}`);

    res.status(201).json({
      success: true,
      message: 'Category created successfully',
      category,
    });
  } catch (error) {
    logger.error('Create category error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while creating the category.',
    });
  }
});

// Update category (admin only)
router.put('/:id', auth, async (req, res) => {
  try {
    if (req.user.role !== 'admin') {
      return res.status(403).json({
        error: 'Forbidden',
        message: 'Only administrators can update categories.',
      });
    }

    const category = await Category.findByPk(req.params.id);
    if (!category) {
      return res.status(404).json({
        error: 'Category not found',
        message: 'The requested category was not found.',
      });
    }

    const { name, slug, description, icon, sortOrder, isActive } = req.body;

    const updates = {};
    if (name !== undefined) updates.name = name;
    if (slug !== undefined) updates.slug = slug;
    if (description !== undefined) updates.description = description;
    if (icon !== undefined) updates.icon = icon;
    if (sortOrder !== undefined) updates.sortOrder = sortOrder;
    if (isActive !== undefined) updates.isActive = isActive;

    await category.update(updates);

    logger.info(`Category updated: ${category.name} by ${req.user.email}`);

    res.json({
      success: true,
      message: 'Category updated successfully',
      category,
    });
  } catch (error) {
    logger.error('Update category error:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'An error occurred while updating the category.',
    });
  }
});

module.exports = router;
