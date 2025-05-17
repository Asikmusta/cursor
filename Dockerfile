FROM nginx:alpine

# Remove default content
RUN rm -rf /usr/share/nginx/html/*

# Create alternative temp directories we can write to
RUN mkdir -p /tmp/nginx/cache && \
    ln -s /tmp/nginx/cache /var/cache/nginx

# Custom nginx config to use writable paths
COPY nginx.conf /etc/nginx/nginx.conf

# Copy app files
COPY . /usr/share/nginx/html

# Run as nginx user (UID 101)
USER 101

EXPOSE 80
