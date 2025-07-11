const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Conversation = sequelize.define('Conversation', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  lastMessageAt: {
    type: DataTypes.DATE,
    allowNull: true,
    field: 'last_message_at',
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
    field: 'is_active',
  },
  title: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  conversationType: {
    type: DataTypes.ENUM('direct', 'group'),
    defaultValue: 'direct',
    field: 'conversation_type',
  },
}, {
  tableName: 'conversations',
});

module.exports = Conversation;
