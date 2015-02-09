Linked Data Registry Vagrant Docker Installation
================================================


Sets up and runs the linked data registry on a host machine (running Ubuntu) using Vagrant and Docker. Vagrant builds a docker image from the Dockerfile. Vagrant provisions a docker container created from this image and starts tomcat. Port 8080 is mapped to port 80 on the host machine in the Vagrantfile. 

## Prerequistes

- Ubuntu >14.04 64bit
- Docker >1.0  (see https://docs.docker.com/installation/)


## Instructions

1. Run the docker build process

```
$ docker build -t registry .
```

2. Perform the docker run to deploy
```
$ docker run --privileged --enable-insecure-key -d -p 80:8080 -p 2222:22 registry
```

3. SSH into the container

The docker build automatically genereates ssh keys as per https://github.com/phusion/baseimage-docker#login_ssh
```
$ docker ps
$ docker inspect -f "{{ .NetworkSettings.IPAddress }}" <ID>

# Download the insecure private key
curl -o insecure_key -fSL https://github.com/phusion/baseimage-docker/raw/master/image/insecure_key
chmod 600 insecure_key

# Login to the container
ssh -i insecure_key root@<IP address>

# Running a command inside the container
ssh -i insecure_key root@<IP address> echo hello world
```


