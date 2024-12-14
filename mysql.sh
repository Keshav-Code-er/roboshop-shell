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

dnf module disable mysql -y &>>$LOGFILE

VALIDATE $? "Disable Module"

cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>$LOGFILE

VALIDATE $? "Download the application code"

dnf install mysql-community-server -y &>>$LOGFILE

VALIDATE $? "Install Mysql Comm."

systemctl enable mysqld &>>$LOGFILE

VALIDATE $? "Enable Mysql"

systemctl start mysqld &>>$LOGFILE

VALIDATE $? "Start Mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOGFILE

VALIDATE $? "Set Password"
