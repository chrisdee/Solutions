## Docker: PowerShell Script to Build an Ubuntu Dev Environment Running NX Server ##

<#

Overview: Script to build and run an Ubuntu dev machine with useful applications for devlopment installed as a Docker Image. Includes the NX Server for remote access.

Resources: 

https://www.codeproject.com/Articles/1247038/Using-Docker-to-maintain-a-development-environment

https://github.com/harleydk/linuxRemoteDocker

Requires:

NoMachine client for NX Server - https://www.nomachine.com

Useful:

Kitematic - https://kitematic.com (part of Docker Toolbox)

#>

cd "T:\BoxBuild\GitHub\Solutions\Docker\UbuntuDev" #Change this path to match your environment

## Build the machine
docker build -t ubuntu_dev -f ubuntu_dev.dockerfile .

## Run the machine
docker run -d -t -p 4000:4000 --name=ubuntu_dev --cap-add=SYS_PTRACE ubuntu_dev #Change the port mapping for the container image to the host if you want to use something different than port "4000"