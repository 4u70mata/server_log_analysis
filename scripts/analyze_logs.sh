#!/bin/bash

#Web Server Log Analysis Script -Version 1


LOG_ARCHIVE="data/web_logs.tar.gz"
LOG_FILE="data/raw_web_log.txt"


#Generate Sample DAta

echo "Generating sample data..."
cat > $LOG_FILE << 'EOF'
192.168.1.1 - - [21/Apr/2024:10:30:01 +0000] "GET /index.html HTTP/1.1" 200 1524 "https://www.google.com" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
192.168.1.77 - - [21/Apr/2024:10:30:02 +0000] "GET /images/logo.png HTTP/1.1" 200 4578 "https://example.com/index.html" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
192.168.1.1 - - [21/Apr/2024:10:30:03 +0000] "GET /about.html HTTP/1.1" 200 3421 "https://example.com/index.html" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
EOF


# Create the Archive 
tar  -cvzf $LOG_ARCHIVE -C data/ raw_web_log.txt

# Remove raw log to start all over
rm $LOG_FILE

echo "Sample Data Created : $LOG_ARCHIVE"
