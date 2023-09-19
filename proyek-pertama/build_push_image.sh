#!/bin/bash

# Perintah untuk membuat Docker image dari Dockerfile
docker build -t item-app:v1 .

# Melihat daftar image di lokal
docker images

# Mengubah nama image agar sesuai dengan GitHub Packages
docker tag item-app:v1 ghcr.io/lareza-farhan-wanaghi/item-app:v1

# Login ke GitHub Packages 
echo $GH_PACKAGES_TOKEN | docker login ghcr.io -u lareza-farhan-wanaghi --password-stdin

# Mengunggah image ke GitHub Packages
docker push ghcr.io/lareza-farhan-wanaghi/item-app:v1
