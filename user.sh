echo -e "\e[33msetting the hostname\e[0m"
hostnamectl set-hostname user

# disable the default nodejs and enable the nodejs 18
echo -e "\e[33mdisable the default nodejs and enable the nodejs 18\e[0m"
dnf module disable nodejs -y &>> /tmp/roboshop.log
dnf module enable nodejs:18 -y &>> /tmp/roboshop.log

#install nodejs 18
echo -e "\e[33minstall nodejs 18\e[0m"
dnf install nodejs -y &>> /tmp/roboshop.log

#create user
echo -e "\e[33mcreate user\e[0m"
useradd roboshop &>> /tmp/roboshop.log

#create the directory
echo -e "\e[33mcreate the directory\e[0m"
rm -rf /app
mkdir /app 

#download the app code
echo -e "\e[33mdownload the app code\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>> /tmp/roboshop.log

#unzip the app code under /app directory
echo -e "\e[33munzip the app code under /app directory\e[0m"
cd /app 
unzip /tmp/user.zip &>> /tmp/roboshop.log

#install the dependencies
echo -e "\e[33minstall the dependencies\e[0m"
npm install &>> /tmp/roboshop.log

#service file
echo -e "\e[33mservice file\e[0m"
cp /home/centos/learn-shell/user.service /etc/systemd/system/

#load the servcie
echo -e "\e[33mload service file\e[0m"
systemctl daemon-reload 

#enable and restart the service
echo -e "\e[33menable and restart the service\e[0m"
systemctl enable user &>> /tmp/roboshop.log
systemctl restart user 

#setup MongoDB repo
echo -e "\e[33msetup MongoDB repo\e[0m"
cp /home/centos/learn-shell/mongo-client.repo /etc/yum.repos.d/

#Installing Mongo client
echo -e "\e[33mInstalling Mongo cliento\e[0m"
dnf install mongodb-org-shell -y &>> /tmp/roboshop.log

#Load the data into mongodb using mongo-client
echo -e "\e[33mLoad the data into mongodb using mongo-client\e[0m"
mongo --host mongodb-dev.devopspro789.online </app/schema/user.js &>> /tmp/roboshop.log
