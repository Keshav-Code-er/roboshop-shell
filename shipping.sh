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

dnf install maven -y &>>$LOGFILE

VALIDATE $? "Install Maven"

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$LOGFILE

VALIDATE $? "Download the application code"

cd /app &>>$LOGFILE

VALIDATE $? "move app directory"

unzip /tmp/shipping.zip &>>$LOGFILE

VALIDATE $? "Unzip shipping"

cd /app &>>$LOGFILE

VALIDATE $? "Dependencies"

mvn clean package &>>$LOGFILE

VALIDATE $? "Clean Package"

mv target/shipping-1.0.jar shipping.jar &>>$LOGFILE

VALIDATE $? "Target Shipping"

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>>$LOGFILE

VALIDATE $? "Setup SystemD Shipping Service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "Demon reload"

systemctl start shipping &>>$LOGFILE

VALIDATE $? "Start Shipping"

dnf install mysql -y &>>$LOGFILE

VALIDATE $? "Install mysql"

mysql -h  <MYSQL-SERVER-IPADDRESS >-uroot </app/schema/shipping.sql &>>$LOGFILE

VALIDATE $? "Load Schema"

systemctl restart shipping &>>$LOGFILE

VALIDATE $? "Restart Shipping"
