#!/bin/bash

main() {
    if read -p "Update system? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
        update_os
    fi

    if read -p "Secure apache? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
        secure_apache
    fi

    if read -p "Secure php? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
        secure_php
    fi

    if read -p "Secure mysql? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
        secure_mysql
    fi

    if read -p "Secure php code? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
        secure_php_code
    fi

    if read -p "Secure network ? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
        secure_network
    fi
}

update_os() {
    echo "Current Version : $(cat /etc/debian_version)"

    echo "updating source list"
    echo "$(sed -E 's/cdn(.debian.)net/archive\1org/g' /etc/apt/sources.list)" >/etc/apt/sources.list
    echo "$(sed 's/squeeze-updates/squeeze-lts/g' /etc/apt/sources.list)" >/etc/apt/sources.list
    echo "sources updated"

    echo "running update"
    yes | apt-get update >/dev/null
    yes | apt-get upgrade
    echo "finished update"

    echo "Current Version : $(cat /etc/debian_version)"
}

secure_apache() {
    echo "Securing apache"

    chmod 755 /var/www/admin/uploads/
    echo "Fixed permissions for uploads"

    sed -i 's/Options Indexes FollowSymLinks MultiViews/Options FollowSymLinks MultiViews/' /etc/apache2/sites-available/default
    service apache2 restart >/dev/null
    echo "Removed directory indexing"

}

secure_php() {
    echo "Securing php"

    sed -E -i "s/(error_reporting = E_ALL & ~E_DEPRECATED)/;\1/" /etc/php5/apache2/php.ini
    sed -E -i "s/(display_errors = )On/;\1Off/" /etc/php5/apache2/php.ini
    echo "Hid error messages"

    sed -E -i "s/(disable_functions =)/\1 exec,system,shell_exec/" /etc/php5/apache2/php.ini
    service apache2 restart >/dev/null
    echo "Disabled system functions"
}

secure_mysql() {
    echo "Securing database"

    read -p "New DB password : " dbPassword
    read -p "New photoblog admin password : " pbPassword
    mysql -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$dbPassword'); SET PASSWORD FOR 'root'@'bob' = PASSWORD('$dbPassword'); SET PASSWORD FOR 'root'@'127.0.0.1' = PASSWORD('$dbPassword');USE photoblog;UPDATE users SET password = MD5('$pbPassword') WHERE login LIKE 'admin';"
    echo "updated passwords"
}

secure_php_code() {
    echo "Securing php code"
    sed -i -E "s/(echo mysql_error\(\))/\/\/\1/g;" /var/www/classes/picture.php
    sed -i -E "s/(echo mysql_error\(\))/\/\/\1/g;" /var/www/classes/user.php

    sed -i '14i$cat = (int) $cat;' /var/www/classes/picture.php
}

secure_network(){
    echo "Securing network"
    iptables -F
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT;
    iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT;
    iptables -I INPUT -p tcp --dport 22 -j ACCEPT;
    iptables -I INPUT -p tcp --dport 80 -j ACCEPT;
    iptables -I OUTPUT -p tcp --dport 80 -j ACCEPT;
    iptables -I OUTPUT -p tcp --dport 443 -j ACCEPT;
    iptables -I OUTPUT -p tcp --dport 53 -j ACCEPT;
    iptables -I OUTPUT -p udp --dport 53 -j ACCEPT;
    iptables -P INPUT DROP;
    iptables -P OUTPUT DROP;
    iptables -P FORWARD DROP;

    yes | apt-get install fail2ban > /dev/null
}

main
