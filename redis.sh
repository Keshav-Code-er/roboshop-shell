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



dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE

VALIDATE $? "Installing Redis Repo. "

dnf module enable redis:remi-6.2 -y &>>$LOGFILE

VALIDATE $? "Enable Redis:remi-6.2"

dnf install redis -y &>>$LOGFILE

VALIDATE $? "Install Redis 6.2"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf /etc/redis/redis.conf &>>$LOGFILE

VALIDATE $? "Update listen address"

systemctl enable redis &>>$LOGFILE

VALIDATE $? "Enable Redis"

systemctl start redis &>>$LOGFILE

VALIDATE $? "Start Redis"


