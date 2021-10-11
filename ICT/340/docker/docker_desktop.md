## Installation Oracle et SQLDeveloper avec Docker
Ce Laboratoire a pour but de vous aider à installer Docker et une image Oracle Express.

L’outil Docker desktop associé à Docker permet de gérer l’ensemble des images et de générer des container à la volée. Il permettra également de gérer l’interfaçage entre votre machine, et le container.

(version Docker desktop non buggée : Télécharger) 04.04.2019

Docker : Outil de virtualisation fournissant des images clés en main
Oracle : Image d’un serveur Oracle Express à télécharger sous Docker (Docker desktop)
SQLDeveloper : Logiciel développé par Oracle permettant de se connecter à la base de données Oracle (sous Docker)
Si vous avez Windows 10 Pro ou Education, vous pouvez utiliser Docker nativement. Sinon, il faut installer Docker Toolbox : Docker CE (contenant VirtualBox)

Lancer le programme d’installation, acceptez les chargements supplémentaires (parfois le mot de passe administration est nécessaire) et les déblocages de ports
Lorsque vous lancez Docker desktop, il faut le lancer avec les Droits Administrateurs (click droit -> “lancer avec les droits Admin“)
Il est possible que Docker desktop ne se connecte pas directement, il faut utiliser la version “Virtual Box” (si besoin, supprimer l’image précédemment créée)
Docker peut être installé nativement sous Linux et MacOS.

Créer un contener Oracle avec Docker desktop
L’outil Docker desktop permet d’administrer les images Docker ou conteneur sur votre machine. Son lancement peut prendre du temps au premier lancement car il teste votre connexion réseau pour avoir une adresse IP locale. Attention au démarrage de Docker desktop sous Windows avec les droits administrateurs.

Dans l’interface, vous pouvez chercher n’importe quelle image présente sur le Docker Hub et la créer localement. Nous utiliserons l’image `docker-oracle-xe-11g` réalisée par `oracleinanutshell`. Ainsi, il faut chercher l’image : `oracleinanutshell/docker-oracle-xe-11g`

Une fois téléchargée (quelques minutes en fonction de la connexion), Docker va créer un conteneur et le lancer. Il apparaît dans le menu de gauche. Dans le cadre de ce laboratoire, nous utiliserons ce conteneur. Il faut avant chaque connexion lancer Docker desktop puis de démarrer le conteneur. Une fois démarré, nous pouvons avoir différentes informations sur celui-ci. En l'occurrence, nous nous intéressons aux ports ouverts qui seront utilisés pour Oracle 2 : 32769

Une fois cet environnement installé, Le serveur Oracle tourne et est accessible pour toute application avec pour adresse : localhost :32769. Sous Windows avec Docker Toolbox, une adresse IP dynamique sera allouée et visible sur Docker desktop, il faudra l’utiliser dans le reste du TP à la place de localhost.

SQLDeveloper
Maintenant que nous avons un serveur Oracle en état de fonctionnement, nous pouvons installer `SQLDeveloper`. SQLDeveloper est une solution logicielle Oracle permettant de manipuler la base de données, aussi bien la partie modélisation, que la création d’une base de données, les requêtes, les procédures stockées ou les déclencheurs.

Télécharger l’installateur. Il est disponible sur toutes les systèmes d’exploitation standards. Décompresser le fichier et c’est installer. Idéalement, il faut déplacer le répertoire créé à l’endroit les programmes sont placés (Program Files ou /etc/local). En effet, l’exécutable disponible dans le répertoire SQLDeveloper est un script de lancement d’application Java (une JVM est nécessaire dans votre système exploitation, mais c’est une installation par défaut).

Lancer l’exécutable dans le répertoire “SQLDeveloper”, une fenêtre de progression s’ouvre. Une fois l’interface utilisateur ouverte, il est nécessaire de créer une première connexion.

Nom de connexion : locale (Nom affiché pour la connexion)
Nom de l’utilisateur : system
Mot de passe : oracle
Nom de l’hôte : localhost (remplacer par l’IP allouée par Docker / voir plus haut)
Port : 32769 (peut être différent, vérifier sur Docker desktop)
SID : xe (Identifiant de base oracle par défaut pour Oracle Express)

## POC (proof of concept) - Fin de la semaine 8 du module

```
sudo docker pull mcr.microsoft.com/mssql/server
sudo docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=Pa\$\$w0rd" -p 1433:1433 -d --name=mssql mcr.microsoft.com/mssql/server
```

Contrôle de fonctionnement du container et de la connexion à partir SQL Server Management Studio (SSMS) depuis la machine locale. [4 pts.]