FROM php:8.2-fpm

# Installer dépendances système
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    curl \
    git \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    default-mysql-client \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql mbstring zip gd

# Copier Composer depuis l'image officielle
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Définir le dossier de travail
WORKDIR /var/www

# Copier les fichiers Laravel
COPY . .

# Installer les dépendances Laravel
RUN composer install --no-dev --optimize-autoloader


# Créer un fichier .env depuis les variables Railway
RUN echo "APP_NAME=${APP_NAME}" > .env \
 && echo "APP_ENV=${APP_ENV}" >> .env \
 && echo "APP_DEBUG=${APP_DEBUG}" >> .env \
 && echo "APP_URL=${APP_URL}" >> .env \
 && echo "DB_CONNECTION=${DB_CONNECTION}" >> .env \
 && echo "DB_HOST=${DB_HOST}" >> .env \
 && echo "DB_PORT=${DB_PORT}" >> .env \
 && echo "DB_DATABASE=${DB_DATABASE}" >> .env \
 && echo "DB_USERNAME=${DB_USERNAME}" >> .env \
 && echo "DB_PASSWORD=${DB_PASSWORD}" >> .env


# Générer le cache de configuration
RUN php artisan config:clear \
    && php artisan route:clear \
    && php artisan view:clear

# Exposer le port par défaut Laravel
EXPOSE 8000

# Commande au démarrage du conteneur
CMD php artisan key:generate --force \
    && php artisan migrate --force \
    && php artisan serve --host=0.0.0.0 --port=8000