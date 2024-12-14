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

dnf install python36 gcc python3-devel -y &>>$LOGFILE

VALIDATE $? "Install python"

useradd roboshop

mkdir /app

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>$LOGFILE

VALIDATE $? "Download the application Artifact"

cd /app &>>$LOGFILE

VALIDATE $? "move app directory"

unzip /tmp/payment.zip &>>$LOGFILE

VALIDATE $? "Unzip Payment"

pip3.6 install -r requirements.txt &>>$LOGFILE

VALIDATE $? "Target Shipping"

cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>>$LOGFILE

VALIDATE $? "Setup SystemD payment.service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "Demon Reload"

systemctl enable payment &>>$LOGFILE

VALIDATE $? "Enable Payment"

systemctl start payment &>>$LOGFILE

VALIDATE $? "Start Payment"
