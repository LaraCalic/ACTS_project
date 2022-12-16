# Build on top of the base ACTS Ubuntu 2004.v33 image
FROM ghcr.io/acts-project/ubuntu2004:v33

# Pull the ACTS git repository and compile it
WORKDIR /my-acts

# Install git lfs
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get install git-lfs

# Install vim
RUN apt-get -y install vim

# Add some python dependencies
RUN pip3 install jupyter notebook pandas scipy matplotlib

# Download ACTS
RUN git clone --recursive https://github.com/acts-project/acts source && \
    cd source/thirdparty/OpenDataDetector && \
    git submodule init && \
    git submodule update && \
    git lfs pull

# Download python requirements
RUN pip3 install -r /my-acts/source/Examples/Python/tests/requirements.txt

# Compile ACTS
RUN cd /my-acts && \
    mkdir build && \
    DD4hep_DIR=/usr/local/cmake cmake -B /my-acts/build -S /my-acts/source -DACTS_BUILD_EVERYTHING=ON -DACTS_BUILD_EXAMPLES_PYTHON_BINDINGS=ON -DACTS_BUILD_ALIGNMENT=ON -DACTS_BUILD_EXAMPLES_DD4HEP=ON -DACTS_BUILD_PLUGIN_TGEO=ON -DACTS_BUILD_PLUGIN_DD4HEP=ON -DACTS_BUILD_ODD=ON && \
    cmake --build build && \
    echo "I LIVE! WELCOME TO ACTS! Remember to run the startACTS.sh script inside the container to finish setup"

# Container repository: https://hub.docker.com/repository/docker/hherde/lund-acts

# Examine cmake configuration: apt-get install cmake-curses-gui
# Then, ccmake . in the build directory

# DD4hep_DIR=/usr/local/cmake cmake -B /my-acts/build -S /my-acts/source -DACTS_BUILD_EVERYTHING=ON -DACTS_BUILD_EXAMPLES_PYTHON_BINDINGS=ON -DACTS_BUILD_ALIGNMENT=ON -DACTS_BUILD_EXAMPLES_DD4HEP=ON -DACTS_BUILD_PLUGIN_TGEO=ON -DACTS_BUILD_PLUGIN_DD4HEP=ON -DACTS_BUILD_ODD=ON --> FAILED

# cmake -B /my-acts/build -S /my-acts/source -DACTS_BUILD_EXAMPLES_PYTHON_BINDINGS=ON -DACTS_BUILD_ALIGNMENT=ON -DACTS_BUILD_EXAMPLES_DD4HEP=ON -DACTS_BUILD_PLUGIN_TGEO=ON -DACTS_BUILD_PLUGIN_DD4HEP=ON -DACTS_BUILD_ODD=ON --> FAILED

#     DD4hep_DIR=/usr/local/cmake cmake -B /my-acts/build -S /my-acts/source  -DACTS_BUILD_EXAMPLES_PYTHON_BINDINGS=ON -DACTS_BUILD_ALIGNMENT=ON -DACTS_BUILD_ODD=ON && \
