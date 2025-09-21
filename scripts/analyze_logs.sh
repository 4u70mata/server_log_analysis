#!/bin/bash

# Web Server Log Analysis Version 2
LOG_ARCHIVE="data/web_logs.tar.gz"
LOG_FILE="data/raw_web_log.txt"

# Colors for output styling 
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # For No color

# Helper Functions
print_status() { echo -e "${YELLOW}[*]${NC} $1"; }
print_success() { echo -e "${GREEN}[+]${NC} $1"; }
print_error() { echo -e "${RED}[-]${NC} $1"; }

# Generate Sample Data
generate_sample_data() {
    print_status "Generating sample data..."
    cat > $LOG_FILE << 'EOF'
192.168.1.1 - - [21/Apr/2024:10:30:01 +0000] "GET /index.html HTTP/1.1" 200 1524 "https://www.google.com" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
192.168.1.77 - - [21/Apr/2024:10:30:02 +0000] "GET /images/logo.png HTTP/1.1" 200 4578 "https://example.com/index.html" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
192.168.1.1 - - [21/Apr/2024:10:30:03 +0000] "GET /about.html HTTP/1.1" 200 3421 "https://example.com/index.html" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
203.0.113.5 - - [21/Apr/2024:10:30:04 +0000] "GET /admin.php HTTP/1.1" 403 1239 "-" "Mozilla/5.0 (compatible; BadBot/1.0; +http://bad.bot)"
192.168.1.1 - - [21/Apr/2024:10:30:07 +0000] "GET /favicon.ico HTTP/1.1" 404 196 "https://example.com/contact.php" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0"
EOF

    # Create the Archive 
    tar -czf $LOG_ARCHIVE -C data/ raw_web_log.txt

    # Remove raw log to start all over
    rm $LOG_FILE

    print_success "Sample Data Created: $LOG_ARCHIVE"
}

# Function To extract logs 
extract_logs() {
    if [ -f "$LOG_ARCHIVE" ]; then
        tar -xzf $LOG_ARCHIVE -C data/
        print_success "Logs Extracted Successfully."
    else
        print_error "Error: Log Archive Not Found"
        exit 1
    fi
}

# Generate data if it doesn't exist 
if [ ! -f "$LOG_ARCHIVE" ]; then 
    generate_sample_data
fi

# Extract the logs 
extract_logs

# Perform Basic Analysis
echo "=== ANALYSIS REPORT ==="
echo "Total requests: $(wc -l < $LOG_FILE)"
echo ""
echo "Top IP Addresses:"
awk '{print $1}' $LOG_FILE | sort | uniq -c | sort -nr
echo ""
echo "404 Errors:"
grep " 404 " $LOG_FILE
