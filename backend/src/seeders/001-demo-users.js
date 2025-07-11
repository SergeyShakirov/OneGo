'use strict';

const bcrypt = require('bcrypt');

module.exports = {
  async up(queryInterface, Sequelize) {
    const hashedPassword = await bcrypt.hash('admin123', 12);
    
    await queryInterface.bulkInsert('Users', [
      {
        email: 'admin@onego.com',
        password: hashedPassword,
        firstName: 'Admin',
        lastName: 'User',
        phone: '+1234567890',
        role: 'admin',
        isActive: true,
        emailVerifiedAt: new Date(),
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        email: 'john.doe@example.com',
        password: await bcrypt.hash('password123', 12),
        firstName: 'John',
        lastName: 'Doe',
        phone: '+1234567891',
        role: 'provider',
        isActive: true,
        emailVerifiedAt: new Date(),
        city: 'New York',
        country: 'USA',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        email: 'jane.smith@example.com',
        password: await bcrypt.hash('password123', 12),
        firstName: 'Jane',
        lastName: 'Smith',
        phone: '+1234567892',
        role: 'provider',
        isActive: true,
        emailVerifiedAt: new Date(),
        city: 'Los Angeles',
        country: 'USA',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        email: 'mike.johnson@example.com',
        password: await bcrypt.hash('password123', 12),
        firstName: 'Mike',
        lastName: 'Johnson',
        phone: '+1234567893',
        role: 'user',
        isActive: true,
        emailVerifiedAt: new Date(),
        city: 'Chicago',
        country: 'USA',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        email: 'sarah.wilson@example.com',
        password: await bcrypt.hash('password123', 12),
        firstName: 'Sarah',
        lastName: 'Wilson',
        phone: '+1234567894',
        role: 'user',
        isActive: true,
        emailVerifiedAt: new Date(),
        city: 'Miami',
        country: 'USA',
        createdAt: new Date(),
        updatedAt: new Date()
      }
    ], {});
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('Users', null, {});
  }
};
