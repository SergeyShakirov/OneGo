const request = require('supertest');
const jwt = require('jsonwebtoken');
const app = require('../src/index');
const sequelize = require('../src/config/database.test');
const { User, Service, Category } = require('../src/models');

describe('Services API', () => {
  let authToken;
  let user;
  let category;

  beforeAll(async () => {
    await sequelize.sync({ force: true });
    
    // Create test user
    user = await User.create({
      email: 'provider@example.com',
      password: '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj7.K5YSZnYm', // password123
      firstName: 'Provider',
      lastName: 'User',
      role: 'provider',
      isActive: true
    });
    
    // Create test category
    category = await Category.create({
      name: 'Test Category',
      description: 'Test category description',
      isActive: true
    });
    
    // Generate auth token
    authToken = jwt.sign(
      { userId: user.id, email: user.email, role: user.role },
      process.env.JWT_SECRET || 'test-secret',
      { expiresIn: '1h' }
    );
  });

  afterAll(async () => {
    await sequelize.close();
  });

  beforeEach(async () => {
    await Service.destroy({ where: {} });
  });

  describe('GET /api/v1/services', () => {
    beforeEach(async () => {
      // Create test services
      await Service.bulkCreate([
        {
          title: 'Service 1',
          description: 'Description 1',
          price: 50.00,
          providerId: user.id,
          categoryId: category.id,
          status: 'active'
        },
        {
          title: 'Service 2',
          description: 'Description 2',
          price: 75.00,
          providerId: user.id,
          categoryId: category.id,
          status: 'active'
        }
      ]);
    });

    it('should return all services', async () => {
      const response = await request(app)
        .get('/api/v1/services')
        .expect(200);

      expect(response.body).toHaveProperty('services');
      expect(response.body.services).toHaveLength(2);
      expect(response.body).toHaveProperty('pagination');
    });

    it('should filter services by category', async () => {
      const response = await request(app)
        .get(`/api/v1/services?categoryId=${category.id}`)
        .expect(200);

      expect(response.body.services).toHaveLength(2);
      response.body.services.forEach(service => {
        expect(service.categoryId).toBe(category.id);
      });
    });

    it('should filter services by price range', async () => {
      const response = await request(app)
        .get('/api/v1/services?minPrice=60&maxPrice=80')
        .expect(200);

      expect(response.body.services).toHaveLength(1);
      expect(response.body.services[0].price).toBe('75.00');
    });

    it('should search services by title', async () => {
      const response = await request(app)
        .get('/api/v1/services?search=Service 1')
        .expect(200);

      expect(response.body.services).toHaveLength(1);
      expect(response.body.services[0].title).toBe('Service 1');
    });
  });

  describe('GET /api/v1/services/:id', () => {
    let service;

    beforeEach(async () => {
      service = await Service.create({
        title: 'Test Service',
        description: 'Test description',
        price: 100.00,
        providerId: user.id,
        categoryId: category.id,
        status: 'active'
      });
    });

    it('should return service by ID', async () => {
      const response = await request(app)
        .get(`/api/v1/services/${service.id}`)
        .expect(200);

      expect(response.body.id).toBe(service.id);
      expect(response.body.title).toBe('Test Service');
      expect(response.body).toHaveProperty('provider');
      expect(response.body).toHaveProperty('category');
    });

    it('should return 404 for non-existent service', async () => {
      const response = await request(app)
        .get('/api/v1/services/999')
        .expect(404);

      expect(response.body).toHaveProperty('error');
    });
  });

  describe('POST /api/v1/services', () => {
    it('should create a new service successfully', async () => {
      const serviceData = {
        title: 'New Service',
        description: 'New service description',
        price: 85.00,
        categoryId: category.id,
        duration: 60,
        location: 'Test Location'
      };

      const response = await request(app)
        .post('/api/v1/services')
        .set('Authorization', `Bearer ${authToken}`)
        .send(serviceData)
        .expect(201);

      expect(response.body.title).toBe(serviceData.title);
      expect(response.body.description).toBe(serviceData.description);
      expect(response.body.price).toBe(serviceData.price.toString());
      expect(response.body.providerId).toBe(user.id);
    });

    it('should return 401 for unauthorized request', async () => {
      const serviceData = {
        title: 'New Service',
        description: 'New service description',
        price: 85.00,
        categoryId: category.id
      };

      const response = await request(app)
        .post('/api/v1/services')
        .send(serviceData)
        .expect(401);

      expect(response.body).toHaveProperty('error');
    });

    it('should return 400 for missing required fields', async () => {
      const serviceData = {
        title: 'New Service',
        // Missing description, price, categoryId
      };

      const response = await request(app)
        .post('/api/v1/services')
        .set('Authorization', `Bearer ${authToken}`)
        .send(serviceData)
        .expect(400);

      expect(response.body).toHaveProperty('error');
    });
  });

  describe('PUT /api/v1/services/:id', () => {
    let service;

    beforeEach(async () => {
      service = await Service.create({
        title: 'Original Service',
        description: 'Original description',
        price: 50.00,
        providerId: user.id,
        categoryId: category.id,
        status: 'active'
      });
    });

    it('should update service successfully', async () => {
      const updateData = {
        title: 'Updated Service',
        description: 'Updated description',
        price: 75.00
      };

      const response = await request(app)
        .put(`/api/v1/services/${service.id}`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(updateData)
        .expect(200);

      expect(response.body.title).toBe(updateData.title);
      expect(response.body.description).toBe(updateData.description);
      expect(response.body.price).toBe(updateData.price.toString());
    });

    it('should return 404 for non-existent service', async () => {
      const updateData = {
        title: 'Updated Service'
      };

      const response = await request(app)
        .put('/api/v1/services/999')
        .set('Authorization', `Bearer ${authToken}`)
        .send(updateData)
        .expect(404);

      expect(response.body).toHaveProperty('error');
    });

    it('should return 403 for unauthorized update', async () => {
      // Create another user
      const anotherUser = await User.create({
        email: 'another@example.com',
        password: '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj7.K5YSZnYm',
        firstName: 'Another',
        lastName: 'User',
        role: 'provider',
        isActive: true
      });

      const anotherToken = jwt.sign(
        { userId: anotherUser.id, email: anotherUser.email, role: anotherUser.role },
        process.env.JWT_SECRET || 'test-secret',
        { expiresIn: '1h' }
      );

      const updateData = {
        title: 'Updated Service'
      };

      const response = await request(app)
        .put(`/api/v1/services/${service.id}`)
        .set('Authorization', `Bearer ${anotherToken}`)
        .send(updateData)
        .expect(403);

      expect(response.body).toHaveProperty('error');
    });
  });

  describe('DELETE /api/v1/services/:id', () => {
    let service;

    beforeEach(async () => {
      service = await Service.create({
        title: 'Test Service',
        description: 'Test description',
        price: 50.00,
        providerId: user.id,
        categoryId: category.id,
        status: 'active'
      });
    });

    it('should delete service successfully', async () => {
      const response = await request(app)
        .delete(`/api/v1/services/${service.id}`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body).toHaveProperty('message');

      // Verify service is deleted
      const deletedService = await Service.findByPk(service.id);
      expect(deletedService).toBeNull();
    });

    it('should return 404 for non-existent service', async () => {
      const response = await request(app)
        .delete('/api/v1/services/999')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(404);

      expect(response.body).toHaveProperty('error');
    });
  });
});
