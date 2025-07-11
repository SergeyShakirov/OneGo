'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Conversations', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      bookingId: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'Bookings',
          key: 'id'
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE'
      },
      serviceId: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: 'Services',
          key: 'id'
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE'
      },
      userId: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'Users',
          key: 'id'
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE'
      },
      providerId: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'Users',
          key: 'id'
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE'
      },
      title: {
        type: Sequelize.STRING,
        allowNull: true
      },
      status: {
        type: Sequelize.ENUM('active', 'closed', 'archived'),
        allowNull: false,
        defaultValue: 'active'
      },
      lastMessageAt: {
        type: Sequelize.DATE,
        allowNull: true
      },
      lastMessageId: {
        type: Sequelize.INTEGER,
        allowNull: true
      },
      isUserRead: {
        type: Sequelize.BOOLEAN,
        allowNull: false,
        defaultValue: false
      },
      isProviderRead: {
        type: Sequelize.BOOLEAN,
        allowNull: false,
        defaultValue: false
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });

    await queryInterface.addIndex('Conversations', ['bookingId']);
    await queryInterface.addIndex('Conversations', ['serviceId']);
    await queryInterface.addIndex('Conversations', ['userId']);
    await queryInterface.addIndex('Conversations', ['providerId']);
    await queryInterface.addIndex('Conversations', ['status']);
    await queryInterface.addIndex('Conversations', ['lastMessageAt']);
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('Conversations');
  }
};
