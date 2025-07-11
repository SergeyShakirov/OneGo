// Test setup - use SQLite for testing
const sequelize = require('../src/config/database.test');

beforeAll(async () => {
  // Connect to test database
  await sequelize.authenticate();
});

afterAll(async () => {
  // Close database connection
  await sequelize.close();
});
