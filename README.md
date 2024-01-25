# DeepDendrite_Docker

Clone the repository with submodules:

```
git clone --recurse-submodules https://github.com/lmanubens/DeepDendrite_Docker 
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
See also: https://ubuntu.com/blog/getting-started-with-cuda-on-ubuntu-on-wsl-2 

Build the container
```
docker compose up
```

Run container with GPU flag  
```
docker run -it --rm --gpus all deepdendrite_docker-deepd bash
```

To test quickly you can edit Figure 5 gen_model.py setting NUMBER_OF_RUNS_DIST = 5 and NUMBER_OF_RUNS_CLUSTER = 5 (lines 32 and 34), also editing run.py so that dirs of interest change from "./coredat/coredat_1150cell_400_1.0hz_back_noise_1.3spine" to "./coredat/coredat_115cell_400_1.0hz_back_noise_1.3spine" (lines 11, 15, 26 and 30).

Others:
https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/23.9.1/getting-started.html#operator-install-guide
```
 docker build --pull -t \
     --build-arg DRIVER_VERSION=455.28 \
     nvidia/driver:455.28-ubuntu20.04 \
     --file Dockerfile .
```
