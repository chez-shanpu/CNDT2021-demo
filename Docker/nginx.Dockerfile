FROM nginx:latest

COPY allow.html /usr/share/nginx/html/allow/index.html
COPY deny.html /usr/share/nginx/html/deny/index.html
