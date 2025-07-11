# OneGo Backend - Production Deployment Guide

This guide describes how to deploy the OneGo backend API to a VPS server.

## Prerequisites

- VPS server with Ubuntu 22.04 LTS or similar
- Node.js 18+ installed
- PostgreSQL 14+ installed
- Nginx installed
- SSL certificate (Let's Encrypt recommended)
- Domain name configured

## Installation Steps

### 1. Server Setup

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js (using NodeSource repository)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PostgreSQL
sudo apt install postgresql postgresql-contrib -y

# Install Nginx
sudo apt install nginx -y

# Install Docker (optional, for containerized deployment)
sudo apt install docker.io docker-compose -y
sudo systemctl enable docker
sudo systemctl start docker
```

### 2. Database Setup

```bash
# Switch to postgres user
sudo -u postgres psql

# Create database and user
CREATE DATABASE onego_prod;
CREATE USER onego_user WITH PASSWORD 'your_secure_password';
GRANT ALL PRIVILEGES ON DATABASE onego_prod TO onego_user;
\q
```

### 3. Application Deployment

```bash
# Clone repository
git clone https://github.com/SergeyShakirov/OneGo.git
cd OneGo/backend

# Install dependencies
npm install --production

# Copy environment file
cp .env.example .env

# Edit environment variables
nano .env
```

### 4. Environment Configuration

Create `.env` file with production settings:

```env
NODE_ENV=production
PORT=3000
API_PREFIX=/api/v1

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=onego_prod
DB_USER=onego_user
DB_PASSWORD=your_secure_password

# JWT
JWT_SECRET=your_jwt_secret_key_here
JWT_EXPIRES_IN=7d

# Redis (optional)
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# CORS
CORS_ORIGIN=https://yourdomain.com

# Rate Limiting
RATE_LIMIT_WINDOW=15
RATE_LIMIT_MAX_REQUESTS=100

# Email (optional)
EMAIL_FROM=noreply@yourdomain.com
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your_email@gmail.com
EMAIL_PASSWORD=your_app_password

# File Upload
UPLOAD_PATH=./uploads
MAX_FILE_SIZE=10485760

# API Base URL
API_BASE_URL=https://api.yourdomain.com
```

### 5. Database Migration

```bash
# Run database migrations
npm run db:setup

# Or manually:
npm run migrate
npm run seed
```

### 6. Process Management (PM2)

```bash
# Install PM2 globally
sudo npm install -g pm2

# Start application
pm2 start src/index.js --name "onego-api"

# Configure PM2 to start on boot
pm2 startup
pm2 save
```

### 7. Nginx Configuration

Create `/etc/nginx/sites-available/onego-api`:

```nginx
server {
    listen 80;
    server_name api.yourdomain.com;
    
    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.yourdomain.com;
    
    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/api.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.yourdomain.com/privkey.pem;
    
    # SSL Settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    
    # Security Headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
    
    # Gzip Compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied expired no-cache no-store private must-revalidate auth;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;
    
    # Rate Limiting
    limit_req_zone $binary_remote_addr zone=api:10m rate=5r/s;
    
    # API Proxy
    location / {
        limit_req zone=api burst=10 nodelay;
        
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 86400;
    }
    
    # Static Files
    location /uploads/ {
        alias /path/to/your/app/uploads/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Health Check
    location /health {
        access_log off;
        proxy_pass http://localhost:3000;
    }
}
```

Enable the site:

```bash
sudo ln -s /etc/nginx/sites-available/onego-api /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 8. SSL Certificate (Let's Encrypt)

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Obtain certificate
sudo certbot --nginx -d api.yourdomain.com

# Auto-renewal
sudo crontab -e
# Add: 0 12 * * * /usr/bin/certbot renew --quiet
```

### 9. Firewall Configuration

```bash
# Configure UFW
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw --force enable
```

### 10. Monitoring and Logging

```bash
# View application logs
pm2 logs onego-api

# Monitor application
pm2 monit

# View Nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

## Docker Deployment (Alternative)

For containerized deployment, use the provided Docker Compose configuration:

```bash
# Build and start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## Maintenance

### Database Backup

```bash
# Create backup
pg_dump -U onego_user -h localhost onego_prod > backup_$(date +%Y%m%d_%H%M%S).sql

# Restore backup
psql -U onego_user -h localhost onego_prod < backup_file.sql
```

### Application Updates

```bash
# Pull latest changes
git pull origin main

# Install new dependencies
npm install --production

# Run migrations
npm run migrate

# Restart application
pm2 restart onego-api
```

### Performance Optimization

1. **Database Indexing**: Ensure proper indexes are created for frequently queried fields
2. **Redis Caching**: Configure Redis for session storage and caching
3. **CDN**: Use a CDN for static assets
4. **Load Balancing**: Configure multiple PM2 instances
5. **Database Connection Pooling**: Configure appropriate connection pool sizes

## Security Checklist

- [ ] SSL/TLS enabled with strong ciphers
- [ ] Rate limiting configured
- [ ] CORS properly configured
- [ ] Input validation implemented
- [ ] SQL injection prevention
- [ ] XSS protection headers
- [ ] Regular security updates
- [ ] Database credentials secured
- [ ] JWT secrets properly generated
- [ ] File upload restrictions
- [ ] Error handling doesn't expose sensitive info

## Troubleshooting

### Common Issues

1. **Database Connection Failed**
   - Check PostgreSQL service status
   - Verify database credentials
   - Check network connectivity

2. **Port Already in Use**
   - Check if another service is using port 3000
   - Use `lsof -i :3000` to identify processes

3. **Permission Errors**
   - Check file permissions
   - Ensure correct user ownership

4. **SSL Certificate Issues**
   - Verify domain configuration
   - Check certificate validity
   - Ensure proper Nginx configuration

### Log Files

- Application logs: `pm2 logs onego-api`
- Nginx access logs: `/var/log/nginx/access.log`
- Nginx error logs: `/var/log/nginx/error.log`
- PostgreSQL logs: `/var/log/postgresql/`

## Support

For additional support:
- Check the [GitHub Issues](https://github.com/SergeyShakirov/OneGo/issues)
- Review the API documentation at `https://api.yourdomain.com/api-docs`
- Contact the development team
