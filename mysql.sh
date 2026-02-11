echo -e "\e[33msetting the hostname\e[0m"
hostnamectl set-hostname mysql

# Disable the default mysql version
echo -e "\e[33mDisable the default mysql version\e[0m"
dnf module disable mysql -y &>> /tmp/roboshop.log

#create the repo file
echo -e "\e[33mcreate the repo file\e[0m"
cp /home/centos/learn-shell/mysql.repo /etc/yum.repos.d/

#Install the mysql server
echo -e "\e[33mInstall the mysql server\e[0m"
dnf install mysql-community-server -y &>> /tmp/roboshop.log

#enable the mysql
echo -e "\e[33menable the mysql\e[0m"
systemctl enable mysqld &>> /tmp/roboshop.log

#restart the mysql
echo -e "\e[33mrestart the mysql\e[0m"
systemctl restart mysqld  &>> /tmp/roboshop.log

#change the default password
echo -e "\e[33mchange the default password\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1

