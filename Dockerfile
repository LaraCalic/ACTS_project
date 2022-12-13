# Build on top of the base ACTS Ubuntu 2004.v29 image
FROM ghcr.io/acts-project/ubuntu2004:v29

# Pull the ACTS git repository and compile it
WORKDIR /my-acts
RUN git clone --recursive https://github.com/acts-project/acts source && \
    cd source && \
    git submodule init && \
    git submodule update && \
    cd /my-acts && \
    mkdir build && \
    cmake -B /my-acts/build -S /my-acts/source -DACTS_BUILD_EVERYTHING=ON && \
    cmake --build build && \
    echo "I LIVE! WELCOME TO ACTS! Remember to run the startACTS.sh script inside the container to finish setup"

# Container repository: https://hub.docker.com/repository/docker/hherde/lund-acts
