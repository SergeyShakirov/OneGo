#!/usr/bin/env node

const { exec } = require('child_process');
const path = require('path');
const fs = require('fs');

// Configuration
const MIGRATIONS_PATH = path.join(__dirname, 'migrations');
const SEEDERS_PATH = path.join(__dirname, 'seeders');

// Colors for console output
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  magenta: '\x1b[35m',
  cyan: '\x1b[36m'
};

function log(message, color = 'reset') {
  console.log(`${colors[color]}${message}${colors.reset}`);
}

function runCommand(command, description) {
  return new Promise((resolve, reject) => {
    log(`\n${description}...`, 'cyan');
    log(`Executing: ${command}`, 'yellow');
    
    exec(command, (error, stdout, stderr) => {
      if (error) {
        log(`Error: ${error.message}`, 'red');
        reject(error);
        return;
      }
      
      if (stderr) {
        log(`Warning: ${stderr}`, 'yellow');
      }
      
      if (stdout) {
        log(stdout, 'green');
      }
      
      log(`✓ ${description} completed`, 'green');
      resolve();
    });
  });
}

async function runMigrations() {
  try {
    log('=== Running Database Migrations ===', 'bright');
    
    // Check if migrations directory exists
    if (!fs.existsSync(MIGRATIONS_PATH)) {
      log('Migrations directory not found!', 'red');
      return;
    }
    
    // Get all migration files
    const migrationFiles = fs.readdirSync(MIGRATIONS_PATH)
      .filter(file => file.endsWith('.js'))
      .sort();
    
    if (migrationFiles.length === 0) {
      log('No migration files found!', 'yellow');
      return;
    }
    
    log(`Found ${migrationFiles.length} migration files:`, 'blue');
    migrationFiles.forEach(file => log(`  - ${file}`, 'blue'));
    
    // Run each migration
    for (const file of migrationFiles) {
      const migrationPath = path.join(MIGRATIONS_PATH, file);
      const migration = require(migrationPath);
      
      if (typeof migration.up === 'function') {
        log(`\nRunning migration: ${file}`, 'magenta');
        try {
          const sequelize = require('./config/database');
          await migration.up(sequelize.getQueryInterface(), sequelize.constructor);
          log(`✓ Migration ${file} completed successfully`, 'green');
        } catch (error) {
          log(`✗ Migration ${file} failed: ${error.message}`, 'red');
          throw error;
        }
      } else {
        log(`⚠ Migration ${file} missing 'up' function`, 'yellow');
      }
    }
    
    log('\n=== All migrations completed successfully! ===', 'bright');
    
  } catch (error) {
    log(`\nMigration failed: ${error.message}`, 'red');
    process.exit(1);
  }
}

async function runSeeders() {
  try {
    log('\n=== Running Database Seeders ===', 'bright');
    
    // Check if seeders directory exists
    if (!fs.existsSync(SEEDERS_PATH)) {
      log('Seeders directory not found!', 'red');
      return;
    }
    
    // Get all seeder files
    const seederFiles = fs.readdirSync(SEEDERS_PATH)
      .filter(file => file.endsWith('.js'))
      .sort();
    
    if (seederFiles.length === 0) {
      log('No seeder files found!', 'yellow');
      return;
    }
    
    log(`Found ${seederFiles.length} seeder files:`, 'blue');
    seederFiles.forEach(file => log(`  - ${file}`, 'blue'));
    
    // Run each seeder
    for (const file of seederFiles) {
      const seederPath = path.join(SEEDERS_PATH, file);
      const seeder = require(seederPath);
      
      if (typeof seeder.up === 'function') {
        log(`\nRunning seeder: ${file}`, 'magenta');
        try {
          const sequelize = require('./config/database');
          await seeder.up(sequelize.getQueryInterface(), sequelize.constructor);
          log(`✓ Seeder ${file} completed successfully`, 'green');
        } catch (error) {
          log(`✗ Seeder ${file} failed: ${error.message}`, 'red');
          throw error;
        }
      } else {
        log(`⚠ Seeder ${file} missing 'up' function`, 'yellow');
      }
    }
    
    log('\n=== All seeders completed successfully! ===', 'bright');
    
  } catch (error) {
    log(`\nSeeding failed: ${error.message}`, 'red');
    process.exit(1);
  }
}

async function resetDatabase() {
  try {
    log('\n=== Resetting Database ===', 'bright');
    
    const sequelize = require('./config/database');
    
    // Drop all tables
    log('Dropping all tables...', 'yellow');
    await sequelize.drop();
    
    // Recreate tables
    log('Recreating tables...', 'yellow');
    await sequelize.sync({ force: true });
    
    log('✓ Database reset completed', 'green');
    
  } catch (error) {
    log(`\nDatabase reset failed: ${error.message}`, 'red');
    process.exit(1);
  }
}

async function main() {
  const args = process.argv.slice(2);
  const command = args[0];
  
  try {
    // Load environment variables
    require('dotenv').config();
    
    switch (command) {
      case 'migrate':
        await runMigrations();
        break;
        
      case 'seed':
        await runSeeders();
        break;
        
      case 'reset':
        await resetDatabase();
        break;
        
      case 'setup':
        await runMigrations();
        await runSeeders();
        break;
        
      case 'fresh':
        await resetDatabase();
        await runMigrations();
        await runSeeders();
        break;
        
      default:
        log('Database Management Script', 'bright');
        log('Usage: node db-setup.js [command]', 'cyan');
        log('');
        log('Commands:', 'yellow');
        log('  migrate  - Run database migrations', 'blue');
        log('  seed     - Run database seeders', 'blue');
        log('  setup    - Run migrations and seeders', 'blue');
        log('  reset    - Drop and recreate all tables', 'blue');
        log('  fresh    - Reset database and run migrations and seeders', 'blue');
        log('');
        log('Examples:', 'yellow');
        log('  node db-setup.js migrate', 'green');
        log('  node db-setup.js seed', 'green');
        log('  node db-setup.js setup', 'green');
        log('  node db-setup.js fresh', 'green');
        break;
    }
    
  } catch (error) {
    log(`\nScript failed: ${error.message}`, 'red');
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

module.exports = {
  runMigrations,
  runSeeders,
  resetDatabase
};
