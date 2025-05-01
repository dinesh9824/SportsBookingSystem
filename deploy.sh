#!/bin/bash

# Run composer install
cd /var/www/html
composer install --no-dev --optimize-autoloader

# Install NPM dependencies and build assets
npm ci
npm run build

# Set correct permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html/storage

# Generate key if not already set
php artisan key:generate --force

# Run database migrations
php artisan migrate --force

# Cache configuration
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Create storage link
php artisan storage:link

# Start PHP-FPM and Nginx
/start.sh 