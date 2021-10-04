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

- install wsl 2
  - `wsl --install`
  - reboot

### test fonctionnel

`sudo docker run hello-world`

### installation de l'image ubuntu

`sudo docker pull debian`
`sudo docker images`

## 2. Premier container