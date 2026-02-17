source common.sh

echo -e "${color}setting the hostname${nocolor}"
hostnamectl set-hostname rabbitmq
stat_check $?

#install erlang
echo -e "${color}install erlang${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> ${log_file}
stat_check $?

#install repo
echo -e "${color}install repo${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> ${log_file}
stat_check $?

#install rabbitmq
echo -e "${color}install rabbitmq${nocolor}"
dnf install rabbitmq-server -y  &>> ${log_file}
stat_check $?

#enable and restart service
echo -e "${color}enable and restart service${nocolor}"
systemctl enable rabbitmq-server &>> ${log_file}
systemctl restart rabbitmq-server &>> ${log_file}
stat_check $?

#add rmq user
echo -e "${color}add rmq user${nocolor}"
rabbitmqctl add_user roboshop $1 &>> ${log_file}
stat_check $?

#set the permissions
echo -e "${color}set the permissions${nocolor}"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> ${log_file}
stat_check $?