const User = require('./User');
const Category = require('./Category');
const Service = require('./Service');
const Booking = require('./Booking');
const Review = require('./Review');
const Message = require('./Message');
const Conversation = require('./Conversation');

// Define associations
User.hasMany(Service, { foreignKey: 'providerId', as: 'services' });
Service.belongsTo(User, { foreignKey: 'providerId', as: 'provider' });

Category.hasMany(Service, { foreignKey: 'categoryId', as: 'services' });
Service.belongsTo(Category, { foreignKey: 'categoryId', as: 'category' });

User.hasMany(Booking, { foreignKey: 'customerId', as: 'customerBookings' });
User.hasMany(Booking, { foreignKey: 'providerId', as: 'providerBookings' });
Booking.belongsTo(User, { foreignKey: 'customerId', as: 'customer' });
Booking.belongsTo(User, { foreignKey: 'providerId', as: 'provider' });

Service.hasMany(Booking, { foreignKey: 'serviceId', as: 'bookings' });
Booking.belongsTo(Service, { foreignKey: 'serviceId', as: 'service' });

Booking.hasOne(Review, { foreignKey: 'bookingId', as: 'review' });
Review.belongsTo(Booking, { foreignKey: 'bookingId', as: 'booking' });

User.hasMany(Review, { foreignKey: 'reviewerId', as: 'givenReviews' });
Review.belongsTo(User, { foreignKey: 'reviewerId', as: 'reviewer' });

Service.hasMany(Review, { foreignKey: 'serviceId', as: 'reviews' });
Review.belongsTo(Service, { foreignKey: 'serviceId', as: 'service' });

// Chat associations
User.belongsToMany(Conversation, { 
  through: 'conversation_participants', 
  foreignKey: 'userId',
  as: 'conversations'
});
Conversation.belongsToMany(User, { 
  through: 'conversation_participants', 
  foreignKey: 'conversationId',
  as: 'participants'
});

Conversation.hasMany(Message, { foreignKey: 'conversationId', as: 'messages' });
Message.belongsTo(Conversation, { foreignKey: 'conversationId', as: 'conversation' });

User.hasMany(Message, { foreignKey: 'senderId', as: 'sentMessages' });
Message.belongsTo(User, { foreignKey: 'senderId', as: 'sender' });

// Booking-Conversation association (for service-related chats)
Booking.hasOne(Conversation, { foreignKey: 'bookingId', as: 'conversation' });
Conversation.belongsTo(Booking, { foreignKey: 'bookingId', as: 'booking' });

module.exports = {
  User,
  Category,
  Service,
  Booking,
  Review,
  Message,
  Conversation,
};
