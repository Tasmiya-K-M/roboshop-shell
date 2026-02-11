#setting up the hostname
echo -e "\e[33msetting the hostname\e[0m"
hostnamectl set-hostname redis

#Enable Redis 6.2 from package streams.
echo -e "\e[33menable the redis 6.2 package\e[0m"
dnf module disable redis -y &>> /tmp/roboshop.log
dnf module enable redis:6 -y &>> /tmp/roboshop.log

#Install Redis
echo -e "\e[33minstall the redis\e[0m"
dnf install redis -y &>> /tmp/roboshop.log

#Edit the config file
echo -e "\e[33mediting the config file\e[0m"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf

#start and enable the redis service
echo -e "\e[33menable and restart service\e[0m"
systemctl enable redis &>> /tmp/roboshop.log 
systemctl restart redis &>> /tmp/roboshop.log