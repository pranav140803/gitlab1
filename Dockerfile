FROM ubuntu:latest
LABEL maintainer="Mihir"
WORKDIR ./
RUN apt-get update -y
RUN apt-get install nginx -y
RUN rm -rf /var/www/html/*
ADD index.html /var/www/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
