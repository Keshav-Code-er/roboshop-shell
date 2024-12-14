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

dnf install nodejs -y &>>$LOGFILE

VALIDATE $? "Install NodeJS"

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$LOGFILE

VALIDATE $? "Download the application code"

cd /app &>>$LOGFILE

VALIDATE $? "move app directory"

unzip /tmp/user.zip &>>$LOGFILE

VALIDATE $? "unzip user"

cd /app &>>$LOGFILE

VALIDATE $? "download the dependencies."

npm install &>>$LOGFILE

VALIDATE $? "Install NodeJS"

#Give the full path of user.service because we inside the /app
cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service &>>$LOGFILE

VALIDATE $? "Setup SystemD user Service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "Load the service"

systemctl start user &>>$LOGFILE

VALIDATE $? "Start the service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "Install NodeJS"

systemctl start user &>>$LOGFILE

VALIDATE $? "Install NodeJS"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo  &>>$LOGFILE

VALIDATE $? "setup MongoDB repo "

dnf install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? " install mongodb-client"

mongo --host mongodb.joindevops.online </app/schema/user.js &>>$LOGFILE

VALIDATE $? "Load Schema"
