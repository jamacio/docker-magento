# Docker - Magento


## Installation

You only need 3 things on your local machine: `git`, `docker` and `make`

### Install Docker

Follow the installation steps for your system.



	
<summary>Linux</summary>
	
1. Install docker

	* Install Docker on [Debian](https://docs.docker.com/engine/installation/linux/docker-ce/debian/)
	* Install Docker on [Ubuntu](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/)
	* Install Docker on [CentOS](https://docs.docker.com/engine/installation/linux/docker-ce/centos/)

2. Install Docker Compose
	*  [Install Compose](https://docs.docker.com/compose/install/)

3. Configure permissions
	
	* [Manage Docker as a non-root user](https://docs.docker.com/install/linux/linux-postinstall/)


## Install Make
Installing the make command on linux
1. ```sh
sudo apt-get update 
```
2. ```sh
sudo apt-get install -y make
```

You can install make by downloading the build-essential package, as follows 
```sh
sudo apt install build-essential
```


## App Install

1. ```sh
git clone git@github.com:jamacio/docker-magento.git
```
2. ```sh
cd docker-magento
```
3. ```sh
cp .env.sample .env
```
4. ```sh
make up
```
5. ```sh
make magento-download
```
6. ```sh
make magento-install
```



## Magento/Application

1. ```sh
make magento-composer update
```
2. ```sh
make magento-restore-db path-to-database-dump.sql
```
3. ```sh
make magento-clear
```
4. ```sh
make magento-bash
```
