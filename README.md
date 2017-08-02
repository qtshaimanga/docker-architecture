# Docker environment

### 1. Available container :

###### LAMP
- service-apache
- service-mariadb
- service-pma (PhpMyAdmin)

###### MEN (networks true)
- service-node
- service-mongo
- service-mongo-webadmin (Webtool for MongoDB)

### 2. Informations:
- create sub folder for buiding
- set .env

````bash
- docker-compose down
- docker-compose build
- docker-compose up -d
- docker-compose restart
````

- Manage vhosts

````bash
- docker exec -i containername bash
- pm2 start projectpath
````


- SSL
 - generate letsencrypt files
````bash
docker run -it --rm -p 443:443 -p 80:80 --name certbot \
            -v "/etc/letsencrypt:/etc/letsencrypt" \
            -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
            certbot/certbot certonly
````
 - write ssl vhosts
 - Update docker-compose with volume_from letsencrypt var/lib and etc/ and add port 80 and 443 add cerbot/cerbot dockerfile for create certificat in container
 - OR add git clone letsencrypt in machine and create certificat
 - https://hub.docker.com/r/certbot/certbot/
 - https://certbot.eff.org/docs/install.html?highlight=docker#running-with-docker
 - https://hub.docker.com/r/lojzik/letsencrypt/


- Cap users: deploy, www-data,


# Security: To verified !
- configuration des accès: déployer, developer
- changer port : /etc/ssh/sshd_config : Port 22
- supprimer root : /etc/ssh/sshd_config : PermitRootLogin no
- Restart conf ssh: /etc/init.d/ssh restart
- ssh key acces (putty-gen or seahorse)
- user generate ssh key : ssh-keygen -t dsa -f ~/.ssh/id_server
- before transfert : chmod -R 0700 ~/.ssh/
- after transfert : chmod -R 0600 ~/.ssh/
- transfert ssh key to server: scp -p portNumber ~/.ssh/id_rsa.pub username@ip:~/.ssh/authorized_keys
  - or ssh-copy-id -i ~/.ssh/id_rsa.pub $utilisateur_distant@$hôte_distant
- donner des droit cohérent au accées
  - ssh user groupe:
    - create : groupadd sshusers
    - add : usermod -a -G sshusers username
  - ssh user :
    - adduser newuser
    - path to root: su - newuser
    - grant user :
      - sudo visudo
        - User privilege specification :
          - root        ALL=(ALL:ALL) ALL
          - newuser    ALL=(ALL:ALL) ALL
        - detele user: deluser --remove-home username
  - change password : passwd username
- /etc/ssh/sshd_config :
 - change this :
    - add: HostKey /etc/ssh/ssh_host_dsa_key
    - change time who user can logged : LoginGraceTime 20s
    - number of erros possible : MaxAuthTries 1
    - PubkeyAuthentication yes
    - AuthorizedKeysFile .ssh/authorized_keys
    - RSAAuthentication no
    - UsePAM no
    - KerberosAuthentication no
    - GSSAPIAuthentication no
    - PasswordAuthentication no
    - AllowGroups sshusers
    - MaxStartups 2
- crypte the know_host file (delete old)
    - ssh-keygen -H -f ~/.ssh/known_hosts
- change paswword ssh key : ssh-keygen -p -f ~/.ssh/id_server
- protect about known security flow: openssh-server
- user ssh-agent for cached ssh key :
    - add : ssh-add ~/.ssh/id_rsa.pub  (ssh -T git@github.com)
    - list : ss-add -l
    - delete : ssh-add -D
- remote control : ssh $remote_user@$remote_host '$cmd'
- iptables:
    - apt-get install iptables
    - list of rules : iptables -L (defaut = acceptation)
    - nb:sudo iptables -P INPUT DROP (down all connection)
    - script sh:
      - sudo nano firewall.sh
        - [ list all programs used in current] netstate --net -npl
        - execute scipt at the start  :
          - move to /etc/init.d
          - sudo chmod +x firewall
          - sudo update-rc.d firewall
- uncomplicated firewall ufw (managing iptables):
  - iptables -t filter -F
  - iptables -t filter -X
  - apt-get install ufw
  - sudo ufw status verbose
  - sudo nano /etc/default/ufw
  - sudo ufw default allow incoming (autorise all ext)
  - [sudo ufw default deny outgoing (bloque all ext)]
  - sudo ufw allow 5789/tcp (adapt the port with the case)
  - [sudo uwf allow 80]
  - [sudo ufw status numbered]
  - [sudo ufw delete $number]
  - sudo ufw app list
  - sudo ufw allo "WWW full"
  - [check : /etc/ufw/webserver]
  - sudo ufw allow from <target_ip> to any port 5786
  - sudo ufw deny from <target_ip> to any port 80
  - sudo ufw reset
  - sudo ufw reload
- fail2ban :
  - apt-get install fail2ban
  - cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
  - sudo nano jail.local
  - conf: email, sender, mt: mail (cf install fo postfixe), action = %(action_mwl)s
  - the jailes: change the ssh port,
  - sudo service fail2ban restart
  - test if filter is used: sudo fail2ban-regex var/log/auth.log /etc/fail2ban/filter.d/sshd.conf
  - sudo fail2ban-client status <jail we should observer>
  - sudo fail2ban-client status
  - sudo fail2ban set ssh unbanip <ip_adress>
  - use predifined apache rules
- postfix :
  - apt-get install postfix
    - mydestination: supprimer email
    - inet_interfaces = loopback-only
  - sudo nano /etc/mailname
  - editeur de conf interactif : sudo dpkg-reconfigure postfix
  - service postfix restart
  - sudo apt-get install mailutils
  - test : echo "test okok " | mail -s "sujet de test " email@gmail.com
  - configuration pour passer les spam :      
    - https://www.grafikart.fr/tutoriels/serveur/email-dns-dkim-spf-551  
  -
