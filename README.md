# I2R Docker environment
This repository provides docker images to setup with ease development environments needed for developing the I2R projects.
To deploy and run it, you will need Docker and Docker Compose. Follow the instructions below, depending on your OS.

## Basic Elements
###### 1. Check server informations about users and access

###### 2. Install Docker and Docker-compose
- sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
- curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
- sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
- sudo apt-get update
- sudo apt-get install docker-ce
- apt-cache madison docker-ce
        - sudo docker run hello-world
        - sudo docker run armhf/hello-world
- sudo -i curl -L https://github.com/docker/compose/releases/download/$dockerComposeVersion/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
- sudo chmod +x /usr/local/bin/docker-compose
- docker-compose --version


###### 3. Install Git
- sudo apt-get install git

###### 4. Install Letsencrypt
- sudo git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt --depth=1

###### 5. Docker-env
- git clone https://github.com/laboratoirei2r/docker-i2r-env.git

###### 6. If it is necessary Create network manually
- docker network create men_default

## Docker-env Architecture
###### LAMP
 - service-apache
 - service-mariadb
 - service-pma (PhpMyAdmin)

###### MEN
 - service-node
 - service-mongo
 - service-mongo-webadmin (Webtool for MongoDB)

###### Create or set subfolder for building
 - ./apache-php7/var/www/html
 - ./apache-php7/sites-enabled
 - ./apache-php7/fail2ban/jail.local
 - ./apache-php7/iptables/firewall.sh
 - ./apache-php7/letsencrypt/ssl-renewal.sh
 - ./mariadb/shared

###### Set .env (default)
 - DEV_PROJECT_PATH=./apache-php7/var/www/html
 - DEV_VHOST_PATH=./apache-php7/sites-enabled
 - MYSQL_DATA_PATH=./mariadb/shared
 - MYSQL_ROOT_PASSWORD=XXX
 - LETSENCRYPT_PATH=/etc/letsencrypt
 - LETSENCRYPT_LIB=/var/lib/letsencrypt

## Quick installation
#### 1. Use Docker:
###### Start
````bash
docker-compose build
docker-compose up -d
docker-compose restart
````

###### Restart
````bash
docker-compose down
docker-compose restart
````

###### Manage
````bash
docker images
docker ps
````

#### 2. Create a project clone

#### 3. If is Node.js, start your project
````bash
docker exec -i service-node bash
pm2 start projectpath
````

#### 4. Generate letsencrypt files in local
````bash
sudo /opt/letsencrypt/letsencrypt-auto --apache -d mondomaine.fr
````

#### 5. Set Vhost

## More informations
#### Auto renew for letsencrypt certificats
Crontab based on ssl-renewal.sh, is he defined to exec
````bash
sudo crontab -e 0 0 1 * 1 /usr/local/sbin/ssl-renewal mondomaine.fr --post-hook "service apache2 restart" >> ~/var/log/ssl-renewal.log
````

#### Start/Restart Apache
````bash
docker exec -i service-apache bash
service apache2 restart
````

#### Add an ssh authorized key
````bash
ssh-copy-id -i ~/.ssh/id_rsa.pub $utilisateur_distant@$hôte_distant
````

#### Autodeploy next project release with Capistrano
````bash
cap production:deploy
````
