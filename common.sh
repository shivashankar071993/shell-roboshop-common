#!bin/bash

#CODE started 


R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SCRIPT_DIR=$PWD
MONGODB_HOST="mongodb.daws8s.shop"

USERID=$(id -u)

LOGS_FOLDER="/var/log/roboshop"
SCRIPT_NAME=$(echo $0| cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "SCRIPT started executing $(date)" | tee -a $LOG_FILE 

start_time=$(date +%s)

date &>>$LOG_FILE
USERID=$(id -u)
check_root() 
{
if [ $USERID -ne 0 ] ; then
    echo " Please run with root user else will not work"
    exit 1
fi
}

VALIDATE(){

    if [ $1 -ne 0 ] ;  then 
         echo -e "$2... $R failure $N"
        exit 1
    else
         echo "$2... $G success $N"

    fi
}

nodejs_setup(){

    dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "DISABLING NODE JS"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "enable node js" 

dnf install nodejs -y &>>$LOG_FILE

npm install &>>$LOG_FILE
VALIDATE $? "npm install"
}



app_setup() {

    mkdir -p /app 
VALIDATE $? "app directory creation"

curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip  &>>LOG_FILE 

VALIDATE $? "downloading to $app_name app" 
cd /app 
rm -rf /app/*
VALIDATE $? "cleaning everthing in app directory"
unzip /tmp/$app_name.zip &>>$LOG_FILE

}


systemd_setup () {
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
VALIDATE $? "copying $app_name service "

systemctl daemon-reload
VALIDATE $? " demon reaload"
    
}

print_total_time() {

    End_time=$(date +%s)
TOTAL_TIME=$(($End_time - $start_time))
echo -e "script execution time in : $Y $TOTAL_TIME Seconds $N"

}

restart_app() {
    
systemctl restart $app_name
VALIDATE $? "restarted $app_name" 

}