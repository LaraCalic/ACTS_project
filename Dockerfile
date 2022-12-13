# Build on top of the base ACTS Ubuntu 2004.v9 image
FROM ghcr.io/acts-project/ubuntu2004:v9

# Pull the ACTS git repository and compile it
WORKDIR /my-acts
RUN s source && \
    cd source && \
    git submodule init && \
    git submodule update && \
    cd /my-acts && \
    mkdir build && \
    cmake -B /my-acts/build -S /my-acts/source -DACTS_BUILD_ALIGNMENT=ON -DACTS_BUILD_EXAMPLES=ON -DACTS_BUILD_EXAMPLES_PYTHON_BINDINGS=ON -DACTS_BUILD_FATRAS=ON -DACTS_BUILD_ANALYSIS_APPS=ON -DACTS_BUILD_EXAMPLES_DD4HEP=ON && \
    cmake --build build && \
    echo "I LIVE! WELCOME TO ACTS!"
