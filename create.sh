#!/bin/bash

echo 'making volumes dir'
mkdir -p /root/volumes

echo 'pulling down containers'

docker pull crosbymichael/skydock
docker pull crosbymichael/skydns
docker pull crosbymichael/hipache
docker pull crosbymichael/rethinkdb
docker pull crosbymichael/minecraft
docker pull crosbymichael/redis
docker pull crosbymichael/blog

echo 'starting initial containers'

docker run -d -p 172.17.42.1:53:53/udp --name skydns crosbymichael/skydns -nameserver 8.8.8.8:53 -domain docker
docker run -d -v /var/run/docker.sock:/docker.sock --name skydock -link skydns:skydns crosbymichael/skydock -ttl 60 -environment prod -s /docker.sock -domain docker

docker run -d --name hipache -p 80:80 crosbymichael/hipache
docker run -d --name drone -v /root/volumes/drone/drone.sqlite:/gocode/src/github.com/drone/drone/drone.sqlite crosbymichael/drone
docker run -d --name blog1 crosbymichael/blog
