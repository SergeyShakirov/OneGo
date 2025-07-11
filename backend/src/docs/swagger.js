const swaggerJSDoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'OneGo API',
      version: '1.0.0',
      description: 'REST API for OneGo service marketplace platform',
      contact: {
        name: 'OneGo Team',
        email: 'api@onego.com'
      },
      license: {
        name: 'MIT',
        url: 'https://opensource.org/licenses/MIT'
      }
    },
    servers: [
      {
        url: process.env.API_BASE_URL || 'http://localhost:3000',
        description: 'Development server'
      },
      {
        url: 'https://api.onego.com',
        description: 'Production server'
      }
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT'
        }
      },
      schemas: {
        User: {
          type: 'object',
          properties: {
            id: {
              type: 'integer',
              description: 'User ID'
            },
            email: {
              type: 'string',
              format: 'email',
              description: 'User email address'
            },
            firstName: {
              type: 'string',
              description: 'User first name'
            },
            lastName: {
              type: 'string',
              description: 'User last name'
            },
            phone: {
              type: 'string',
              description: 'User phone number'
            },
            avatar: {
              type: 'string',
              description: 'User avatar URL'
            },
            role: {
              type: 'string',
              enum: ['user', 'provider', 'admin'],
              description: 'User role'
            },
            isActive: {
              type: 'boolean',
              description: 'User account status'
            },
            createdAt: {
              type: 'string',
              format: 'date-time',
              description: 'Account creation date'
            },
            updatedAt: {
              type: 'string',
              format: 'date-time',
              description: 'Account last update date'
            }
          }
        },
        Category: {
          type: 'object',
          properties: {
            id: {
              type: 'integer',
              description: 'Category ID'
            },
            name: {
              type: 'string',
              description: 'Category name'
            },
            description: {
              type: 'string',
              description: 'Category description'
            },
            icon: {
              type: 'string',
              description: 'Category icon name'
            },
            color: {
              type: 'string',
              description: 'Category color code'
            },
            parentId: {
              type: 'integer',
              description: 'Parent category ID'
            },
            isActive: {
              type: 'boolean',
              description: 'Category status'
            }
          }
        },
        Service: {
          type: 'object',
          properties: {
            id: {
              type: 'integer',
              description: 'Service ID'
            },
            title: {
              type: 'string',
              description: 'Service title'
            },
            description: {
              type: 'string',
              description: 'Service description'
            },
            shortDescription: {
              type: 'string',
              description: 'Service short description'
            },
            price: {
              type: 'number',
              format: 'decimal',
              description: 'Service price'
            },
            currency: {
              type: 'string',
              description: 'Currency code'
            },
            duration: {
              type: 'integer',
              description: 'Service duration in minutes'
            },
            images: {
              type: 'array',
              items: {
                type: 'string'
              },
              description: 'Service images URLs'
            },
            location: {
              type: 'string',
              description: 'Service location'
            },
            coordinates: {
              type: 'object',
              properties: {
                lat: {
                  type: 'number',
                  description: 'Latitude'
                },
                lng: {
                  type: 'number',
                  description: 'Longitude'
                }
              },
              description: 'Service coordinates'
            },
            tags: {
              type: 'array',
              items: {
                type: 'string'
              },
              description: 'Service tags'
            },
            providerId: {
              type: 'integer',
              description: 'Service provider ID'
            },
            categoryId: {
              type: 'integer',
              description: 'Service category ID'
            },
            status: {
              type: 'string',
              enum: ['active', 'inactive', 'pending', 'suspended'],
              description: 'Service status'
            },
            isAvailable: {
              type: 'boolean',
              description: 'Service availability'
            }
          }
        },
        Booking: {
          type: 'object',
          properties: {
            id: {
              type: 'integer',
              description: 'Booking ID'
            },
            serviceId: {
              type: 'integer',
              description: 'Service ID'
            },
            userId: {
              type: 'integer',
              description: 'User ID'
            },
            providerId: {
              type: 'integer',
              description: 'Provider ID'
            },
            scheduledAt: {
              type: 'string',
              format: 'date-time',
              description: 'Booking scheduled time'
            },
            duration: {
              type: 'integer',
              description: 'Booking duration in minutes'
            },
            totalAmount: {
              type: 'number',
              format: 'decimal',
              description: 'Total booking amount'
            },
            status: {
              type: 'string',
              enum: ['pending', 'confirmed', 'in_progress', 'completed', 'cancelled', 'no_show'],
              description: 'Booking status'
            },
            paymentStatus: {
              type: 'string',
              enum: ['pending', 'paid', 'failed', 'refunded', 'partial_refund'],
              description: 'Payment status'
            },
            notes: {
              type: 'string',
              description: 'Booking notes'
            }
          }
        },
        Review: {
          type: 'object',
          properties: {
            id: {
              type: 'integer',
              description: 'Review ID'
            },
            serviceId: {
              type: 'integer',
              description: 'Service ID'
            },
            bookingId: {
              type: 'integer',
              description: 'Booking ID'
            },
            userId: {
              type: 'integer',
              description: 'User ID'
            },
            rating: {
              type: 'integer',
              minimum: 1,
              maximum: 5,
              description: 'Review rating'
            },
            comment: {
              type: 'string',
              description: 'Review comment'
            },
            isVerified: {
              type: 'boolean',
              description: 'Review verification status'
            },
            isPublic: {
              type: 'boolean',
              description: 'Review visibility'
            }
          }
        },
        Error: {
          type: 'object',
          properties: {
            error: {
              type: 'string',
              description: 'Error message'
            },
            message: {
              type: 'string',
              description: 'Detailed error message'
            },
            code: {
              type: 'string',
              description: 'Error code'
            }
          }
        },
        PaginationMeta: {
          type: 'object',
          properties: {
            page: {
              type: 'integer',
              description: 'Current page number'
            },
            limit: {
              type: 'integer',
              description: 'Items per page'
            },
            total: {
              type: 'integer',
              description: 'Total items count'
            },
            pages: {
              type: 'integer',
              description: 'Total pages count'
            }
          }
        }
      }
    },
    security: [
      {
        bearerAuth: []
      }
    ]
  },
  apis: ['./src/routes/*.js', './src/index.js']
};

const specs = swaggerJSDoc(options);

module.exports = {
  specs,
  swaggerUi
};
