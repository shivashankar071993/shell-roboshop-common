#!bin/bash

source ./common.sh

nodejs_setup

app_name=catalogue

app_setup
nodejs_setup
systemd_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? " copying mongo repo"
dnf install mongodb-mongosh -y  &>>$LOG_FILE
VALIDATE $? "installing mongodb clinet"
mongosh --host $MONGODB_HOST </app/db/master-data.js & >>$LOG_FILE

VALIDATE $? "Load catalogue products"

restart_app

print_total_time