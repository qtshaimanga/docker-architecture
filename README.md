# Docker environment

### 1. Available container :

###### LAMP
- service-apache
- service-mariadb
- service-pma (PhpMyAdmin)

###### MEN (networks true)
- service-node ()
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
