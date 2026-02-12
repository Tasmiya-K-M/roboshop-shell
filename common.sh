color="\e[36m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"

app_presetup() {
    echo -e "${color}setting the hostname${nocolor}"
    hostnamectl set-hostname ${component}

    #Add application User
    echo -e "${color}Added the app user${nocolor}"
    useradd roboshop &>> ${log_file}

    #Download the application code 
    echo -e "${color}Download app code${nocolor}"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>> ${log_file}

    #create the app directory
    rm -rf ${app_path}
    mkdir ${app_path}

    #unzip the file
    echo -e "${color}Unzip the file${nocolor}"
    cd ${app_path} 
    unzip /tmp/${component}.zip &>> ${log_file}
}

systemd_setup() {
    #Setup service file
    echo -e "${color}Setting up ${component} Service${nocolor}"
    cp /home/centos/roboshop-shell/${component}.service /etc/systemd/system/

    #Load the service.
    echo -e "${color}Load the ${component} service${nocolor}"
    systemctl daemon-reload

    #enable and restart the service
    echo -e "${color}Enable and restart ${component} service${nocolor}"
    systemctl enable ${component} &>> ${log_file}
    systemctl restart ${component}
}

nodejs() {
    echo -e "${color}Disabling the default nodejs version${nocolor}"
    dnf module disable nodejs -y &>> ${log_file}

    echo -e "${color}Enabling the nodejs 18${nocolor}"
    dnf module enable nodejs:18 -y &>> ${log_file}

    #Install NodeJS
    echo -e "${color}Installing the nodejs 18${nocolor}"
    dnf install nodejs -y &>> ${log_file}

    app_presetup

    #download the dependencies.
    echo -e "${color}Downloading dependencies${nocolor}"
    npm install  &>> ${log_file}

    systemd_setup
}

mongodb-client-setup() {
    #setup MongoDB-Client repo
    echo -e "${color}setup mongodb-client repo${nocolor}"
    cp /home/centos/roboshop-shell/mongo-client.repo /etc/yum.repos.d/

    #Installing mongodb-client
    echo -e "${color}Installing mongodb-client${nocolor}"
    dnf install mongodb-org-shell -y &>> ${log_file}

    #Load the data into mongodb using mongo-client
    echo -e "${color}Load the data into mongodb using mongodb-client${nocolor}"
    mongo --host mongodb-dev.devopspro789.online <${app_path}/schema/${component}.js &>> ${log_file}
}

golang() {
    #install golang
    echo -e "${color}install golang${nocolor}"
    dnf install golang -y &>> ${log_file}

    app_presetup

    #install dependencies
    echo -e "${color}install dependencies${nocolor}"
    go mod init ${component} &>> ${log_file}
    go get &>> ${log_file}
    go build &>> ${log_file}

    #create the service file
    echo -e "${color}create the ${component} service file${nocolor}"
    cp /home/centos/roboshop-shell/${component}.service /etc/systemd/system/${component}.service &>> ${log_file}

    systemd_setup
}

nginx() {
    echo -e "${color}setting the hostname${nocolor}"
    hostnamectl set-hostname ${component}

    echo -e "${color}Installing Nginx Server${nocolor}"
    dnf install nginx -y &>> ${log_file}

    echo -e "${color}Removing Old App content${nocolor}"
    rm -rf /usr/share/nginx/html/* &>> ${log_file}

    echo -e "${color}downloading ${component} Content${nocolor}"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>> ${log_file}

    echo -e "${color}Extracting ${component} Content${nocolor}"
    cd /usr/share/nginx/html 
    unzip /tmp/${component}.zip &>> ${log_file}

    # vim /etc/nginx/default.d/roboshop.conf 
    echo -e "${color}Creating Nginx Reverse Proxy Configuration${nocolor}"
    cp /home/centos/learn-shell/roboshop.conf /etc/nginx/default.d/

    echo -e "${color}Starting Nginx Server${nocolor}"
    systemctl enable nginx &>> ${log_file}
    systemctl restart nginx &>> ${log_file}
}

python() {
    
    #install python
    echo -e "${color}install python${nocolor}"
    dnf install python36 gcc python3-devel -y &>> ${log_file}

    app_presetup

    #install the dependencies
    echo -e "${color}install the dependencies${nocolor}"
    pip3.6 install -r requirements.txt &>> ${log_file}

    systemd_setup
}

mysql-client() {
    #install mysql-client
    echo -e "${color}install mysql-client${nocolor}"
    dnf install mysql -y &>> ${log_file}

    #load the data
    echo -e "${color}load the data${nocolor}"
    mysql -h mysql-dev.devopspro789.online -uroot -pRoboShop@1 < ${app_path}/schema/${component}.sql &>> ${log_file}
}

maven() {

    #Install maven
    echo -e "${color}Install maven${nocolor}"
    dnf install maven -y &>> ${log_file}

    app_presetup

    #install dependencies
    echo -e "${color}install dependencies${nocolor}"
    mvn clean package &>> ${log_file}
    mv target/${component}-1.0.jar ${component}.jar &>> ${log_file}

    systemd_setup

    mysql-client

}


