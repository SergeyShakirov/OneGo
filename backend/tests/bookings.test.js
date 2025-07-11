const request = require('supertest');
const jwt = require('jsonwebtoken');
const app = require('../src/index');
const sequelize = require('../src/config/database.test');
const { User, Service, Category, Booking } = require('../src/models');

describe('Bookings API', () => {
  let authToken;
  let providerToken;
  let user;
  let provider;
  let category;
  let service;

  beforeAll(async () => {
    await sequelize.sync({ force: true });
    
    // Create test user
    user = await User.create({
      email: 'user@example.com',
      password: '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj7.K5YSZnYm', // password123
      firstName: 'Test',
      lastName: 'User',
      role: 'user',
      isActive: true
    });
    
    // Create test provider
    provider = await User.create({
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
    
    // Create test service
    service = await Service.create({
      title: 'Test Service',
      description: 'Test service description',
      price: 100.00,
      duration: 60,
      providerId: provider.id,
      categoryId: category.id,
      status: 'active'
    });
    
    // Generate auth tokens
    authToken = jwt.sign(
      { userId: user.id, email: user.email, role: user.role },
      process.env.JWT_SECRET || 'test-secret',
      { expiresIn: '1h' }
    );
    
    providerToken = jwt.sign(
      { userId: provider.id, email: provider.email, role: provider.role },
      process.env.JWT_SECRET || 'test-secret',
      { expiresIn: '1h' }
    );
  });

  afterAll(async () => {
    await sequelize.close();
  });

  beforeEach(async () => {
    await Booking.destroy({ where: {} });
  });

  describe('POST /api/v1/bookings', () => {
    it('should create a new booking successfully', async () => {
      const bookingData = {
        serviceId: service.id,
        scheduledAt: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(), // Tomorrow
        duration: 60,
        notes: 'Test booking notes'
      };

      const response = await request(app)
        .post('/api/v1/bookings')
        .set('Authorization', `Bearer ${authToken}`)
        .send(bookingData)
        .expect(201);

      expect(response.body.serviceId).toBe(service.id);
      expect(response.body.userId).toBe(user.id);
      expect(response.body.providerId).toBe(provider.id);
      expect(response.body.status).toBe('pending');
      expect(response.body.paymentStatus).toBe('pending');
      expect(response.body.totalAmount).toBe('100.00');
    });

    it('should return 401 for unauthorized request', async () => {
      const bookingData = {
        serviceId: service.id,
        scheduledAt: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(),
        duration: 60
      };

      const response = await request(app)
        .post('/api/v1/bookings')
        .send(bookingData)
        .expect(401);

      expect(response.body).toHaveProperty('error');
    });

    it('should return 400 for missing required fields', async () => {
      const bookingData = {
        serviceId: service.id,
        // Missing scheduledAt, duration
      };

      const response = await request(app)
        .post('/api/v1/bookings')
        .set('Authorization', `Bearer ${authToken}`)
        .send(bookingData)
        .expect(400);

      expect(response.body).toHaveProperty('error');
    });

    it('should return 400 for past scheduled time', async () => {
      const bookingData = {
        serviceId: service.id,
        scheduledAt: new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString(), // Yesterday
        duration: 60
      };

      const response = await request(app)
        .post('/api/v1/bookings')
        .set('Authorization', `Bearer ${authToken}`)
        .send(bookingData)
        .expect(400);

      expect(response.body).toHaveProperty('error');
    });
  });

  describe('GET /api/v1/bookings', () => {
    beforeEach(async () => {
      // Create test bookings
      await Booking.bulkCreate([
        {
          serviceId: service.id,
          userId: user.id,
          providerId: provider.id,
          scheduledAt: new Date(Date.now() + 24 * 60 * 60 * 1000),
          duration: 60,
          totalAmount: 100.00,
          status: 'pending'
        },
        {
          serviceId: service.id,
          userId: user.id,
          providerId: provider.id,
          scheduledAt: new Date(Date.now() + 48 * 60 * 60 * 1000),
          duration: 60,
          totalAmount: 100.00,
          status: 'confirmed'
        }
      ]);
    });

    it('should return user bookings', async () => {
      const response = await request(app)
        .get('/api/v1/bookings')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body).toHaveProperty('bookings');
      expect(response.body.bookings).toHaveLength(2);
      expect(response.body).toHaveProperty('pagination');
    });

    it('should filter bookings by status', async () => {
      const response = await request(app)
        .get('/api/v1/bookings?status=confirmed')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body.bookings).toHaveLength(1);
      expect(response.body.bookings[0].status).toBe('confirmed');
    });

    it('should return provider bookings', async () => {
      const response = await request(app)
        .get('/api/v1/bookings')
        .set('Authorization', `Bearer ${providerToken}`)
        .expect(200);

      expect(response.body.bookings).toHaveLength(2);
      // Provider should see bookings for their services
      response.body.bookings.forEach(booking => {
        expect(booking.providerId).toBe(provider.id);
      });
    });
  });

  describe('GET /api/v1/bookings/:id', () => {
    let booking;

    beforeEach(async () => {
      booking = await Booking.create({
        serviceId: service.id,
        userId: user.id,
        providerId: provider.id,
        scheduledAt: new Date(Date.now() + 24 * 60 * 60 * 1000),
        duration: 60,
        totalAmount: 100.00,
        status: 'pending'
      });
    });

    it('should return booking by ID for user', async () => {
      const response = await request(app)
        .get(`/api/v1/bookings/${booking.id}`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body.id).toBe(booking.id);
      expect(response.body.userId).toBe(user.id);
      expect(response.body).toHaveProperty('service');
      expect(response.body).toHaveProperty('provider');
    });

    it('should return booking by ID for provider', async () => {
      const response = await request(app)
        .get(`/api/v1/bookings/${booking.id}`)
        .set('Authorization', `Bearer ${providerToken}`)
        .expect(200);

      expect(response.body.id).toBe(booking.id);
      expect(response.body.providerId).toBe(provider.id);
    });

    it('should return 404 for non-existent booking', async () => {
      const response = await request(app)
        .get('/api/v1/bookings/999')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(404);

      expect(response.body).toHaveProperty('error');
    });
  });

  describe('PUT /api/v1/bookings/:id/status', () => {
    let booking;

    beforeEach(async () => {
      booking = await Booking.create({
        serviceId: service.id,
        userId: user.id,
        providerId: provider.id,
        scheduledAt: new Date(Date.now() + 24 * 60 * 60 * 1000),
        duration: 60,
        totalAmount: 100.00,
        status: 'pending'
      });
    });

    it('should allow provider to confirm booking', async () => {
      const response = await request(app)
        .put(`/api/v1/bookings/${booking.id}/status`)
        .set('Authorization', `Bearer ${providerToken}`)
        .send({ status: 'confirmed' })
        .expect(200);

      expect(response.body.status).toBe('confirmed');
    });

    it('should allow user to cancel booking', async () => {
      const response = await request(app)
        .put(`/api/v1/bookings/${booking.id}/status`)
        .set('Authorization', `Bearer ${authToken}`)
        .send({ status: 'cancelled', cancellationReason: 'Changed my mind' })
        .expect(200);

      expect(response.body.status).toBe('cancelled');
      expect(response.body.cancellationReason).toBe('Changed my mind');
      expect(response.body.cancelledBy).toBe(user.id);
    });

    it('should return 400 for invalid status transition', async () => {
      // Try to set booking to completed without going through confirmed
      const response = await request(app)
        .put(`/api/v1/bookings/${booking.id}/status`)
        .set('Authorization', `Bearer ${providerToken}`)
        .send({ status: 'completed' })
        .expect(400);

      expect(response.body).toHaveProperty('error');
    });

    it('should return 403 for unauthorized status change', async () => {
      // User tries to confirm booking (only provider can)
      const response = await request(app)
        .put(`/api/v1/bookings/${booking.id}/status`)
        .set('Authorization', `Bearer ${authToken}`)
        .send({ status: 'confirmed' })
        .expect(403);

      expect(response.body).toHaveProperty('error');
    });
  });
});
