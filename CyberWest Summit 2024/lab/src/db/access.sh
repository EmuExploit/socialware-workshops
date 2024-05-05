#!/bin/bash
# brians sync script to make db users when they change their passwords

while true
do
    mariadb -B -N -u shane --password="dblover98" -D securesales -e "select username, password from users WHERE username NOT LIKE \"shane\" AND password NOT LIKE \"changeme\";" | awk '{print $1 ":" $2}' > /tmp/creds
    creds="/tmp/creds"

    while IFS=: read -r username password; do
        mariadb -u root --password="v3rys3cure1!" -D securesales -e "CREATE USER '$username'@'%' IDENTIFIED BY '$password';"
        mariadb -u root --password="v3rys3cure1!" -D mysql -e "GRANT ALL PRIVILEGES ON securesales.* TO '$username'@'%' WITH GRANT OPTION;"
    done < "$creds"
    sleep 5
done

