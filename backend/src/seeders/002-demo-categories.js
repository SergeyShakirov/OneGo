'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.bulkInsert('Categories', [
      // Main categories
      {
        name: 'Beauty & Wellness',
        description: 'Beauty treatments, wellness services, and self-care',
        icon: 'beauty',
        color: '#FF6B9D',
        sortOrder: 1,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        name: 'Home & Garden',
        description: 'Home maintenance, gardening, and repair services',
        icon: 'home',
        color: '#4CAF50',
        sortOrder: 2,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        name: 'Technology',
        description: 'IT support, device repair, and tech consulting',
        icon: 'computer',
        color: '#2196F3',
        sortOrder: 3,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        name: 'Education & Tutoring',
        description: 'Private tutoring, skill development, and educational services',
        icon: 'school',
        color: '#FF9800',
        sortOrder: 4,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        name: 'Health & Fitness',
        description: 'Personal training, therapy, and health services',
        icon: 'fitness',
        color: '#F44336',
        sortOrder: 5,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        name: 'Business Services',
        description: 'Consulting, accounting, marketing, and business support',
        icon: 'business',
        color: '#9C27B0',
        sortOrder: 6,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        name: 'Transportation',
        description: 'Delivery, moving, and transportation services',
        icon: 'directions_car',
        color: '#607D8B',
        sortOrder: 7,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        name: 'Events & Entertainment',
        description: 'Event planning, photography, and entertainment services',
        icon: 'event',
        color: '#E91E63',
        sortOrder: 8,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      }
    ], {});

    // Get the inserted categories for subcategories
    const categories = await queryInterface.sequelize.query(
      `SELECT id, name FROM "Categories" WHERE "parentId" IS NULL;`,
      { type: Sequelize.QueryTypes.SELECT }
    );

    const categoryMap = {};
    categories.forEach(cat => {
      categoryMap[cat.name] = cat.id;
    });

    // Insert subcategories
    await queryInterface.bulkInsert('Categories', [
      // Beauty & Wellness subcategories
      {
        name: 'Hair Services',
        description: 'Hair cuts, styling, coloring, and treatments',
        parentId: categoryMap['Beauty & Wellness'],
        sortOrder: 1,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        name: 'Nail Services',
        description: 'Manicures, pedicures, and nail art',
        parentId: categoryMap['Beauty & Wellness'],
        sortOrder: 2,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        name: 'Skincare',
        description: 'Facials, skin treatments, and beauty consultations',
        parentId: categoryMap['Beauty & Wellness'],
        sortOrder: 3,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        name: 'Massage Therapy',
        description: 'Relaxation and therapeutic massage services',
        parentId: categoryMap['Beauty & Wellness'],
        sortOrder: 4,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      // Home & Garden subcategories
      {
        name: 'Cleaning Services',
        description: 'House cleaning, deep cleaning, and maintenance',
        parentId: categoryMap['Home & Garden'],
        sortOrder: 1,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        name: 'Handyman Services',
        description: 'General repairs, installations, and maintenance',
        parentId: categoryMap['Home & Garden'],
        sortOrder: 2,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        name: 'Gardening & Landscaping',
        description: 'Garden maintenance, landscaping, and plant care',
        parentId: categoryMap['Home & Garden'],
        sortOrder: 3,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      // Technology subcategories
      {
        name: 'Computer Repair',
        description: 'PC and laptop repair, troubleshooting, and maintenance',
        parentId: categoryMap['Technology'],
        sortOrder: 1,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        name: 'Mobile Device Repair',
        description: 'Smartphone and tablet repair services',
        parentId: categoryMap['Technology'],
        sortOrder: 2,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        name: 'IT Support',
        description: 'Technical support, network setup, and consulting',
        parentId: categoryMap['Technology'],
        sortOrder: 3,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      // Education & Tutoring subcategories
      {
        name: 'Academic Tutoring',
        description: 'Subject-specific tutoring and homework help',
        parentId: categoryMap['Education & Tutoring'],
        sortOrder: 1,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        name: 'Language Learning',
        description: 'Foreign language instruction and conversation practice',
        parentId: categoryMap['Education & Tutoring'],
        sortOrder: 2,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        name: 'Music Lessons',
        description: 'Private music instruction for various instruments',
        parentId: categoryMap['Education & Tutoring'],
        sortOrder: 3,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      // Health & Fitness subcategories
      {
        name: 'Personal Training',
        description: 'One-on-one fitness coaching and workout sessions',
        parentId: categoryMap['Health & Fitness'],
        sortOrder: 1,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        name: 'Yoga & Pilates',
        description: 'Private yoga and pilates instruction',
        parentId: categoryMap['Health & Fitness'],
        sortOrder: 2,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        name: 'Nutrition Counseling',
        description: 'Dietary advice and meal planning services',
        parentId: categoryMap['Health & Fitness'],
        sortOrder: 3,
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
      }
    ], {});
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('Categories', null, {});
  }
};
