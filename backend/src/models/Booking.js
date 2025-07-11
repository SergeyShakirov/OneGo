const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Booking = sequelize.define('Booking', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  bookingNumber: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
    field: 'booking_number',
  },
  startDate: {
    type: DataTypes.DATE,
    allowNull: false,
    field: 'start_date',
  },
  endDate: {
    type: DataTypes.DATE,
    allowNull: true,
    field: 'end_date',
  },
  status: {
    type: DataTypes.ENUM('pending', 'confirmed', 'in_progress', 'completed', 'cancelled'),
    defaultValue: 'pending',
  },
  totalPrice: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false,
    field: 'total_price',
  },
  notes: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  customerNotes: {
    type: DataTypes.TEXT,
    allowNull: true,
    field: 'customer_notes',
  },
  providerNotes: {
    type: DataTypes.TEXT,
    allowNull: true,
    field: 'provider_notes',
  },
  paymentStatus: {
    type: DataTypes.ENUM('pending', 'paid', 'refunded', 'failed'),
    defaultValue: 'pending',
    field: 'payment_status',
  },
  paymentId: {
    type: DataTypes.STRING,
    allowNull: true,
    field: 'payment_id',
  },
  completedAt: {
    type: DataTypes.DATE,
    allowNull: true,
    field: 'completed_at',
  },
  cancelledAt: {
    type: DataTypes.DATE,
    allowNull: true,
    field: 'cancelled_at',
  },
  cancellationReason: {
    type: DataTypes.TEXT,
    allowNull: true,
    field: 'cancellation_reason',
  },
}, {
  tableName: 'bookings',
  hooks: {
    beforeCreate: async (booking) => {
      if (!booking.bookingNumber) {
        booking.bookingNumber = `BK${Date.now()}${Math.floor(Math.random() * 1000)}`;
      }
    },
  },
});

module.exports = Booking;
