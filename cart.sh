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

id roboshop &>> $LOGFILE
if [ $? -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "Adding roboshop user"
else
    echo -e "roboshop user already exist...$Y SKIPPING $N"
fi

rm -rf /app &>> $LOGFILE
VALIDATE $? "clean up existing directory"


# mkdir /app &>>$LOGFILE

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$LOGFILE

VALIDATE $? "Download the application code"

cd /app &>>$LOGFILE

VALIDATE $? "move app directory"

unzip /tmp/cart.zip &>>$LOGFILE

VALIDATE $? "unzip cart"

cd /app &>>$LOGFILE

VALIDATE $? "download the dependencies."

npm install &>>$LOGFILE

VALIDATE $? "Install NodeJS"

#Give the full path of cart.service because we inside the /app
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>>$LOGFILE

VALIDATE $? "Setup SystemD cart Service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "Load the service"

systemctl start cart &>>$LOGFILE

VALIDATE $? "Start the service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "Daemon-reload"

systemctl start cart &>>$LOGFILE

VALIDATE $? "start cart"

