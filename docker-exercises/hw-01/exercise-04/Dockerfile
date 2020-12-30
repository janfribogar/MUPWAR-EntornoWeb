FROM nginx:1.19.3-alpine
COPY ./index.html /usr/share/nginx/html
HEALTHCHECK --interval=45s --timeout=5s --retries=2 CMD curl -f http://localhost/ || exit 1