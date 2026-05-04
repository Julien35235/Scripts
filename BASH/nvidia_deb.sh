#!/bin/bash
#Mise à jour du système 
sudo apt update && sudo apt full upgrade -y
#Installation de wget et de curl 
sudo apt install wget curl -y
#Installation des drivers de nvidia 
sudo apt install nvidia-driver firmware-misc-nonfree -y
#Pour installer le driver 390
#sudo apt install nvidia-legacy-390xx-driver firmware-misc-nonfree -y
#Installation des drivers de CUDA 
sudo apt install nvidia-cuda-dev nvidia-cuda-toolkit nvidia-smi -y
#Installation des Cuda drivers via wget
sudo wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb
sudo apt install ./cuda-keyring_1.1-1_all.deb
