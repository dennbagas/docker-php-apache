# Minimalistic PHP with Apache 2 docker images

Docker hub link: https://hub.docker.com/repository/docker/dennbagas/docker-php-apache

## Usage

You can run with following docker-compose configuration:

```yml
version: "3"
services:
  cms:
    container_name: cms
    build: .
    image: dennbagas/docker-php-apache
    ports:
      - "9000:80"
    volumes:
      - ./:/app
    environment:
      - APP_NAME=${APP_NAME}
```

You can use this Dockerfile example to make your own:

```Dockerfile
# ====================================
# Install Composer Dependencies First
# ====================================
FROM composer as build
WORKDIR /app
COPY . /app
RUN composer install --optimize-autoloader --no-dev

# ====================================
# Build Image
# ====================================
FROM dennbagas/docker-php-apache
COPY --from=build /app /app

EXPOSE 80
```

## Run scripts before apache start

To run script before apache starts, create file named `startup.sh` in your app root folder. Example file:

```sh
#!/bin/sh

# run laravel migration before app running
echo "Running migration..."
yes | php artisan migrate
```
