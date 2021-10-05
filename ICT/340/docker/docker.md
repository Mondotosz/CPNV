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
      - `docker inspect -f '{{json .NetworkSettings.Networks}}' 741d84b91210`   
      - `docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' 741d84b91210` => `172.17.0.2`
    - Docker assigne une adresse privée à chaque container et lui donne accès au reste de l'internet au travers d'une passerelle qui est l'interface virtuelle docker de l'hôte. Trouvez la passerelle par défaut de votre container avec la commande route ou netstat -r. Vérifiez que c'est bien une des interfaces de la machine hôte Debian (quel est son nom ?).
      Nous allons maintenant arrêter notre container. Il suffit de faire un exit dans le container ou un docker stop ubuntu depuis l'hôte debian.
7. Redémarrer en tapant : docker start ubuntu. Vérifiez que le container est actif. Il faut se connecter au container. Il suffit de le faire avec la commande docker attach ubuntu
8. Nous allons maintenant supprimer notre container. Cela se fait avec la commande 'docker rm ubuntu`. Cela n'est possible que si le container est arrêté !
