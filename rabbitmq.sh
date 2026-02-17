echo -e "\e[33msetting the hostname\e[0m"
hostnamectl set-hostname rabbitmq

#install erlang
echo -e "\e[33minstall erlang\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> /tmp/roboshop.log

#install repo
echo -e "\e[33minstall repo\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> /tmp/roboshop.log

#install rabbitmq
echo -e "\e[33minstall rabbitmq\e[0m"
dnf install rabbitmq-server -y  &>> /tmp/roboshop.log

#enable and restart service
echo -e "\e[33menable and restart service\e[0m"
systemctl enable rabbitmq-server &>> /tmp/roboshop.log
systemctl restart rabbitmq-server &>> /tmp/roboshop.log

#add rmq user
echo -e "\e[33madd rmq user\e[0m"
rabbitmqctl add_user roboshop $1 &>> /tmp/roboshop.log

#set the permissions
echo -e "\e[33mset the permissions\e[0m"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> /tmp/roboshop.log