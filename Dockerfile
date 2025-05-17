# Use lightweight Nginx image
FROM nginx:alpine

# Delete default Nginx files
RUN rm -rf /usr/share/nginx/html/*

# Copy all files from your repo to Nginx's serving directory
COPY . /usr/share/nginx/html

# Expose port 80 (HTTP)
EXPOSE 80
