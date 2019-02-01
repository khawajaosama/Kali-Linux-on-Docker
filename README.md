# Kali Linux In a Docker Container

![](pictures/kali_logo.jpeg)



- ![#f03c15](https://placehold.it/15/f03c15/000000?text=+) `Docker is a great alternative to virtualization when playing with various tools or for creating isolated environments.`
- ![#c5f015](https://placehold.it/15/c5f015/000000?text=+) `Docker is lightweight ,runs natively on Linux, no hypervisor layer.`
- ![#1589F0](https://placehold.it/15/1589F0/000000?text=+) `Kubernetes is a container orchestration system for Docker containers that is more extensive than Docker Swarm and is meant to coordinate clusters of nodes at scale in production in an efficient manner.`

## REQUIREMENTS:


- I assume you have Docker installed [Docker](https://www.docker.com/community-edition).
- It is good to have [Linux](https://www.linux.org/) OS.
- Kali Linux [Kali Linux]((https://www.kali.org/news/official-kali-linux-docker-images/)

    
## Getting Started:

Getting minimal Kali image up and running

```
$ docker pull kalilinux/kali-linux-docker
$ docker run -ti kalilinux/kali-linux-docker /bin/bash
```
This downloads official Kali Linux Docker image, creates a container based on that image and starts /bin/bash in the container

## Installing Packages :
Update Kali packages and install the tools you’ll be using, such as Metasploit
```
$ apt update
$ apt dist-upgrade
$ apt autoremove
$ apt clean
```
Consider using kali-linux-top10 as your starting point:
```
$ apt install kali-linux-top10
```
## Stop the Container:

Stop the container by pressing " CTRL + P + Q "
After exiting from container stop it by:
```
$ docker stop CONTAINER ID
```
## Create New Container From Existing Container:
To create a new image based on the changes we just did:
```
$ docker commit CONTAINER ID my_kali
```
You can view container id by:
```
$ docker ps -a
```
## Run this Image:
```
$ docker run -it my-kali /bin/bash
```
## Persistence Strategies:
### Option 1 — Volumes:
You would want to save the data in the following folders so that you don’t start from scratch when the container is deleted:
```
$ /root — home dir for root (downloads, notes, source code etc.)
$ /var/lib/postgresql— Postgres database files (used by Metasploit)
```
This is how you start a new Kali Linux container using the custom image created earlier and map the two locations above to Docker Volumes:
```
$ docker run -ti --rm --mount src=kali-root,dst=/root --mount src=kali-postgres,                    dst=/var/lib/postgresql mykali
```
This will create two volumes named kali-root and kali-postgres — or use existing ones on subsequent runs — and map them to the created container.

--rm switch makes Docker delete the container once it stops (i.e. once you exit the shell

You can use -v option for mounting volumes, though it is considered an “old way” that is being replaced by the more explicit --mount option.

Another alternative is to map a directory on the host machine to those paths. This is called “bind mount” and can also be done through either -v or--mount. For example:
```
$ docker run -ti --rm --mount type=bind,src=/some/path/kali-root,dst=/root --mount type=bind,   
  src=/some/path/kali-postgres,dst=/var/lib/postgresql mykali bash
```
The target directory on the host must already exist when using --mount.

### Option 2 — Within the Container:
This option is worse from performance perspective due to the copy-on-write magic Docker has to do for any file system changes within the container as compared to the image.

Once the container stops (i.e. when you exit the shell), it is not deleted by default. You can view all the containers, including stopped ones, using:

```
$ docker ps -a
```
Note the CONTAINER ID in the output. You can later restart the container using:
```
docker start --attach <CONTAINER ID>
```
The data is retained in the container.  