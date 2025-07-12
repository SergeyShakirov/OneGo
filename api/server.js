const express = require('express');
const cors = require('cors');
const { v4: uuidv4 } = require('uuid');

const app = express();
const port = 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Mock data
let tasks = [
  {
    id: '1',
    title: 'Создание интернет-магазина',
    description: 'Нужно создать современный интернет-магазин на Flutter с админ-панелью',
    category: 'Веб-разработка',
    price: 150000,
    deadline: '15 дней',
    authorId: 'user1',
    authorName: 'Анна Петрова',
    authorRating: 4.9,
    responsesCount: 12,
    isUrgent: true,
    skills: ['Flutter', 'Firebase', 'Admin Panel'],
    createdAt: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString(),
    updatedAt: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: '2',
    title: 'Дизайн мобильного приложения',
    description: 'Требуется создать UX/UI дизайн для приложения доставки еды',
    category: 'Дизайн',
    price: 80000,
    deadline: '10 дней',
    authorId: 'user2',
    authorName: 'Михаил Сидоров',
    authorRating: 4.7,
    responsesCount: 8,
    isUrgent: false,
    skills: ['Figma', 'UI/UX', 'Mobile Design'],
    createdAt: new Date(Date.now() - 5 * 60 * 60 * 1000).toISOString(),
    updatedAt: new Date(Date.now() - 5 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: '3',
    title: 'Настройка рекламы в Google Ads',
    description: 'Нужна помощь в настройке и оптимизации рекламных кампаний',
    category: 'Маркетинг',
    price: 25000,
    deadline: '3 дня',
    authorId: 'user3',
    authorName: 'Елена Волкова',
    authorRating: 4.8,
    responsesCount: 15,
    isUrgent: true,
    skills: ['Google Ads', 'Analytics', 'Marketing'],
    createdAt: new Date(Date.now() - 8 * 60 * 60 * 1000).toISOString(),
    updatedAt: new Date(Date.now() - 8 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: '4',
    title: 'Разработка API для мобильного приложения',
    description: 'Требуется создать RESTful API на Node.js для существующего приложения',
    category: 'Веб-разработка',
    price: 120000,
    deadline: '20 дней',
    authorId: 'user4',
    authorName: 'Дмитрий Козлов',
    authorRating: 5.0,
    responsesCount: 6,
    isUrgent: false,
    skills: ['Node.js', 'Express', 'MongoDB', 'REST API'],
    createdAt: new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString(),
    updatedAt: new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString(),
  },
];

// Routes

// GET /api/tasks - получить все задачи с фильтрацией и сортировкой
app.get('/api/tasks', (req, res) => {
  let filteredTasks = [...tasks];
  const { category, sortBy, page = 1, limit = 10 } = req.query;

  // Фильтр по категории
  if (category && category !== 'Все') {
    filteredTasks = filteredTasks.filter(task => task.category === category);
  }

  // Сортировка
  switch (sortBy) {
    case 'Цена (по возрастанию)':
      filteredTasks.sort((a, b) => a.price - b.price);
      break;
    case 'Цена (по убыванию)':
      filteredTasks.sort((a, b) => b.price - a.price);
      break;
    case 'Популярность':
      filteredTasks.sort((a, b) => b.responsesCount - a.responsesCount);
      break;
    case 'Рейтинг':
      filteredTasks.sort((a, b) => b.authorRating - a.authorRating);
      break;
    default: // Дата создания
      filteredTasks.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
  }

  // Пагинация
  const startIndex = (page - 1) * limit;
  const endIndex = startIndex + parseInt(limit);
  const paginatedTasks = filteredTasks.slice(startIndex, endIndex);

  res.json({
    tasks: paginatedTasks,
    total: filteredTasks.length,
    page: parseInt(page),
    totalPages: Math.ceil(filteredTasks.length / limit),
  });
});

// GET /api/tasks/:id - получить задачу по ID
app.get('/api/tasks/:id', (req, res) => {
  const task = tasks.find(t => t.id === req.params.id);
  if (!task) {
    return res.status(404).json({ error: 'Task not found' });
  }
  res.json(task);
});

// POST /api/tasks - создать новую задачу
app.post('/api/tasks', (req, res) => {
  const { title, description, category, price, deadline, skills, isUrgent } = req.body;

  // Валидация
  if (!title || !description || !category || !price || !deadline) {
    return res.status(400).json({ 
      error: 'Missing required fields: title, description, category, price, deadline' 
    });
  }

  const newTask = {
    id: uuidv4(),
    title,
    description,
    category,
    price: parseFloat(price),
    deadline,
    authorId: 'current-user', // В реальном приложении берем из JWT токена
    authorName: 'Текущий пользователь',
    authorRating: 4.5,
    responsesCount: 0,
    isUrgent: Boolean(isUrgent),
    skills: skills || [],
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };

  tasks.push(newTask);
  res.status(201).json(newTask);
});

// PUT /api/tasks/:id - обновить задачу
app.put('/api/tasks/:id', (req, res) => {
  const taskIndex = tasks.findIndex(t => t.id === req.params.id);
  if (taskIndex === -1) {
    return res.status(404).json({ error: 'Task not found' });
  }

  const updatedTask = {
    ...tasks[taskIndex],
    ...req.body,
    id: req.params.id, // ID не должен изменяться
    updatedAt: new Date().toISOString(),
  };

  tasks[taskIndex] = updatedTask;
  res.json(updatedTask);
});

// DELETE /api/tasks/:id - удалить задачу
app.delete('/api/tasks/:id', (req, res) => {
  const taskIndex = tasks.findIndex(t => t.id === req.params.id);
  if (taskIndex === -1) {
    return res.status(404).json({ error: 'Task not found' });
  }

  tasks.splice(taskIndex, 1);
  res.status(204).send();
});

// POST /api/tasks/:id/respond - откликнуться на задачу
app.post('/api/tasks/:id/respond', (req, res) => {
  const task = tasks.find(t => t.id === req.params.id);
  if (!task) {
    return res.status(404).json({ error: 'Task not found' });
  }

  // Увеличиваем счетчик откликов
  task.responsesCount += 1;
  task.updatedAt = new Date().toISOString();

  res.json({ 
    message: 'Response submitted successfully',
    responsesCount: task.responsesCount 
  });
});

// Обработка ошибок
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

app.listen(port, () => {
  console.log(`✅ OneGo Tasks API server running on http://localhost:${port}`);
  console.log(`📋 Available endpoints:`);
  console.log(`   GET    /api/tasks`);
  console.log(`   GET    /api/tasks/:id`);
  console.log(`   POST   /api/tasks`);
  console.log(`   PUT    /api/tasks/:id`);
  console.log(`   DELETE /api/tasks/:id`);
  console.log(`   POST   /api/tasks/:id/respond`);
});
