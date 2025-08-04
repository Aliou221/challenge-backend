# Étape 1 : Choisir une image PHP avec Composer + extensions Laravel
FROM php:8.2-cli

# Installer dépendances système
RUN apt-get update && apt-get install -y \
    git unzip zip curl libzip-dev libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Créer le répertoire de l'application
WORKDIR /var/www/html

# Copier tous les fichiers du projet dans l'image
COPY . .

# Installer les dépendances PHP via Composer
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Générer le fichier .env à partir des variables d'environnement Railway
RUN echo "APP_NAME=${APP_NAME}" > .env \
 && echo "APP_ENV=${APP_ENV}" >> .env \
 && echo "APP_DEBUG=${APP_DEBUG}" >> .env \
 && echo "APP_URL=${APP_URL}" >> .env \
 && echo "LOG_CHANNEL=stack" >> .env \
 && echo "DB_CONNECTION=${DB_CONNECTION}" >> .env \
 && echo "DB_HOST=${DB_HOST}" >> .env \
 && echo "DB_PORT=${DB_PORT}" >> .env \
 && echo "DB_DATABASE=${DB_DATABASE}" >> .env \
 && echo "DB_USERNAME=${DB_USERNAME}" >> .env \
 && echo "DB_PASSWORD=${DB_PASSWORD}" >> .env

# Donner les bons droits au framework
RUN chmod -R 775 storage bootstrap/cache

# Exposer le port 8000 pour Railway
EXPOSE 8000

# Commande finale de lancement
CMD php artisan key:generate --force \
 && php artisan migrate --force \
 && php artisan serve --host=0.0.0.0 --port=8000