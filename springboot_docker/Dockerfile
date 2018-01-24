# ubuntu+Nginx

FROM centos:7

MAINTAINER hesimin

WORKDIR /app

ENV LANG zh_CN.UTF-8

COPY jdk1.8 /usr/lib/jvm/java-8

COPY spring-boot.sh spring-boot.sh
RUN chmod +x spring-boot.sh

ENV JAVA_HOME=/usr/lib/jvm/java-8
ENV PATH=$JAVA_HOME/bin:$PATH
ENV CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar


# EXPOSE 22

# ENTRYPOINT ["java","start","/app.jar"]