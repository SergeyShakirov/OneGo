# OneGo Backend API

A comprehensive Node.js backend for the OneGo service marketplace platform, built with Express.js, PostgreSQL, and Socket.IO.

## 🚀 Features

### Core Functionality
- **User Management**: Complete authentication with JWT tokens, role-based access control
- **Service Marketplace**: Create, browse, and manage service listings with categories
- **Booking System**: End-to-end booking management with status tracking
- **Review System**: Rate and review services with aggregated ratings
- **Real-time Chat**: Socket.IO powered messaging between users
- **File Uploads**: Handle service images and user avatars
- **Email Notifications**: Automated emails for bookings and updates

### Technical Features
- **RESTful API**: Well-structured REST endpoints with proper HTTP methods
- **Real-time Communication**: WebSocket integration for live chat
- **Database Management**: PostgreSQL with Sequelize ORM
- **API Documentation**: Comprehensive Swagger/OpenAPI documentation
- **Testing Suite**: Jest tests with high coverage
- **Logging**: Winston-based structured logging
- **Security**: JWT authentication, input validation, rate limiting
- **File Storage**: Multer integration for file uploads
- **Environment Configuration**: Support for multiple environments

## Tech Stack

- **Node.js** - Runtime environment
- **Express.js** - Web framework
- **PostgreSQL** - Primary database
- **Redis** - Caching and sessions
- **Socket.io** - Real-time communication
- **JWT** - Authentication
- **Docker** - Containerization

## Features

- User authentication and authorization
- Service CRUD operations
- Booking system
- Real-time chat
- File upload handling
- Email notifications
- Rate limiting
- API documentation

## Quick Start

### Using Docker (Recommended)

```bash
# Clone the repository
git clone https://github.com/SergeyShakirov/OneGo.git
cd OneGo/backend

# Start all services
docker-compose up -d

# API will be available at http://localhost:3000
```

### Manual Setup

1. Install dependencies:
```bash
npm install
```

2. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your configuration
```

3. Set up PostgreSQL database:
```bash
# Create database
createdb onego_db

# Run migrations
npm run migrate

# Seed initial data
npm run seed
```

4. Start the server:
```bash
# Development
npm run dev

# Production
npm start
```

## API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login user
- `POST /api/v1/auth/refresh` - Refresh JWT token
- `POST /api/v1/auth/logout` - Logout user

### Users
- `GET /api/v1/users/profile` - Get user profile
- `PUT /api/v1/users/profile` - Update user profile
- `POST /api/v1/users/avatar` - Upload avatar

### Services
- `GET /api/v1/services` - Get all services
- `GET /api/v1/services/:id` - Get service by ID
- `POST /api/v1/services` - Create new service
- `PUT /api/v1/services/:id` - Update service
- `DELETE /api/v1/services/:id` - Delete service

### Bookings
- `GET /api/v1/bookings` - Get user bookings
- `POST /api/v1/bookings` - Create new booking
- `PUT /api/v1/bookings/:id` - Update booking
- `DELETE /api/v1/bookings/:id` - Cancel booking

### Chat
- `GET /api/v1/chat/conversations` - Get user conversations
- `GET /api/v1/chat/:id/messages` - Get conversation messages
- `POST /api/v1/chat/:id/messages` - Send message

## Database Schema

### Users
- id, email, password, first_name, last_name, phone, role, avatar, rating, created_at, updated_at

### Services
- id, title, description, price, category_id, provider_id, images, status, created_at, updated_at

### Bookings
- id, service_id, customer_id, provider_id, start_date, end_date, status, total_price, created_at, updated_at

### Categories
- id, name, slug, description, icon, created_at, updated_at

### Reviews
- id, booking_id, reviewer_id, rating, comment, created_at, updated_at

## Deployment

### Production Environment Variables

```env
NODE_ENV=production
PORT=3000
DB_HOST=your_db_host
DB_NAME=onego_production
DB_USER=your_db_user
DB_PASSWORD=strong_password
JWT_SECRET=very_strong_secret_key
REDIS_HOST=your_redis_host
```

### Docker Deployment

```bash
# Build and deploy
docker-compose -f docker-compose.prod.yml up -d

# View logs
docker-compose logs -f api

# Scale services
docker-compose scale api=3
```

## License

MIT License
