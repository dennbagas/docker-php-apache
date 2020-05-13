FROM alpine:edge

# copy entrypoint
ADD entrypoint.sh /app/
# copy dumnmy data
COPY /app /app/public

# Add repository
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    # update image first
    && apk update && apk upgrade \
    && apk add --no-cache \
    # install opensll and php7
    openssl php7 \
    # install apache2
    php7-apache2 apache2 \ 
    # install php extension
    php7-json php7-openssl php7-mcrypt \
    php7-mbstring php7-pdo_pgsql php7-gd \
    php7-tokenizer php7-session \
    php7-fileinfo php7-curl php7-xml php7-simplexml \
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
    # set permission
    && chown -R apache:apache /app \
    && chmod -R 755 /app \
    && chmod +x /app/entrypoint.sh

# set workdir to /app
WORKDIR /app

# expose port 80
EXPOSE 80
# set entrypoint to start.sh
ENTRYPOINT ["sh","/app/entrypoint.sh"]
