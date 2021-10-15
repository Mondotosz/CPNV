#!/bin/bash

update_os(){
    echo "Current Version : $(cat /etc/debian_version)"

    echo "updating source list"
    echo "$(sed -E 's/cdn(.debian.)net/archive\1org/g' /etc/apt/sources.list)" > /etc/apt/sources.list
    echo "$(sed 's/squeeze-updates/squeeze-lts/g' /etc/apt/sources.list)" > /etc/apt/sources.list
    echo "sources updated"

    echo "running update"
    yes | apt-get update
    yes | apt-get upgrade
    echo "finished update"

    echo "Current Version : $(cat /etc/debian_version)"
}

secure_apache() {
    echo "Securing apache"

    chmod 755 /var/www/admin/uploads/
    echo "Fixed permissions for uploads"

    sed -i 's/Options Indexes FollowSymLinks MultiViews/Options FollowSymLinks MultiViews/' /etc/apache2/sites-available/default
    service apache2 restart
    echo "Removed directory indexing"

}

read -p "Update system ? (Y/n) :" yn
if ((-z $yn || $yn == "y" || $yn == "Y")); then
    update_os
fi

read -p "Secure apache ? (Y/n) :" yn
if  ((-z $yn || $yn == "y" || $yn == "Y")); then
    secure_apache
fi
