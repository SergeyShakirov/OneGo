'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    // Get users and categories for foreign keys
    const users = await queryInterface.sequelize.query(
      `SELECT id, email, role FROM "Users" WHERE role = 'provider';`,
      { type: Sequelize.QueryTypes.SELECT }
    );

    const categories = await queryInterface.sequelize.query(
      `SELECT id, name FROM "Categories" WHERE "parentId" IS NOT NULL;`,
      { type: Sequelize.QueryTypes.SELECT }
    );

    const categoryMap = {};
    categories.forEach(cat => {
      categoryMap[cat.name] = cat.id;
    });

    const johnDoe = users.find(u => u.email === 'john.doe@example.com');
    const janeSmith = users.find(u => u.email === 'jane.smith@example.com');

    await queryInterface.bulkInsert('Services', [
      {
        title: 'Professional Hair Cut & Styling',
        description: 'Get a fresh new look with our professional hair cutting and styling service. Our experienced stylists will work with you to create a cut that suits your face shape and lifestyle. We use premium products and the latest techniques to ensure you leave feeling confident and looking your best.',
        shortDescription: 'Professional hair cutting and styling service',
        price: 65.00,
        currency: 'USD',
        duration: 90,
        images: JSON.stringify(['https://images.unsplash.com/photo-1562322140-8baeececf3df?w=400', 'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=400']),
        location: 'Downtown Hair Studio, 123 Main St, New York, NY',
        coordinates: JSON.stringify({ lat: 40.7128, lng: -74.0060 }),
        tags: JSON.stringify(['haircut', 'styling', 'professional', 'men', 'women']),
        providerId: johnDoe.id,
        categoryId: categoryMap['Hair Services'],
        status: 'active',
        isAvailable: true,
        minAdvanceBooking: 2,
        maxAdvanceBooking: 30,
        cancellationPolicy: 'Free cancellation up to 24 hours before appointment. 50% charge for cancellations within 24 hours.',
        requirements: 'Please arrive 10 minutes early. Bring inspiration photos if you have specific style preferences.',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        title: 'Luxury Manicure & Pedicure',
        description: 'Treat yourself to a luxurious manicure and pedicure experience. Our service includes nail shaping, cuticle care, exfoliation, moisturizing massage, and your choice of premium nail polish. We use high-quality, non-toxic products in a clean and relaxing environment.',
        shortDescription: 'Luxury manicure and pedicure service',
        price: 85.00,
        currency: 'USD',
        duration: 120,
        images: JSON.stringify(['https://images.unsplash.com/photo-1604654894610-df63bc536371?w=400', 'https://images.unsplash.com/photo-1619451334792-150fe314607c?w=400']),
        location: 'Serenity Spa, 456 Oak Ave, New York, NY',
        coordinates: JSON.stringify({ lat: 40.7589, lng: -73.9851 }),
        tags: JSON.stringify(['manicure', 'pedicure', 'luxury', 'spa', 'nail care']),
        providerId: johnDoe.id,
        categoryId: categoryMap['Nail Services'],
        status: 'active',
        isAvailable: true,
        minAdvanceBooking: 1,
        maxAdvanceBooking: 21,
        cancellationPolicy: 'Free cancellation up to 12 hours before appointment.',
        requirements: 'Please avoid caffeine before appointment for best results.',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        title: 'Deep Tissue Massage Therapy',
        description: 'Experience relief from muscle tension and stress with our therapeutic deep tissue massage. Our licensed massage therapist uses specialized techniques to target deep muscle layers and release chronic tension. Perfect for athletes, desk workers, or anyone dealing with muscle pain.',
        shortDescription: 'Professional deep tissue massage therapy',
        price: 120.00,
        currency: 'USD',
        duration: 60,
        images: JSON.stringify(['https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=400', 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400']),
        location: 'Wellness Center, 789 Elm St, Los Angeles, CA',
        coordinates: JSON.stringify({ lat: 34.0522, lng: -118.2437 }),
        tags: JSON.stringify(['massage', 'deep tissue', 'therapy', 'wellness', 'stress relief']),
        providerId: janeSmith.id,
        categoryId: categoryMap['Massage Therapy'],
        status: 'active',
        isAvailable: true,
        minAdvanceBooking: 4,
        maxAdvanceBooking: 14,
        cancellationPolicy: 'Free cancellation up to 4 hours before appointment. Full charge for no-shows.',
        requirements: 'Please arrive 15 minutes early. Avoid large meals 2 hours before session.',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        title: 'Personal Training Session',
        description: 'Achieve your fitness goals with personalized one-on-one training sessions. Our certified personal trainer will create a customized workout plan based on your fitness level, goals, and preferences. Sessions include strength training, cardio, flexibility work, and nutritional guidance.',
        shortDescription: 'One-on-one personal training session',
        price: 80.00,
        currency: 'USD',
        duration: 60,
        images: JSON.stringify(['https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400', 'https://images.unsplash.com/photo-1549476464-37392f717541?w=400']),
        location: 'FitLife Gym, 321 Fitness Blvd, Los Angeles, CA',
        coordinates: JSON.stringify({ lat: 34.0522, lng: -118.2437 }),
        tags: JSON.stringify(['personal training', 'fitness', 'strength', 'cardio', 'wellness']),
        providerId: janeSmith.id,
        categoryId: categoryMap['Personal Training'],
        status: 'active',
        isAvailable: true,
        minAdvanceBooking: 2,
        maxAdvanceBooking: 30,
        cancellationPolicy: 'Free cancellation up to 2 hours before session. 50% charge for late cancellations.',
        requirements: 'Bring workout clothes, water bottle, and towel. Athletic shoes required.',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        title: 'Home Deep Cleaning Service',
        description: 'Transform your home with our comprehensive deep cleaning service. We clean every corner of your home including bathrooms, kitchen, bedrooms, living areas, and more. Our team uses eco-friendly products and professional equipment to ensure your home is spotless and healthy.',
        shortDescription: 'Professional home deep cleaning service',
        price: 150.00,
        currency: 'USD',
        duration: 180,
        images: JSON.stringify(['https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=400', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400']),
        location: 'Service area covers entire New York metropolitan area',
        coordinates: JSON.stringify({ lat: 40.7128, lng: -74.0060 }),
        tags: JSON.stringify(['cleaning', 'deep cleaning', 'home', 'eco-friendly', 'professional']),
        providerId: johnDoe.id,
        categoryId: categoryMap['Cleaning Services'],
        status: 'active',
        isAvailable: true,
        minAdvanceBooking: 24,
        maxAdvanceBooking: 60,
        cancellationPolicy: 'Free cancellation up to 24 hours before service. 25% charge for late cancellations.',
        requirements: 'Please secure any valuable items. Pets should be contained during service.',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        title: 'Computer Repair & Troubleshooting',
        description: 'Get your computer running like new again with our expert repair and troubleshooting service. We handle hardware issues, software problems, virus removal, system optimization, and data recovery. Quick diagnostics and transparent pricing.',
        shortDescription: 'Expert computer repair and troubleshooting',
        price: 75.00,
        currency: 'USD',
        duration: 90,
        images: JSON.stringify(['https://images.unsplash.com/photo-1588508065123-287b28e013da?w=400', 'https://images.unsplash.com/photo-1581092795360-fd1ca04f0952?w=400']),
        location: 'Tech Solutions Hub, 654 Tech Park Dr, Los Angeles, CA',
        coordinates: JSON.stringify({ lat: 34.0522, lng: -118.2437 }),
        tags: JSON.stringify(['computer repair', 'troubleshooting', 'tech support', 'hardware', 'software']),
        providerId: janeSmith.id,
        categoryId: categoryMap['Computer Repair'],
        status: 'active',
        isAvailable: true,
        minAdvanceBooking: 1,
        maxAdvanceBooking: 14,
        cancellationPolicy: 'Free cancellation up to 1 hour before appointment.',
        requirements: 'Bring your computer with power adapter. Backup important data if possible.',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        title: 'Private Guitar Lessons',
        description: 'Learn to play guitar with personalized instruction from an experienced musician. Lessons cover music theory, technique, chord progressions, and songs in various genres. Suitable for beginners to advanced players. Acoustic and electric guitar instruction available.',
        shortDescription: 'Private guitar lessons for all skill levels',
        price: 50.00,
        currency: 'USD',
        duration: 60,
        images: JSON.stringify(['https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400', 'https://images.unsplash.com/photo-1564186763535-ebb21ef5277f?w=400']),
        location: 'Music Studio, 987 Harmony Ave, New York, NY',
        coordinates: JSON.stringify({ lat: 40.7128, lng: -74.0060 }),
        tags: JSON.stringify(['guitar', 'music lessons', 'private instruction', 'beginner', 'advanced']),
        providerId: johnDoe.id,
        categoryId: categoryMap['Music Lessons'],
        status: 'active',
        isAvailable: true,
        minAdvanceBooking: 2,
        maxAdvanceBooking: 30,
        cancellationPolicy: 'Free cancellation up to 2 hours before lesson. Make-up lessons available.',
        requirements: 'Bring your own guitar or use studio instrument. Notebook for taking notes recommended.',
        createdAt: new Date(),
        updatedAt: new Date()
      },
      {
        title: 'Yoga & Meditation Session',
        description: 'Find inner peace and improve flexibility with our private yoga and meditation sessions. Our certified instructor will guide you through gentle stretches, breathing exercises, and meditation techniques. Perfect for stress relief and overall wellness.',
        shortDescription: 'Private yoga and meditation instruction',
        price: 70.00,
        currency: 'USD',
        duration: 75,
        images: JSON.stringify(['https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400', 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400']),
        location: 'Zen Wellness Studio, 147 Peace St, Los Angeles, CA',
        coordinates: JSON.stringify({ lat: 34.0522, lng: -118.2437 }),
        tags: JSON.stringify(['yoga', 'meditation', 'wellness', 'stress relief', 'flexibility']),
        providerId: janeSmith.id,
        categoryId: categoryMap['Yoga & Pilates'],
        status: 'active',
        isAvailable: true,
        minAdvanceBooking: 1,
        maxAdvanceBooking: 21,
        cancellationPolicy: 'Free cancellation up to 1 hour before session.',
        requirements: 'Bring yoga mat and water. Wear comfortable clothing suitable for movement.',
        createdAt: new Date(),
        updatedAt: new Date()
      }
    ], {});
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.bulkDelete('Services', null, {});
  }
};
