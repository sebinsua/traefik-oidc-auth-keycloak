#!/bin/sh
set -e

echo "$(date): Starting health check" >> /tmp/healthcheck.log
echo "$(date): Checking health endpoint at localhost:9000/health" >> /tmp/healthcheck.log

# Function to send HTTP request and capture response
http_get() {
  exec 3<>/dev/tcp/localhost/9000
  echo -e "GET /health HTTP/1.1\r\nHost: localhost\r\nConnection: close\r\n\r\n" >&3
  response=$(cat <&3)
  exec 3<&-
  exec 3>&-
  echo "$response"
}

# Perform the health check
response=$(http_get)

# Check if the response contains "UP" (adjust this based on the actual expected response)
if echo "$response" | grep -q "UP"; then
    echo "$(date): Health check successful" >> /tmp/healthcheck.log
    echo "$response" >> /tmp/healthcheck.log
    exit 0
else
    echo "$(date): Health check failed" >> /tmp/healthcheck.log
    echo "$response" >> /tmp/healthcheck.log
    exit 1
fi