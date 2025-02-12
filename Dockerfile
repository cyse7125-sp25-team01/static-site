# Use official Caddy image
FROM caddy:2.6.4

# Copy the static site and Caddy configuration
COPY index.html /usr/share/caddy/index.html
COPY Caddyfile /etc/caddy/Caddyfile

# Expose port 8080
EXPOSE 8080

# Start Caddy
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]
