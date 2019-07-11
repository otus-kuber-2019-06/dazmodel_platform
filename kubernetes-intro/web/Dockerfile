FROM nginx:1.17.1-alpine

LABEL maintainer="ssinenok@gmail.com"

COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY ./app/homework.html /app/homework.html

WORKDIR /app
RUN chown -R 1001 /app
RUN chown -R 1001 /var/cache/nginx
RUN touch /var/run/nginx.pid && chown -R 1001 /var/run/nginx.pid

USER 1001

EXPOSE 8000