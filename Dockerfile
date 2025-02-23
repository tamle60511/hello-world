# Use an official PHP runtime as a parent image  
FROM php:8.3.10

# Install system dependencies and SQLite extension  
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libsqlite3-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_sqlite  

# Install Composer globally  
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer  

# Set working directory inside the container  
WORKDIR /var/www  

# Copy application source code to container  
COPY . /var/www  

# Install PHP dependencies (adjust if you have specific Composer flags or use composer.lock)  
# RUN composer install
RUN composer clear-cache && composer install --no-interaction --prefer-dist --optimize-autoloader  

# Ensure necessary directories have the proper permissions  
RUN chown -R www-data:www-data storage bootstrap/cache  

# Expose port 8000 and start  
CMD php artisan serve --host=0.0.0.0 --port=8000

EXPOSE 8000