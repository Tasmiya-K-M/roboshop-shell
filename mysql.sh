source common.sh

echo -e "${color}setting the hostname${nocolor}"
hostnamectl set-hostname mysql
stat_check $?

# Disable the default mysql version
echo -e "${color}Disable the default mysql version${nocolor}"
dnf module disable mysql -y &>> ${log_file}
stat_check $?

#create the repo file
echo -e "${color}create the repo file${nocolor}"
cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/
stat_check $?

#Install the mysql server
echo -e "${color}Install the mysql server${nocolor}"
dnf install mysql-community-server -y &>> ${log_file}
stat_check $?

#enable the mysql
echo -e "${color}enable the mysql${nocolor}"
systemctl enable mysqld &>> ${log_file}
stat_check $?

#restart the mysql
echo -e "${color}restart the mysql${nocolor}"
systemctl restart mysqld  &>> ${log_file}
stat_check $?

#change the default password
echo -e "${color}change the default password${nocolor}"
mysql_secure_installation --set-root-pass $1
stat_check $?
