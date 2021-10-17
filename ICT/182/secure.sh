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
}

update_os() {
    echo "Current Version : $(cat /etc/debian_version)"

    echo "updating source list"
    echo "$(sed -E 's/cdn(.debian.)net/archive\1org/g' /etc/apt/sources.list)" >/etc/apt/sources.list
    echo "$(sed 's/squeeze-updates/squeeze-lts/g' /etc/apt/sources.list)" >/etc/apt/sources.list
    echo "sources updated"

    echo "running update"
    yes | apt-get update > /dev/null
    yes | apt-get upgrade > /dev/null
    echo "finished update"

    echo "Current Version : $(cat /etc/debian_version)"
}

secure_apache() {
    echo "Securing apache"

    chmod 755 /var/www/admin/uploads/
    echo "Fixed permissions for uploads"

    sed -i 's/Options Indexes FollowSymLinks MultiViews/Options FollowSymLinks MultiViews/' /etc/apache2/sites-available/default
    service apache2 restart > /dev/null
    echo "Removed directory indexing"

}

secure_php() {
    echo "Securing php"

    sed -E -i "s/(error_reporting = E_ALL & ~E_DEPRECATED)/;\1/" /etc/php5/apache2/php.ini
    sed -E -i "s/(display_errors = )On/;\1Off/" /etc/php5/apache2/php.ini
    service apache2 restart > /dev/null
    echo "Hid error messages"

    sed -E -i "s/(disable_functions =)/\1 exec,system,shell_exec/" /etc/php5/apache2/php.ini
    echo "Disabled system functions"
}

secure_mysql() {
    echo "Securing database"

    read -p "New DB password : " dbPassword
    read -p "New photoblog admin password : " pbPassword
    mysql -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$dbPassword'); SET PASSWORD FOR 'root'@'bob' = PASSWORD('$dbPassword'); SET PASSWORD FOR 'root'@'127.0.0.1' = PASSWORD('$dbPassword');USE photoblog;UPDATE users SET password = MD5('$pbPassword') WHERE login LIKE 'admin';"
    echo "updated passwords"
}

main