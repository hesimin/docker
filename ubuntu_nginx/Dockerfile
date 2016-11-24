# ubuntu+Nginx

FROM ubuntu

MAINTAINER hesimin


RUN echo "deb http://archive.ubuntu.com/ubuntu/ raring main universe" >> /etc/apt/sources.list

# RUN apt-get update && apt-get install -y nginx

RUN apt-get install -y nginx

RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

EXPOSE 80
CMD /usr/sbin/nginx
