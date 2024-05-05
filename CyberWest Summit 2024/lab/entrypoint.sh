#!/bin/bash

users="/tmp/users"
make_email() {
    local username="$1"
    echo "${username}@securesales.com"
}

clients="/tmp/clients"

# pam
while IFS=: read -r username password; do
  useradd -m -s /bin/bash "$username"
  echo "$username:$password" | chpasswd
done < "$users"

# ssh, ensure alicia exists
mkdir -p /home/alicia/.ssh
chown alicia:alicia /home/alicia/.ssh
su alicia -c "ssh-keygen -t rsa -b 4096 -C \"alicia@securesales.com\" -f /home/alicia/.ssh/id_rsa -N \"\""
su alicia -c "cat /home/alicia/.ssh/id_rsa.pub >> /home/alicia/.ssh/authorized_keys"
chmod 711 -R /home/alicia/
chmod 777 /home/alicia/.ssh/id_rsa

# mariadb, AAAAAAAAAAAAA
#/usr/sbin/mysqld --defaults-file=/etc/mysql/my.cnf > /dev/null 2>&1 &
service mariadb start

# OPENCATS
mysql -u root -e "CREATE USER cats@localhost IDENTIFIED BY '0p3nc4tz1';"
mysql -u root -e "CREATE DATABASE cats_dev;"
mysql -u root -e "GRANT ALL PRIVILEGES ON cats_dev.* TO cats@localhost IDENTIFIED BY '0p3nc4tz1';"
# see config.php
rm -rf /var/www/cats/INSTALL_BLOCK #sometimes fails

service apache2 start
# to do: automate opencats installer

# OPENCATS

#chmod 777 -R /opt
#echo "* * * * * shane /bin/bash /opt/dev/update.sh" >> /tmp/cron
#root@demo:~# crontab /tmp/cron
# cron

mariadb -u root -e "CREATE DATABASE securesales;"
mariadb -u root -D securesales -e "CREATE TABLE users (user_id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(50) NOT NULL, email VARCHAR(100) NOT NULL, password VARCHAR(100) NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);"
mariadb -u root -D securesales -e "CREATE TABLE newsletters (email_id INT AUTO_INCREMENT PRIMARY KEY, email VARCHAR(100) NOT NULL, subscribed BOOLEAN NOT NULL);"
mariadb -u root -D securesales -e "CREATE TABLE clients (id INT PRIMARY KEY AUTO_INCREMENT, company_name VARCHAR(255) NOT NULL, contact VARCHAR(100), email VARCHAR(255), employees INT, revenue DECIMAL(15, 2), hash VARCHAR(255) NOT NULL);"

# actual database lol
while IFS=: read -r username password; do
    email=$(make_email "$username")
    mariadb -u root -D securesales -e "INSERT INTO users (username, email, password) VALUES ('$username', '$email', 'changeme');"
done < "$users"

while IFS=: read -r username password; do
    email=$(make_email "$username")
    mariadb -u root -D securesales -e "INSERT INTO newsletters (email, subscribed) VALUES ('$email', true);"
done < "$users"

while IFS=: read -r company_name contact email employees revenue hash; do
    mariadb -u root -D securesales -e "INSERT INTO clients (company_name, contact, email, employees, revenue, hash) VALUES ('$company_name', '$contact', '$email', '$employees', '$revenue', '$hash');"
done < "$clients"

# shane
mariadb -u root -D securesales -e "DELETE FROM users WHERE username = 'shane';"
mariadb -u root -D securesales -e "INSERT INTO users (username, email, password) VALUES ('shane', 'shane@securesales.com', 'dblover98');"

mariadb -u root -D mysql -e "CREATE USER 'shane'@'%' IDENTIFIED BY 'dblover98';"
mariadb -u root -D mysql -e "GRANT CREATE USER ON *.* TO 'shane'@'%';"
mariadb -u root -D mysql -e "GRANT ALL PRIVILEGES ON securesales.* TO 'shane'@'%';"
mariadb -u root -D mysql -e "GRANT ALL PRIVILEGES ON *.securesales.* TO 'shane'@'%';"

# lock it up
mariadb -u root -D mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'v3rys3cure1\!';"

# cleanup
service mariadb stop
servie apache2 stop
rm "$users"
rm "$clients"

yes | unminimize

# processes above must exit
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
