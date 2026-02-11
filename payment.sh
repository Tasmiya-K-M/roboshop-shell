echo -e "\e[33msetting the hostname\e[0m"
hostnamectl set-hostname payment

#install python
echo -e "\e[33minstall python\e[0m"
dnf install python36 gcc python3-devel -y &>> /tmp/roboshop.log

#create the user
echo -e "\e[33mcreate the user\e[0m"
useradd roboshop &>> /tmp/roboshop.log

#create the app dir
echo -e "\e[33mcreate the app dir\e[0m"
rm -rf /app
mkdir /app 

#download the app code
echo -e "\e[33mdownload the app code\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>> /tmp/roboshop.log
cd /app 

#unzip the folder
echo -e "\e[33munzip the folder\e[0m"
unzip /tmp/payment.zip &>> /tmp/roboshop.log

#install the dependencies
echo -e "\e[33minstall the dependencies\e[0m"
pip3.6 install -r requirements.txt &>> /tmp/roboshop.log

#create the service file
echo -e "\e[33mcreate the service file\e[0m"
cp /home/centos/learn-shell/payment.service /etc/systemd/system/payment.service &>> /tmp/roboshop.log

#load the service
echo -e "\e[33mload the service\e[0m"
systemctl daemon-reload 

#enable and restart the service
echo -e "\e[33menable and restart the service\e[0m"
systemctl enable payment &>> /tmp/roboshop.log
systemctl restart payment