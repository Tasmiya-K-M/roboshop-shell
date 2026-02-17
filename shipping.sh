source common.sh
component=shipping
mysql_client_password=$1

if [ -z "$mysql_client_password" ]; then
    echo mysql_client_password value is missing
    exit 1
fi

maven