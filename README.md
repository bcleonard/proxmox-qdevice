# Proxmox Qdevice

This repository will allow you build and deploy a docker container for use with a proxmox cluster as an external qdevice.  Properly configured proxmox clusters require an odd number servers in the cluster.   In the event that you have an even number of proxmox servers (like 2, such as I have), you need an another device to vote.   Proxmox suports this by allow you to configure a qdevice for an external vote.

Normally running an even number of servers in a cluster isn't a problem, but I've had situations where I've booted both promox servers at the same time.  In that case, the first server to come online doesn't have a quarum (1 of 2) so the images won't start.  The 2nd server will (2 of 2).  With an external qdevice thats already up, the first device to come up has quarom (2 of 3).  

For more information on proxmmox clusters, external qdevices, and how to configure/use them, go [here](https://pve.proxmox.com/wiki/Cluster_Manager#_corosync_external_vote_support).

Run this container on a device that is *NOT* a virtual instance on one of your proxmox servers.   Run it on a 3rd physical device.

## Requirements/Prerequisites

* [Docker](https://www.docker.com/)
* [Docker Compose](https://docs.docker.com/compose/)
* internet connection
* A proxmox cluster with an even number of servers
* a dedicated IP address in your network to bind the container too.

## Install:

This repo is designed from either docker compose or a container manager, like Portainer.

## Configuration:

Modify the docker-compose.yml file.   Make sure to change:

* Environment Variable NEW_ROOT_PASSWORD
* location of your corosync-data (so you can keep your configuration between restarts, etc.)
* hostname 
* local network information
   parent (the eithernet device to bind macvlan)  
   ipv4_address  
   subnet  
   ip_range  
   gateway

## Running / Deploying:

You can either run the command:

`docker compose up -d`

or cut and past the docker-compose.yml into portainer.io as a stack and then deploy.

## Tested as working on:

* Debian 12 (bookworm) (Virtual Instance)
* Docker version 24.0.5, build ced0996
* Proxmox v8.0.4
* Portainer Community Edition v2.18.4

## Problems & Troubleshooting:

* none identified at this time.

## Security Implications:

This container installs & configured a sshd server that permits root logins.  Proxmox runs in the same configuration.   You specify the root password in the docker-compose.yml or the stack.   If you hardcode it, you will expose the password.   You have been warned.

## Acknowledgements:

When I started looking at how to install & configure an external qdevice in a docker container, there was very little information available.   All the info I found was relevant to earlier versions of Proxmox ( <8 ) or didn't work when I tried to deploy the container.  However, I did find the following very useful:

* [Proxmox VE 7 Corosync QDevice in a Docker container](https://raymii.org/s/tutorials/Proxmox_VE_7_Corosync_QDevice_in_Docker.html)
* [Dockerized Corosync QNet Daemon](https://github.com/modelrockettier/docker-corosync-qnetd)
