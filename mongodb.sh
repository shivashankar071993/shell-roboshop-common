#!bin/bash

source ./common.sh

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Adding Mongo repo"

dnf install mongodb-org -y &>>LOG_FILE
VALIDATE $? "Installing mongo db"

systemctl enable mongod 
VALIDATE $? "enable mongodB"


systemctl start mongod 

VALIDATE $? "Start  mongodB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing remote connections to MongoDB"

systemctl restart mongod
VALIDATE $? "mongodb restarted"  

print_total_time