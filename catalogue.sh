component=catalogue
color="\e[33m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"


echo -e "${color}setting the hostname${nocolor}"
hostnamectl set-hostname ${component}

echo -e "${color}Disabling the default nodejs version${nocolor}"
dnf module disable nodejs -y &>> ${log_file}

echo -e "${color}Enabling the nodejs 18${nocolor}"
dnf module enable nodejs:18 -y &>> ${log_file}

#Install NodeJS
echo -e "${color}Installing the nodejs 18${nocolor}"
dnf install nodejs -y &>> ${log_file}

#Add application User
echo -e "${color}Added the app user${nocolor}"
useradd roboshop &>> ${log_file}

#setup an app directory.
echo -e "${color}Setup app directory${nocolor}"
rm -rf /app
mkdir /app 


#Download the application code 
echo -e "${color}Download app code${nocolor}"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>> ${log_file}

#unzip the file
echo -e "${color}Unzip the file${nocolor}"
cd /app 
unzip /tmp/${component}.zip &>> ${log_file}

#download the dependencies.
echo -e "${color}Downloading dependencies${nocolor}"
npm install  &>> ${log_file}

#Setup SystemD Catalogue Service
echo -e "${color}Setting up ${component} Service${nocolor}"
cp /home/centos/roboshop-shell/${component}.service /etc/systemd/system/

#Load the service.
echo -e "${color}Load the ${component} service${nocolor}"
systemctl daemon-reload

#enable and restart the service
echo -e "${color}Enable and restart catalogue service${nocolor}"
systemctl enable ${component} &>> ${log_file}
systemctl restart ${component}

#setup MongoDB-Client repo
echo -e "${color}setup mongodb-client repo${nocolor}"
cp /home/centos/roboshop-shell/mongo-client.repo /etc/yum.repos.d/

#Installing mongodb-client
echo -e "${color}Installing mongodb-client${nocolor}"
dnf install mongodb-org-shell -y &>> ${log_file}

#Load the data into mongodb using mongo-client
echo -e "${color}Load the data into mongodb using mongo-client${nocolor}"
mongo --host mongodb-dev.devopspro789.online </app/schema/${component}.js &>> ${log_file}


