echo -e "\e[33msetting the hostname\e[0m"
hostnamectl set-hostname mongodb

echo -e "\e[33mSetuping the MongoDB repo file\e[0m"
cp  mongo.repo /etc/yum.repos.d/ &>> /tmp/roboshop.log

echo -e "\e[33mInstalling MongoDB\e[0m"
dnf install mongodb-org -y &>> /tmp/roboshop.log

echo -e "\e[33mEnabling MongoDB\e[0m"
systemctl enable mongod &>> /tmp/roboshop.log

echo -e "\e[33mUpdating listen address\e[0m"
sed -i  "s/127.0.0.1/0.0.0.0/" /etc/mongod.conf 

echo -e "\e[33mRestarting MongoDB\e[0m"
systemctl restart mongod &>> /tmp/roboshop.log
