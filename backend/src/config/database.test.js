const { Sequelize } = require('sequelize');

// Test database configuration using SQLite
const sequelize = new Sequelize({
  dialect: 'sqlite',
  storage: ':memory:', // Use in-memory database for tests
  logging: false // Disable logging for cleaner test output
});

module.exports = sequelize;
