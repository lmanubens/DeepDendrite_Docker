# DeepDendrite_Docker

Clone the repository with submodules:

```
git clone --recurse-submodules git://github.com/lmanubens/DeepDendrite_Docker
```

Install Nvidia Container Toolkit for GPU Use wtih Docker
```
sudo apt-get update
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

Build the container
```
docker compose up
```

Run container with GPU flag  
```
docker run -it --rm --gpus all DeepDendrite-deepd bash
```

#  https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/23.9.1/getting-started.html#operator-install-guide
# docker build --pull -t \
#     --build-arg DRIVER_VERSION=455.28 \
#     nvidia/driver:455.28-ubuntu20.04 \
#     --file Dockerfile .