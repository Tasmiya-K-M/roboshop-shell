echo -e "\e[33msetting the hostname\e[0m"
hostnamectl set-hostname catalogue

echo -e "\e[33mDisabling the default nodejs version\e[0m"
dnf module disable nodejs -y &>> /tmp/roboshop.log

echo -e "\e[33mEnabling the nodejs 18\e[0m"
dnf module enable nodejs:18 -y &>> /tmp/roboshop.log

#Install NodeJS
echo -e "\e[33mInstalling the nodejs 18\e[0m"
dnf install nodejs -y &>> /tmp/roboshop.log

#Add application User
echo -e "\e[33mAdded the app user\e[0m"
useradd roboshop 

#setup an app directory.
echo -e "\e[33mSetup app directory\e[0m"
rm -rf /app
mkdir /app 


#Download the application code 
echo -e "\e[33mDownload app code\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>> /tmp/roboshop.log

#unzip the file
echo -e "\e[33mUnzip the file\e[0m"
cd /app 
unzip /tmp/catalogue.zip &>> /tmp/roboshop.log

#download the dependencies.
echo -e "\e[33mDownloading dependencies\e[0m"
npm install  &>> /tmp/roboshop.log

#Setup SystemD Catalogue Service
echo -e "\e[33mSetting up Catalogue Service\e[0m"
cp /home/centos/learn-shell/catalogue.service /etc/systemd/system/

#Load the service.
echo -e "\e[33mLoad the service\e[0m"
systemctl daemon-reload

#enable and restart the service
echo -e "\e[33mEnable and restart the service\e[0m"
systemctl enable catalogue &>> /tmp/roboshop.log
systemctl start catalogue

#setup MongoDB repo
cp /home/centos/learn-shell/mongo-client.repo /etc/yum.repos.d/

#Installing Mongo client
dnf install mongodb-org-shell -y &>> /tmp/roboshop.log

#Load the data into mongodb using mongo-client
mongo --host mongodb-dev.devopspro789.online </app/schema/catalogue.js &>> /tmp/roboshop.log


