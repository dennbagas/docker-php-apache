# Minimalistic PHP with Apache 2 docker images

https://hub.docker.com/repository/docker/dennbagas/docker-php-apache

You can run with following docker-compose configuration:

```
version: "3"
services:
  cms:
    container_name: cms
    build: .
    image: dennbagas/docker-php-apache:latest
    ports:
      - "9000:80"
    volumes:
      - ./:/app
    environment:
      - APP_NAME=${APP_NAME}
```

You can use this Dockerfile example to make your own:

```
# Install Composer Dependencies First
# ===================================
FROM composer:1.6.5 as build
WORKDIR /app
COPY . /app
RUN composer install --optimize-autoloader --no-dev

# Build Image
# ===================================
FROM dennbagas/docker-php-apache:latest
COPY --from=build /app /app

EXPOSE 80
```
