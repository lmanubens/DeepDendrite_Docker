# Check available containers at: https://catalog.ngc.nvidia.com/orgs/nvidia/containers/nvhpc/tags
ARG HPCSDK_VER="23.11"
ARG CUDA_VER="12.3"
#ARG HPCSDK_VER="21.9"
#ARG CUDA_VER="11.4"
FROM nvcr.io/nvidia/nvhpc:${HPCSDK_VER}-devel-cuda${CUDA_VER}-ubuntu20.04
ARG HPCSDK_VER

COPY . /home

WORKDIR /home

# Get some dependencies
RUN apt update -y
RUN DEBIAN_FRONTEND=noninteractive apt install build-essential pkg-config curl environment-modules bison byacc flex python3.8-dev python3.8-distutils python3-pip git cmake python-is-python3 libncurses-dev libreadline-dev autoconf libtool mpich -y

# Get DeepDendrite (if not already present in current directory)
#RUN cd /home && git clone https://github.com/pkuzyc/DeepDendrite

# Install NEURON
RUN PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" && cd /home/DeepDendrite/src/nrn_modify/ && chmod +x /home/DeepDendrite/src/nrn_modify/configure && autoreconf -f -i && ./configure --prefix /home/DeepDendrite/install --without-iv --with-paranrn --with-nrnpython=`which python` && make -j$(nproc) && make install

# Install DeepDendrite
ENV CC=mpicc
ENV CXX=mpicxx
ENV CUDA_BIN_PATH="/opt/nvidia/hpc_sdk/Linux_x86_64/${HPCSDK_VER}/cuda"
RUN cd /home/DeepDendrite/src/DeepDendrite && rm -rf build && mkdir build && cd build && cmake .. -DCMAKE_C_FLAGS:STRING="-lrt -g -O0 -mp -mno-abm" -DCMAKE_CXX_FLAGS:STRING="-lrt -std=c++11 -g -O0 -mp -mno-abm" -DCOMPILE_LIBRARY_TYPE=STATIC -DCMAKE_INSTALL_PREFIX="../../../install" -DADDITIONAL_MECHPATH="../../all_mechanisms" -DCUDA_HOST_COMPILER=`which gcc` -DCUDA_PROPAGATE_HOST_FLAGS=OFF -DENABLE_SELECTIVE_GPU_PROFILING=ON -DENABLE_OPENACC=ON -DAUTO_TEST_WITH_SLURM=OFF -DAUTO_TEST_WITH_MPIEXEC=OFF -DFUNCTIONAL_TESTS=OFF -DUNIT_TESTS=OFF && make -j$(nproc) && make install

# Get some more dependencies 
RUN pip install numpy matplotlib progressbar
