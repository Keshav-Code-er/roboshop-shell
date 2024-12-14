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


dnf install nginx -y  &>>$LOGFILE

VALIDATE $? "Install Nginx"

systemctl enable nginx  &>>$LOGFILE

VALIDATE $? "Enable Nginx"

systemctl start nginx  &>>$LOGFILE

VALIDATE $? "Start Nginx"

rm -rf /usr/share/nginx/html/*  &>>$LOGFILE

VALIDATE $? "Remove Nginx default index"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip  &>>$LOGFILE

VALIDATE $? "Donloading"

cd /usr/share/nginx/html  &>>$LOGFILE

VALIDATE $? "Move to Folder"

unzip /tmp/web.zip  &>>$LOGFILE

VALIDATE $? "Unzip the File"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf  &>>$LOGFILE

VALIDATE $? "Configuration"

systemctl restart nginx  &>>$LOGFILE

VALIDATE $? "Restart Nginx"