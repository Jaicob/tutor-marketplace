#!/bin/sh
brew update
brew install boot2docker
boot2docker init
boot2docker up

#I would reccomend adding this line to your .zshrc or .bshrc
eval "$(boot2docker shellinit)"

brew install docker
docker version

#use "boot2docker ip 2"  to get the host ip address