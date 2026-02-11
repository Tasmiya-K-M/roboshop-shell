source common.sh
component=cart

echo -e "${color}setting the hostname${nocolor}"
hostnamectl set-hostname ${component}

# disable the default nodejs
echo -e "${color}disable the default nodejs${nocolor}"
dnf module disable nodejs -y &>> ${log_file}

# enable the nodejs 18
echo -e "${color}enable the nodejs 18${nocolor}"
dnf module enable nodejs:18 -y &>> ${log_file}

# install nodejs
echo -e "${color}install nodejs${nocolor}"
dnf install nodejs -y &>> ${log_file}

# create the user
echo -e "${color}create the user${nocolor}"
useradd roboshop &>> ${log_file}

# create the app dir
echo -e "${color}create the app dir${nocolor}"
mkdir ${app_path} 

# download the app code
echo -e "${color}download the app code${nocolor}"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>> ${log_file}

# unzip the app code in app folder
echo -e "${color}unzip the app code in app folder${nocolor}"
cd ${app_path} 
unzip /tmp/${component}.zip &>> ${log_file}

# install the dependencies
echo -e "${color}install the dependencies${nocolor}"
npm install &>> ${log_file}

# created cart service file
echo -e "${color}created ${component} service file${nocolor}"
cp /home/centos/roboshop-shell/${component}.service /etc/systemd/system/

# load the service
echo -e "${color}load the ${component} service${nocolor}"
systemctl daemon-reload

# enable the service
echo -e "${color}enable the ${component} service${nocolor}"
systemctl enable ${component} &>> ${log_file}

# restart the service
echo -e "${color}restart the ${component} service${nocolor}"
systemctl restart ${component}