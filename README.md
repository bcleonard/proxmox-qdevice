# Proxmox Qdevice

This repository will allow you build and deploy a docker container for use with a proxmox cluster as an external qdevice.  Properly configured proxmox clusters require an odd number servers in the cluster.   In the event that you have an even number of proxmox servers (like 2, such as I have), you need an another device to vote.   Proxmox supports this by allow you to configure a qdevice for an external vote.

Normally running an even number of servers in a cluster isn't a problem, but I've had situations where I've booted both promox servers at the same time.  In that case, the first server to come online doesn't have a quarum (1 of 2) so the images won't start.  The 2nd server will (2 of 2).  With an external qdevice thats already up, the first device to come up has quarom (2 of 3).  

For more information on proxmmox clusters, external qdevices, and how to configure/use them, go [here](https://pve.proxmox.com/wiki/Cluster_Manager#_corosync_external_vote_support).

Run this container on a device that is *NOT* a virtual instance on one of your proxmox servers.

## Wiki

A wiki has been created [here](https://github.com/bcleonard/proxmox-qdevice/wiki) which contains all kinds of information.

## Requirements/Prerequisites

Please check the [wiki](https://github.com/bcleonard/proxmox-qdevice/wiki#pre-requisites) for the most up to date information.

## Install:

This repo is designed to run from either docker compose or a container manager, like Portainer.

## Configuration:

Modify the docker-compose.yml file.   Make sure to change:

* Environment Variable NEW_ROOT_PASSWORD
* location of your corosync-data (so you can keep your configuration between restarts, etc.)
* hostname 
* local network information
   parent (the ethernet device to bind macvlan)  
   ipv4_address  
   subnet  
   ip_range  
   gateway

## Running / Deploying:

You can either run the command:

`docker compose up -d`

or cut and past the docker-compose.yml into portainer.io as a stack and then deploy.

## Tested as working on:

* Debian 12 (bookworm) (all point releases up to 12) (Virtual Instance)
* Docker version 24.0.5, build ced0996 (and higher)
* Proxmox v8.0.4 (and higher)
* Portainer Community Edition v2.18.4 (and higher)

## Problems & Troubleshooting:

* You can find the most up to date information on issues, known problems and troubleshooting by reviewing the [issues](https://github.com/bcleonard/proxmox-qdevice/issues) and what is [not supported](https://github.com/bcleonard/proxmox-qdevice/wiki#whats-not-supported).

## Security Implications:

This container installs and configures a sshd server that permits root logins.  Proxmox runs in the same configuration.  Upon startup, if the environment variable **NEW_ROOT_PASSWORD** exists the root password will be set to the value of that variable upon boot.   You can specify what the root password should be setting the value of **NEW_ROOT_PASSWORD** to a password in one of the following ways:

1) If you are using a container manager, such as portainer, set the environment variable **NEW_ROOT_PASSWORD** to your specified root password.  This variable should get passed to the container.
2) Follow one of the Docker provided ways documented in how to ["Set environment variables within your container's environment"](https://docs.docker.com/compose/how-tos/environment-variables/set-environment-variables/).  Please note that one of the ways described is setting the password in the docker-compose.yml (or the stack) in the environment section (i.e. hardcoding it).   If you hardcode the password like this, you can expose the password.  You have been warned.

Please note that all of the ways listed above to set the environment above should survive the recreation of the container.

An alternative would be to **NOT SET** the password at all and change it after the container has started and is running.  Please note that this method will not survive the recreation of the container.  This means you have to change the passwor manually every time you upgrade and/or recreate the container.  To change the password after the container has started, do the following:

```bash
sudo docker exec -it proxmox-qdevice /bin/bash
root@proxmox-qdevice:/# passwd
New password:
Retype new password:
passwd: password updated successfully
root@proxmox-qdevice:/# exit
```

> [!IMPORTANT]
>
> ## A note on `latest` and `beta`:
>
> It is not recommended to use the `latest` (`bcleonard/proxmox-qdevice`, `bcleonard/proxmox-qdevice:latest`) or `beta` (`bcleonard/proxmox-qdevice:beta`) tag for production setups.
>
> [Those tags point](https://hub.docker.com/r/bcleonard/proxmox-qdevice/tags) might not point to the latest commit in the `master` branch. They do not carry any promise of stability, and using them will probably put your proxmox-qdevice setup at risk of experiencing uncontrolled updates to non backward compatible versions (or versions with breaking changes). You should always specify the version you want to use explicitly to ensure your setup doesn't break when the image is updated.

## Acknowledgements:

When I started looking at how to install & configure an external qdevice in a docker container, there was very little information available.   All the info I found was relevant to earlier versions of Proxmox ( < 8 ) or didn't work when I tried to deploy the container.  However, I did find the following very useful:

* [Proxmox VE 7 Corosync QDevice in a Docker container](https://raymii.org/s/tutorials/Proxmox_VE_7_Corosync_QDevice_in_Docker.html)
* [Dockerized Corosync QNet Daemon](https://github.com/modelrockettier/docker-corosync-qnetd)
