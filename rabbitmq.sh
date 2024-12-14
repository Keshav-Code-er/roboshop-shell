#!/bin/bash

DATE=$(date +%F)
LOGDIR=/tmp
#/home/centos/shell-script/shell_script-log/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGDIR/$0-$DATE.log
USERID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ]; then
    echo -e "$R ERROR:: Please run this script in root access $N"
    exit 1
fi

VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e " $2 ... $R FAILURE $N"
        exit 1
    else
        echo -e " $2 ... $G SUCCESS $N"
    fi
}

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOGFILE

VALIDATE $? "Download Artifact"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOGFILE

VALIDATE $? "Download Artifact"

dnf install rabbitmq-server -y &>>$LOGFILE

VALIDATE $? "Install Rabbitmq"

systemctl enable rabbitmq-server &>>$LOGFILE

VALIDATE $? "Enable rabbitmq"

systemctl start rabbitmq-server &>>$LOGFILE

VALIDATE $? "Start Rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>>$LOGFILE

VALIDATE $? "Unzip Rabbitmq"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE

VALIDATE $? "Unzip Rabbitmq"
