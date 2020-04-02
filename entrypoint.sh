#!/bin/sh

# option to run startup scripts if exist
FILE=startup.sh
if [ -f "$FILE" ]; then
    echo "$FILE exist! Running startup process before starting apache..."
    source "$FILE"
else 
    echo "$FILE does not exist! Skipping startup process."
fi

# Start (ensure apache2 PID not left behind first) to stop auto start crashes if didn't shut down properly
echo "Clearing any old processes..."
rm -f /run/apache2/apache2.pid
rm -f /run/apache2/httpd.pid

echo "Starting apache..."
httpd -D FOREGROUND
