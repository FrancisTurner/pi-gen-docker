# pi-gen-docker
Modifications to the RPI pi-gen tool ( https://github.com/RPi-Distro/pi-gen )
 to create a ready to go raspberry pi docker server

Getting docker to run on a pi is not *that* complex but it would be nice 
if you could just have it stood up and ready to go. 

The image created at the end of this also has docker-compose on it.

This repo is based on my baselite repo and therefore in addition to docker it 
has the following minor tweaks that make it a good basic headless server. 
The tweaks are:
 * user/password is docker/docker
 * SSH is enabled by default
 * If a file called netcfg.txt with dhcpcd.conf lines is placed in /boot/ those lines will be appended to dhcpcd.conf so that the pi boots with a static IP address/gateway/dns as specified in the file

## Dependencies

 * RPI pi-gen tool ( https://github.com/RPi-Distro/pi-gen )
 * my pi-gen-utils scripts (https://github.com/FrancisTurner/pi-gen-utils )

## Usage

```
cd /path/to/pi-gen/projects
git clone https://github.com/RPi-Distro/pi-gen.git
git clone https://github.com/FrancisTurner/pi-gen-utils.git
git clone https://github.com/FrancisTurner/pi-gen-docker.git

sudo cp pi-gen-utils/*.sh /usr/local/bin
cd pi-gen-basedocker
setuppigen.sh
cd ../pi-gen
build-docker.sh # or build.sh if you don't want to use docker
```
Pi-gen creates an image in pi-gen/deploy/ 
```
cp deploy/image*dockerpi-lite* /some/where/useful/
cd -
restorepigen.sh
```
Burn pi image - using tool of choice e.g. Balena Etcher ( https://www.balena.io/etcher/ )

Edit samplenetcfg.txt and save to the boot partition on the newly flashed SD card as netcfg.txt.

Notes:
 * You may need to eject and reinsert the SD card for your OS to correcly
mount the newly created partition(s). 
 * If you are flashing from a windows machine, ignore suggestions to format the
new drive when you reinsert the SD card
 * Creating a netcfg.txt file is optional as without it the pi will query 
for a DHCP address, but it is strongly recommended because otherwise it
can be tricky to figure out how to connect 
to your server and the server address may change over time, which is usually
a bad thing. 

Eject the SD card, stick it in the pi, connect network cable and power the pi on.

Wait a minute or so for the pi to boot (check by pinging its IP address e.g. 192.168.1.250) then 
ssh to it as user docker password docker. Change the password and run some
docker tests to prove that everything works, then do your own docker stuff

```
$ ping 192.168.1.250
PING 192.168.1.250 (192.168.1.250) 56(84) bytes of data.
64 bytes from 192.168.1.250: icmp_seq=6 ttl=63 time=8.70 ms
64 bytes from 192.168.1.250: icmp_seq=7 ttl=63 time=5.11 ms
^C
$ ssh docker@192.168.1.250
The authenticity of host '192.168.1.250 (192.168.1.250)' can't be established.
ECDSA key fingerprint is SHA256:E7QQpIhTTvh8WfaFaVUF2IYRP/bNyqSQM7eyU4t9Fcg.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.1.250' (ECDSA) to the list of known hosts.
docker@192.168.1.250's password: 
Linux serverpi 4.19.118-v7+ #1311 SMP Mon Apr 27 14:21:24 BST 2020 armv7l

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
docker@dockerpi:~ $ passwd
...
docker@dockerpi:~ $ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
4ee5c797bcd7: Pull complete 
Digest: sha256:d58e752213a51785838f9eed2b7a498ffa1cb3aa7f946dda11af39286c3db9a9
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (arm32v7)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

docker@dockerpi:~ $ cd composetest/
docker@dockerpi:~/composetest $ ls
app.py  docker-compose.yml  Dockerfile  requirements.txt
docker@dockerpi:~/composetest $ docker-compose up
Creating network "composetest_default" with the default driver
Building web
Step 1/9 : FROM python:3.7-alpine
3.7-alpine: Pulling from library/python
...
```

## Use cases

The obvious one is to create usable docker servers for learning about docker. This, 
and the ability to create test servers that I can blow away as/when I break things,
is why I created this repo in the first place. 

However with modifications 
it can be used to deploy and run a series of docker containers in a SOHO/SMB
production environment. To do this you will need to put the relevant
docker-compose.yml files in the image and then get them to run after boot (probably 
by putting the commands in rc.local. To see how to do this look at how the 
composetest files are put in ~/composetest/ (see stage2_01-sys-tweaks_01-run.sh)

