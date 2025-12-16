#!bin/bash

#CODE started 


R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

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

print_total_time() {

    End_time=$(date +%s)
TOTAL_TIME=$(($End_time - $start_time))
echo -e "script execution time in : $Y $TOTAL_TIME Seconds $N"

}