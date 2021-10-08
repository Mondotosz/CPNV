# Docker

## 1. Configuration d'un hôte Docker et premiers containers

### debian

-   Creation d'une vm debian
-   ```
    sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyring/docker-archive/keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io
    sudo apt-cache madison docker-ce
    sudo apt install docker-ce=5:19.03.15~3-0~debian-stretch docker-ce-cli=5:19.03.15~3-0~debian-stretch containerd.io
    ```

### windows

-   install wsl 2
    -   `wsl --install`
    -   reboot

### test fonctionnel

`sudo docker run hello-world`

### installation de l'image ubuntu

`sudo docker pull debian`
`sudo docker images`

## 2. Premier container

1. Démarrons notre premier containers ubuntu. docker run ubuntu. Que se passe-t-il ?
    ```bash
    docker run ubuntu
    # aucun output
    ```
2. Un container ne reste en vie que si un processus est actif. On peut lister les containers actifs avec la commande docker ps. On peut aussi lister tous les containers, actifs ou inactifs avec docker ps -a. Que vous retourne ces commandes et pourquoi ?
   `docker ps -a`
   | CONTAINER ID | IMAGE  | COMMAND | CREATED        | STATUS                    | PORTS | NAMES                 |
   | ------------ | ------ | ------- | -------------- | ------------------------- | ----- | --------------------- |
   | d4c374611d9c | ubuntu | "bash"  | 43 seconds ago | Exited (0) 41 seconds ago |       | intelligent_blackburn |
3. Nous allons maintenant rediriger l'entrée standard du container avec l'option `-i` et ouvrir un pseudo-terminal avec `-t`, le tout en exécutant le processus `/bin/bash` : `docker run -ti --name=ubuntu ubuntu /bin/bash` Quelle est la version d'ubuntu du container (tapez cat /etc/lsb-release) ?
    ```bash
    docker run -ti --name=ubuntu ubuntu /bin/bash
    root@741d84b91210:/# cat /etc/lsb-release
    DISTRIB_ID=Ubuntu
    DISTRIB_RELEASE=20.04
    DISTRIB_CODENAME=focal
    DISTRIB_DESCRIPTION="Ubuntu 20.04.3 LTS"
    ```
4. Ouvrez un second terminal. Listez les containers actifs ? Combien y en a-t-il ?
   `docker ps`
    | CONTAINER ID | IMAGE  | COMMAND     | CREATED       | STATUS       | PORTS | NAMES  |
    | ------------ | ------ | ----------- | ------------- | ------------ | ----- | ------ |
    | 741d84b91210 | ubuntu | "/bin/bash" | 7 minutes ago | Up 7 minutes |       | ubuntu |
5. Le principe d'un container est qu'il ressemble à une VM vu de l'intérieur, mais qu'il est un ensemble de processus vus de l'extérieur. L'extérieur ici, c'est la machine hôte Debian. Placez vous dans votre second terminal (celui de l'hôte). Quel est le namespace id de votre container ? Vérifiez que vous voyez tous les processus de votre container en les listant également dans le container avec la commande top.
6. De la même manière, un container obtient des interfaces réseaux qui sont privées, et séparées de la machine hôte.
    - Listez les interfaces réseaux de votre container. Quelle est l'adresse IP de votre container ?
      - `docker inspect -f '{{json .NetworkSettings.Networks}}' 741d84b91210`  ou `ip -brief a => eth0@if11        UP             172.17.0.2/16` 
      - `docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' 741d84b91210` => `172.17.0.2`
    - Docker assigne une adresse privée à chaque container et lui donne accès au reste de l'internet au travers d'une passerelle qui est l'interface virtuelle docker de l'hôte. Trouvez la passerelle par défaut de votre container avec la commande route ou netstat -r. Vérifiez que c'est bien une des interfaces de la machine hôte Debian (quel est son nom ?).`ip route => default via 172.17.0.1 dev eth0`
      Nous allons maintenant arrêter notre container. Il suffit de faire un exit dans le container ou un docker stop ubuntu depuis l'hôte debian.
7. Redémarrer en tapant : `docker start ubuntu`. Vérifiez que le container est actif. Il faut se connecter au container. Il suffit de le faire avec la commande `docker attach ubuntu`
8. Nous allons maintenant supprimer notre container. Cela se fait avec la commande 'docker rm ubuntu`. Cela n'est possible que si le container est arrêté ! `docker stop ubuntu` => `docker rm ubuntu`


## 3. Gestion des containers
1. Nous allons redémarrer un autre container basée sur l'image ubuntu avec un nom différent pour changer : `docker run -ti --name=bob ubuntu /bin/bash`

2. On peut inspecter ce qui se passe dans le container depuis la machine hôte avec la commande `docker logs bob` ou mieux encore `docker logs -f bob` qui est (un peu) l'équivalent du `tail -f /var/log/syslog` que l'on ferait sur la machine hôte. On peut d'ailleurs exécuter cette commande pour voir le démon docker qui reporte les manipulations que vous exécutées (démarrage, arrêt de containers, etc.). Faites le test en faisant un ps dans le container et en ayant le logs ouvert en continue depuis l'hôte. Puis faites un top dans le container.

3. Si on veut surveiller efficacement un container, il faut non seulement lire ses logs, mais également avoir une information temporelle avec l'option t : `docker logs -ft bob`

4. Docker fournit aussi des statistiques sur l'usage des ressources CPU/mémoire/réseau des containers : `docker stats bob`. Pour que cela soit intéressant, il faut que le container soit actif. Lancez la commande yes et vérifiez les statistiques.
   | CONTAINER ID | NAME | CPU % | MEM USAGE / LIMIT   | MEM % | NET I/O   | BLOCK I/O | PIDS |
   | ------------ | ---- | ----- | ------------------- | ----- | --------- | --------- | ---- |
   | a0a613032a65 | bob  | 0.00% | 1.078MiB / 7.704GiB | 0.01% | 866B / 0B | 0B / 0B   | 2    |


## 4. Gestion des images
1. Commençons par lister les images disponibles : `docker images`.

2. Pour ajouter une image localement, il suffit de faire un simple `docker pull xxx`. Allez sur le hub docker et cherchez une image `Apache officielle` (aussi connu sous le nom `httpd`) puis téléchargez la.

3. Nous allons maintenant créer notre propre image qui va nous permettre de lancer un serveur Web apache. Pour cela, il faut définir la méthode de construction du container dans un fichier.

   - Créez un répertoire `~/Docker/Apache`
   - Dans ce répertoire, créez un fichier Dockerfile. Dans ce fichier, mettez les commandes :

   FROM ubuntu:latest 
     MAINTAINER votre_nom
     RUN apt -yqq update && apt install -yqq apache2 

   WORKDIR /var/www/html

   ENV APACHE_RUN_USER www-data
   ENV APACHE_RUN_GROUP www-data
   ENV APACHE_LOG_DIR /var/log/apache2
   ENV APACHE_PID_FILE /var/run/apache2.pid
   ENV APACHE_RUN_DIR /var/run/apache2
   ENV APACHE_LOCK_DIR /var/lock/apache2

   RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR

   ENTRYPOINT [ "/usr/sbin/apache2" ]
   CMD ["-D", "FOREGROUND"]
   EXPOSE 80
   - Créons l'image `sudo docker build -t="votre_nom/apache" .` Attention à ne pas oublier le point à la fin de la commande qui indique que le fichier Dockerfile est dans le répertoire local. Le nom du container est nécessairement votre_nom/apache et non apache car apache serait interprété comme un répertoire officiel

   - Listez vos images : `docker images`