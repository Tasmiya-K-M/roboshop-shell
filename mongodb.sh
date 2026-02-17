source common.sh

echo -e "${color}setting the hostname${nocolor}"
hostnamectl set-hostname mongodb 
stat_check $?

echo -e "${color}Setuping the MongoDB repo file${nocolor}"
cp  /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/ &>> ${log_file}
stat_check $?

echo -e "${color}Installing MongoDB${nocolor}"
dnf install mongodb-org -y &>> ${log_file}
stat_check $?

echo -e "${color}Enabling MongoDB${nocolor}"
systemctl enable mongod &>> ${log_file}
stat_check $?

echo -e "${color}Updating listen address${nocolor}"
sed -i  "s/127.0.0.1/0.0.0.0/" /etc/mongod.conf 
stat_check $?

echo -e "${color}Restarting MongoDB${nocolor}"
systemctl restart mongod &>> ${log_file}
stat_check $?