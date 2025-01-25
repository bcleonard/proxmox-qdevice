#!/bin/sh -x

if [ ! -z ${NEW_ROOT_PASSWORD+x} ]
then
  echo "root:${NEW_ROOT_PASSWORD}" | chpasswd
fi
