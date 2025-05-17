# Use lightweight Nginx image
FROM nginx:alpine

# 1. Cleanup default files (your existing requirement)
RUN rm -rf /usr/share/nginx/html/*

# 2. Permission fixes (new additions)
RUN mkdir -p /var/cache/nginx/client_temp && \
    chmod -R 755 /var/cache/nginx && \
    chown -R nginx:nginx /var/cache/nginx

# 3. Copy application files
COPY . /usr/share/nginx/html

# 4. Run as nginx user (UID 101) for security
USER nginx

# 5. Expose port
EXPOSE 80
