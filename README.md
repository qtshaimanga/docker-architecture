# Docker images for dev environment
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
Docker on Windows is only available for Windows 10 **PRO** and Microsoft Hyper-V. If it's your case, just download and install 
Docker for Windows.
To use Docker on other Windows version (Family...), you'll need to setup a virtual machine that will hosts a Linux OS and get Docker 
working inside. 
Use [Boot2Docker](http://boot2docker.io/) or (more recommended) Docker-Toolbox which installs everything needed to get Docker running 
in development. [Download and install Docker-Toolbox] (https://www.docker.com/products/docker-toolbox) 

Docker-Toolbox installs **VirtualBox**, creates a VM and provides an API to communicate with it through ```docker-machine``` commands
It also provides a pre-configured shell to run Docker commands,  **Docker Quickstart Terminal**. 
([Check here](https://github.com/tiangolo/babun-docker) if you want to use Babun/Cygwin).
Finally, Docker-Compose allows to define and run multi-container Docker applications.

### On Mac
...

## Run Docker container
### Clone this repository
```shell
git clone https://github.com/LaboratoireAIR/poc-docker-infra-dev.git
```
You'll end up with a folder where each subfolders represent a Docker application : lamp, mern, nodejs...

### Configure environment variables
Some applications might have environment variables that needs to be edited before running the container. These variables are located in 
.env.dist file (".dist" extension for versioning purpose). 
Make a copy of this file and rename it to ".env". Open your favorite editor, modify these variables and save your .env file.  

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
If you started the lamp stack, you should be able to access your server by typing the ip address 
of the virtual machine in a browser. By default : 192.168.99.100. To get the ip address, type : 
```shell
doker-machine ip
```

### Rebuild Docker container
You might need to rebuild a container, after an update of the docker-compose.yml file or of the Dockerfile
```shell
docker-compose build
```
