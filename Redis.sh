source common.sh

#setting up the hostname
echo -e "${color}setting the hostname${nocolor}"
hostnamectl set-hostname redis
stat_check $?

#Enable Redis 6.2 from package streams.
echo -e "${color}enable the redis 6.2 package${nocolor}"
dnf module disable redis -y &>> ${log_file}
dnf module enable redis:6 -y &>> ${log_file}
stat_check $?

#Install Redis
echo -e "${color}install the redis${nocolor}"
dnf install redis -y &>> ${log_file}
stat_check $?

#Edit the config file
echo -e "${color}editing the config file${nocolor}"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf
stat_check $?

#start and enable the redis service
echo -e "${color}enable and restart service${nocolor}"
systemctl enable redis &>> ${log_file} 
systemctl restart redis &>> ${log_file}
stat_check $?