#cart service
#hii
echo -e "\e[33msetting the hostname\e[0m"
hostnamectl set-hostname cart

# disable the default nodejs
echo -e "\e[33mdisable the default nodejs\e[0m"
dnf module disable nodejs -y &>> /tmp/roboshop.log

# enable the nodejs 18
echo -e "\e[33menable the nodejs 18\e[0m"
dnf module enable nodejs:18 -y &>> /tmp/roboshop.log

# install nodejs
echo -e "\e[33minstall nodejs\e[0m"
dnf install nodejs -y &>> /tmp/roboshop.log

# create the user
echo -e "\e[33mcreate the user\e[0m"
useradd roboshop &>> /tmp/roboshop.log

# create the app dir
echo -e "\e[33mcreate the app dir\e[0m"
mkdir /app 

# download the app code
echo -e "\e[33mdownload the app code\e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip  &>> /tmp/roboshop.log

# unzip the app code in app folder
echo -e "\e[33munzip the app code in app folder\e[0m"
cd /app 
unzip /tmp/cart.zip &>> /tmp/roboshop.log

# install the dependencies
echo -e "\e[33minstall the dependencies\e[0m"
npm install &>> /tmp/roboshop.log

# created cart service file
echo -e "\e[33mcreated cart service file\e[0m"
cp /home/centos/learn-shell/cart.service /etc/systemd/system/

# load the service
echo -e "\e[33mload the service\e[0m"
systemctl daemon-reload

# enable the service
echo -e "\e[33menable the service\e[0m"
systemctl enable cart &>> /tmp/roboshop.log

# restart the service
echo -e "\e[33mrestart the service\e[0m"
systemctl restart cart