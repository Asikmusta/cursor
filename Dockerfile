FROM nginx:alpine

# Remove default content
RUN rm -rf /usr/share/nginx/html/*

# Create alternative temp directories we can write to
RUN mkdir -p /tmp/nginx/cache && \
    ln -s /tmp/nginx/cache /var/cache/nginx

# Custom nginx config to use writable paths
COPY /tmp/build/inputs/nginx.conf /etc/nginx/nginx.conf

# Copy app files
COPY . /usr/share/nginx/html

# Add a non-root user with a standard UID/GID and no password (Alpine-compatible)
RUN addgroup -g 1000 myusergroup && \
    adduser -u 1000 -G myusergroup -D -h /usr/share/nginx/html myuser

# Make /tmp/nginx and /run and /etc/nginx/conf.d writable by the non-root user
RUN chown -R myuser:myusergroup /tmp/nginx /run /etc/nginx/conf.d

# Change ownership of /usr/share/nginx/html to the new user
RUN chown -R myuser:myusergroup /usr/share/nginx/html

# Switch to the non-root user
USER myuser

EXPOSE 8080
