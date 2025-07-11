const jwt = require('jsonwebtoken');
const { User } = require('../models');
const logger = require('../utils/logger');

const socketAuth = async (socket, next) => {
  try {
    const token = socket.handshake.auth.token;
    
    if (!token) {
      return next(new Error('Authentication error'));
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await User.findByPk(decoded.userId);
    
    if (!user || !user.isActive) {
      return next(new Error('Authentication error'));
    }

    socket.userId = user.id;
    socket.user = user;
    next();
  } catch (error) {
    logger.error('Socket auth error:', error);
    next(new Error('Authentication error'));
  }
};

module.exports = socketAuth;
