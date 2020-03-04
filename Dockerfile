# Build Image
# ===================================
FROM alpine:edge

ADD start.sh /bootstrap/
COPY /app /app/public

# Add repos
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    # Install extension
    && apk update && apk upgrade \
    && apk add --no-cache \
    openssl php7 \
    php7-apache2 apache2 php7-json \
    php7-openssl php7-mcrypt \
    php7-mbstring php7-pdo_pgsql \
    php7-tokenizer php7-session \
    # tzdata openntpd \
    # copy php and remove cache
    && cp /usr/bin/php7 /usr/bin/php \
    && rm -f /var/cache/apk/* \
    # Add apache to run and configure
    && sed -i "s/#ServerName www.example.com:80/ServerName localhost/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ session_module/LoadModule\ session_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ session_cookie_module/LoadModule\ session_cookie_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ session_crypto_module/LoadModule\ session_crypto_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ deflate_module/LoadModule\ deflate_module/" /etc/apache2/httpd.conf \
    && sed -i "s#^DocumentRoot \".*#DocumentRoot \"/app/public\"#g" /etc/apache2/httpd.conf \
    && sed -i "s#/var/www/localhost/htdocs#/app/public#" /etc/apache2/httpd.conf \
    && printf "\n<Directory \"/app/public\">\n\tAllowOverride All\n</Directory>\n" >> /etc/apache2/httpd.conf \
    # set php.ini
    && sed -i "s/\;\?\\s\?max_file_uploads = .*/max_file_uploads = 100M/" /etc/php7/php.ini \
    && sed -i "s/\;\?\\s\?memory_limit = .*/memory_limit = 128M/" /etc/php7/php.ini \
    && sed -i "s/\;\?\\s\?post_max_size = .*/post_max_size = 100M/" /etc/php7/php.ini \
    # set permission
    && chown -R apache:apache /app \
    && chmod -R 755 /app \
    && chmod +x /bootstrap/start.sh

EXPOSE 80
ENTRYPOINT ["/bootstrap/start.sh"]
