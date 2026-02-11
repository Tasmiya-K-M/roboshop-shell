echo -e "\e[33msetting the hostname\e[0m"
hostnamectl set-hostname shipping

#Install maven
echo -e "\e[33mInstall maven\e[0m"
dnf install maven -y &>> /tmp/roboshop.log

#create user
echo -e "\e[33mcreate user\e[0m"
useradd roboshop &>> /tmp/roboshop.log

#create app dir
echo -e "\e[33mcreate app dir\e[0m"
rm -rf /app
mkdir /app &>> /tmp/roboshop.log

#download app shipping code
echo -e "\e[33mdownload app shipping code\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip  &>> /tmp/roboshop.log

#unzip the folder
echo -e "\e[33munzip the folder\e[0m"
cd /app 
unzip /tmp/shipping.zip &>> /tmp/roboshop.log

#install dependencies
echo -e "\e[33minstall dependencies\e[0m"
mvn clean package &>> /tmp/roboshop.log
mv target/shipping-1.0.jar shipping.jar &>> /tmp/roboshop.log

#create the shipping service file
echo -e "\e[33mcreate the shipping service file\e[0m"
cp /home/centos/learn-shell/shipping.service /etc/systemd/system/ &>> /tmp/roboshop.log

#load the service
echo -e "\e[33mload the service\e[0m"
systemctl daemon-reload 

#enable the service
echo -e "\e[33menable the service\e[0m"
systemctl enable shipping &>> /tmp/roboshop.log

#install mysql-client
echo -e "\e[33minstall mysql-client\e[0m"
dnf install mysql -y &>> /tmp/roboshop.log

#load the data
echo -e "\e[33mload the data\e[0m"
mysql -h mysql-dev.devopspro789.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> /tmp/roboshop.log

#restart the service
echo -e "\e[33mrestart the service\e[0m"
systemctl restart shipping