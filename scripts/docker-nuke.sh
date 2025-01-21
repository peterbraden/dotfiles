#!/bin/bash
read -a docker_processes < <(docker ps --all -q)
read -a docker_images < <(docker images --all -q)
docker rm --force "${docker_processes[@]}"
docker rmi --force "${docker_images[@]}"
