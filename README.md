# I2R Docker environment
This repository provides docker images to setup with ease development environments needed for developing the I2R projects.
To deploy and run it, you will need Docker and Docker Compose. Follow the instructions below, depending on your OS.

## Installing Docker
### On Linux
Docker works natively on Linux, as it shares the Kernel of the host and only creates namespaces to get containers working isolated.
To install Docker on Linux, you will need to add the docker repository to your package manager and install some packages that 
might be required (curl, https...)

Select your Linux version and follow the instructions on this page : 
https://www.docker.com/community-edition

### On Windows
Docker on Windows is only available for Windows 10 **PRO** and Microsoft Hyper-V. 
To use Docker on other Windows version (Home, Family...), you'll need to setup a virtual machine that will hosts a Linux OS and get Docker 
working inside. 
Use [Boot2Docker](http://boot2docker.io/) or Docker-Toolbox (more recommended) which installs everything needed to get Docker running 
in development. [Download and install Docker-Toolbox](https://www.docker.com/products/docker-toolbox) 

Docker-Toolbox installs **VirtualBox**, creates a VM and provides an API to communicate with it through ```docker-machine``` commands
It also provides a pre-configured shell to run Docker commands,  **Docker Quickstart Terminal**. 
([Check here](https://github.com/tiangolo/babun-docker) if you want to use Babun/Cygwin).
Finally, Docker-Compose allows to define and run multi-container Docker applications.

## Run Docker container
### Clone this repository
```shell
git clone https://github.com/LaboratoireAIR/poc-docker-infra-dev.git
```
You'll end up with a folder where each subfolders represent a Docker stack : lamp, men...

As of 02-06-2017, here is the list of all available container : 
- i2r-dev-apache
- i2r-dev-mariadb
- i2r-dev-pma (PhpMyAdmin)
- i2r-dev-node
- i2r-dev-nginx-proxy
- i2r-dev-mongo
- i2r-dev-mongo-webadmin (Webtool for MongoDB)

### Set environment variables
Some applications might have environment variables that needs to be edited before running the container. These variables are located in 
.env.dist file (".dist" extension for versioning purpose). 
Make a copy of this file and rename it to ".env". Open your favorite editor, modify these variables and save your .env file. 

For the moment, each docker stack needs its own .env file (eg: lamp/.env, men/.env)

### Run Docker container
Open your favorite shell and browse into the folder of the container you want to run. 
```shell
cd lamp
```

Ensure you have the docker-compose.yml in the directory, then run docker-compose up : 
```shell
docker-compose up
```

This will build and start containers specified in the docker-compose.yml. 
If you started the lamp stack, you should be able to access your server by typing the ip address of the virtual machine in a browser. By default : `http://192.168.99.100`. To get the ip address, type : 
```shell
docker-machine ip
```
**For Docker Windows users** : as there is no layer between Windows and Docker containers, you can directly use standard local addresses : `http://127.0.0.1` or `http://localhost`, as well as you local ip or docker NAT ip. `ipconfig /all` to display them all.

## Playing with the containers

To execute instructions inside a running container, use the `exec` command : 

```
docker exec -ti <container_name> <command>
```

One of the common use of `exec` is to attach a container and get into its shell : 

```
docker exec -ti i2r-dev-node bin/bash
```

You will jump instantly into the shell of the i2r-dev-node container.

Note : if you encounter a message related to an unexistent tty process, remove the -t option : `docker exec -i i2r-dev-node bash`

### Start/Stop container
To start, restart or stop a single container, use docker `start`, `restart` or `stop` : 
```
docker stop i2r-dev-apache
```

You can also proceed on a whole stack, as long as you are in a docker-compose folder : 
```
# Stop all services defined in the current docker-compose.yml 
docker-compose down
# Restart all services
docker-compose up 
```

### Rebuild Docker container
You might need to rebuild a container, after an update of the docker-compose.yml file or of the Dockerfile
```shell
docker-compose build
```

# Deploy a PHP application locally
To deploy a PHP application (Symfony) on your computer, go to the path specified in your `DEV_PROJECT_PATH` variable (lamp/.env) . Once in it, clone the wished repository :

```
git clone https://github.com/teami2r/php-project-repo.git
```

You might then want to access to the application using a proper URL and thus need to setup a virtual host. Follow the instructions in the Apache - Configuring Virtual Hosts part. Don't forget to set your local `hosts` file, eg : 

```
# Redirect to the ip address of your docker machine
192.168.99.100 api-toto.air-edf.io
192.168.99.100 api-tata.air-edf.io
```

## Apache
### Configuring Virtual Hosts
A folder located at lamp/apache-php7/site-enabled is shared with the Apache container and allows you to manage virtual hosts as if it was on the server. Just add, remove and configure vhosts at your convenience. 
eg : 
```
<VirtualHost *:80>
        ServerName api-toto.air-edf.io
        DocumentRoot /var/www/html/api-toto

        <Directory "/var/www/html/api-toto">
            Options +FollowSymlinks +Indexes
            AllowOverride all
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/api-toto/error.log
        CustomLog ${APACHE_LOG_DIR}/api-toto/access.log combined
</VirtualHost>

```
Don't forget to jump into the container and do a ``service apache2 reload``.

You can also restart the container by doing a ``docker restart i2r-dev-apache``

## MariaDB

Data are persisted in the directory specified in the `MYSQL_DATA_PATH` variable in lamp/.env file.

When configuring the database for your web application, you can set the hostname to "i2r-mariadb". 

## PHPMyAdmin
PhpMyAdmin listens to the port 8080. To get access, go to `http://localhost:8080`. By default, username is "root". Leave the password field empty.

# Deploy a Nodejs application locally
Browse into the path specified in the `NODE_PROJECT_PATH` variable (men/.env). Make the `git clone` of your project 
```
git clone https://github.com/teami2r/node-project-repo.git
```

Common Node Dockerized applications works on a attached active docker principle : each node application has its own Dockerfile which is executed and runs in the end a `npm start`. Our men stack is a passive container that we want to use as an application launcher. This mean we need to connect into the machine to run any Node project. This also means that for each project running in the same time, we need to open different ports in the docker-compose.yml or you will need to stop any active node process listening on the same port.

Connect to the node container : 
```
docker exec -i i2r-dev-node bash
```
Browse into your application folder, and launch it :
```
cd node-project
npm start
``` 

then your application should be available on your local ip and port, eg: `http://localhost:3000`

## Manage applications with PM2
PM2 is a process manager for Node.js applications. It can reload your apps,keep them alive forever and helps your in your system admin tasks. 
PM2 is installed in the `i2r-dev-node` container.
Here are some common commands you can execute with PM2 :
```
pm2 start index.js # Will start, daemonize and auto-restart index.js
pm2 start npm -- start # do this instead of a simple npm start
```
To display current processes : 
```
pm2 list
┌──────────┬────┬──────┬─────┬────────┬─────────┬────────┬─────┬───────────┬──────────┐
│ App name │ id │ mode │ pid │ status │ restart │ uptime │ cpu │ mem       │ watching │
├──────────┼────┼──────┼─────┼────────┼─────────┼────────┼─────┼───────────┼──────────┤
│ npm      │ 0  │ fork │ 50  │ online │ 0       │ 5m     │ 0%  │ 40.9 MB   │ disabled │
└──────────┴────┴──────┴─────┴────────┴─────────┴────────┴─────┴───────────┴──────────┘
```

Many other commands are available to start and stop processes, show logs, deploy etc... check the [official doc](https://www.npmjs.com/package/pm2)

## MongoDB

`mongod` listens to the port **27017**.

In the same principle than MariaDB container, data are persisted in the directory specified in the `MONGO_DATA_PATH` of the .env file (men/.env)

**Warning** : Windows 10 PRO users won't be able to use this volume share principle as there's known uncompatibilities between windows file system and mongod daemon which except a Linux file system (see this [link](https://github.com/bitnami/bitnami-docker-mongodb/issues/20#issuecomment-269773493)). Therefore, data must live inside the container and be exported before any `docker-compose down`

**Update 02/06/2017**: this issue seems to happen to **all users of Docker Toolbox** (Windows & MacOS). [Source](https://hub.docker.com/_/mongo/) 

## MongoDB administration
A web administration tool is available on the `i2r-dev-mongo-webadmin` container. You can access it on [http://localhost:8081](). There's no identification needed. 

## Nginx proxy
The container `i2r-dev-nginx-proxy` is available if a proxy is needed to serve multiple node applications. See the [doc(https://hub.docker.com/r/jwilder/nginx-proxy/)] for more information.

# Troubleshooting
Here are some issues you can encounter, and how to resolve them.

## - Container cannot seem to connect to the Internet
This might occur when you do a `apt-get update` inside a container and have an error message like : 
```
unable to resolve host
```
2 solutions : 
- Prefered : edit the /etc/resolv.conf from the host (docker machine) in order to use external dns : `8.8.8.8` 
- run docker with -dns option : `docker run -dns 8.8.8.8`

Note : this problem might not exist on Docker for Windows.

# Links
## Documentations
[Docker PHP7/Apache image](https://hub.docker.com/_/php/)

[Docker Bitnami MariaDB image](https://github.com/bitnami/bitnami-docker-mariadb)

[Docker PhpMyAdmin image](https://hub.docker.com/r/phpmyadmin/phpmyadmin/)

[Docker Node official image](https://hub.docker.com/r/_/node/)

[Docker MongoDB official image](https://hub.docker.com/_/mongo/)

[Docker jwilder/nginx-proxy image](https://hub.docker.com/r/jwilder/nginx-proxy/)

[PM2 - npmjs doc](https://www.npmjs.com/package/pm2)