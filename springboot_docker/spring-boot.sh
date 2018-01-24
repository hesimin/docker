#!/bin/bash

export JAVA_HOME=/home/java
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

JAVA_OPTIONS=" -Xms512M -Xmx512M "

_JAR_KEYWORDS=" $2"
_JAR_NAME=`echo "$_JAR_KEYWORDS"|grep -oP '[^/| ]+\.(jar)'`
APP_NAME=$2

JAVA_CMD="-jar $JAVA_OPTIONS $_JAR_KEYWORDS"


echo "*********************  spring-boot.sh  ***************************"
CURR_DIR=`pwd`
echo "java_home= $JAVA_HOME"
echo `java -version`
echo `ps aux | grep ${_JAR_NAME} |grep java`
echo " current dir： ${CURR_DIR}"
echo "**** JAVA_CMD****:   $JAVA_CMD  "


 
function check_if_process_is_running {
 PID=$(ps aux | grep ${_JAR_NAME} |grep java| grep -v grep | awk '{print $2}' )
 if [ "$PID" = "" ]; then
   return 1
 else
   return 0
 fi
}
check_if_process_is_running
 
case "$1" in
  status)
    if check_if_process_is_running
    then
      echo -e "$APP_NAME is running "
    else
      echo -e "$APP_NAME not running "
    fi
    ;;
  stop)
    if ! check_if_process_is_running
    then
      echo  -e "$APP_NAME  already stopped "
      exit 0
    fi
    kill  $PID
    echo -e "Waiting for process to stop "
    while check_if_process_is_running; do
        echo -ne ". "
        sleep 1
    done
    echo
    if check_if_process_is_running
    then
      echo -e "Cannot kill process "
      exit 1
    fi
    echo  -e "$APP_NAME stop success "
    ;;
  start)
    if check_if_process_is_running
    then
      #echo -e "already running: $APP_NAME  "
      #exit 1
      echo -ne "Waiting for process to stop: $PID "
      kill  $PID
      for i in {1..20}; do
        if check_if_process_is_running; then
          echo -ne ". "
          sleep 1
        fi
      done
      echo
      if check_if_process_is_running; then
         echo -e "Cannot kill process, using kill -9 $PID "
         kill -9 $PID
         sleep 5
      fi
      if check_if_process_is_running; then
         echo -e "!!!!!!!!!  Cannot stop process  !!!!!!!!!"
         exit 1
      fi
    fi
    nohup java $JAVA_CMD >/dev/null 2>&1 & 
 
    echo -ne "Starting "
    for i in {1..20}; do
      if ! check_if_process_is_running; then
          echo -ne ". "
          sleep 1
      fi
    done
    echo
 
    sleep 5
    if check_if_process_is_running 
     then
       echo  -e "=========  Started  ====== $APP_NAME ========="
    else
       echo  -e "!!!!!!!!!  Fail  !!!!!!!!!!!   $APP_NAME  !!!!!!!!!!!"
       exit 1
    fi
    ;;
  restart)
    $0 stop
    if [ $? = 1 ]
    then
      exit 1
    fi
    $0 start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
esac
 
exit 0

