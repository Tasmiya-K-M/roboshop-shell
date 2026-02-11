echo -e "\e[33msetting the hostname\e[0m"
hostnamectl set-hostname dispatch

#install golang
echo -e "\e[33minstall golang\e[0m"
dnf install golang -y &>> /tmp/roboshop.log

#create user
echo -e "\e[33mcreate user\e[0m"
useradd roboshop &>> /tmp/roboshop.log

#create app directory
echo -e "\e[33mcreate app directory\e[0m"
rm -rf /app
mkdir /app &>> /tmp/roboshop.log

#download app code
echo -e "\e[33mdownload app code\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>> /tmp/roboshop.log
cd /app 

#unzip the folder
echo -e "\e[33munzip the folder\e[0m"
unzip /tmp/dispatch.zip &>> /tmp/roboshop.log

#install dependencies
echo -e "\e[33minstall dependencies\e[0m"
go mod init dispatch &>> /tmp/roboshop.log
go get &>> /tmp/roboshop.log
go build &>> /tmp/roboshop.log

#create the service file
echo -e "\e[33mcreate the dispatch service file\e[0m"
cp /home/centos/learn-shell/dispatch.service /etc/systemd/system/dispatch.service &>> /tmp/roboshop.log

#load, enable and restart service
echo -e "\e[33mload, enable and restart dispatch service\e[0m"
systemctl daemon-reload
systemctl enable dispatch &>> /tmp/roboshop.log
systemctl restart dispatch