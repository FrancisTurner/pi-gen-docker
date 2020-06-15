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
```

## Use cases

The obvious one is to create usable docker servers for classes about docker. This, 
and the ability to create test servers that I can blow away as/when I break things
is why I created this repo in the first place. However with modifications 
it could be used to deploy and run a series of docker containers in a 
production environment. To do this you will need to put the relevant
docker-compose.yml files in the image and then get them to run after boot (probably 
by putting the commands in rc.local. To see how to do this look at how the 
composetest files are put in ~/composetest/ (see stage2_01-sys-tweaks_01-run.sh)

