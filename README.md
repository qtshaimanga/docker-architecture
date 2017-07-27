# Docker environment
This repository provides docker images to setup with ease developments environments.
To deploy and run it, you will need Docker and Docker Compose. Follow the instructions below, depending on your OS.

As of 02-06-2017, here is the list of all available container :
- i2r-dev-apache
- i2r-dev-mariadb
- i2r-dev-pma (PhpMyAdmin)
- i2r-dev-node
- i2r-dev-nginx-proxy
- i2r-dev-mongo
- i2r-dev-mongo-webadmin (Webtool for MongoDB)


> docker exec -i containername

> docker-compose up -d
> docker-compose restart
> docker-compose down

>pm2 start projectpath

> create files
> set .env
