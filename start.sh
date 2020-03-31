#!/bin/sh

# PHP Config
sed -i "s|\;\?\\s\?date.timezone = .*|date.timezone = Asia/Jakarta|" /etc/php7/php.ini
sed -i "s|\;\?\\s\?memory_limit = .*|memory_limit = 4G|" /etc/php7/php.ini
sed -i "s|\;\?\\s\?post_max_size = .*|post_max_size = 350M|" /etc/php7/php.ini
sed -i "s|\;\?\\s\?max_file_uploads = .*|max_file_uploads = 10|" /etc/php7/php.ini
sed -i "s|\;\?\\s\?upload_max_filesize = .*|upload_max_filesize = 300M|" /etc/php7/php.ini

# check sh source location
pwd

# sed this to enable laravel auto migration on production
#php artisan migrate

# Start (ensure apache2 PID not left behind first) to stop auto start crashes if didn't shut down properly
echo "Clearing any old processes..."
rm -f /run/apache2/apache2.pid
rm -f /run/apache2/httpd.pid

echo "Starting apache..."
httpd -D FOREGROUND
