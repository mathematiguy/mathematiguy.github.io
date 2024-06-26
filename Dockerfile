# Base image
FROM ubuntu:23.04

# Avoid prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

# Update the system and install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    ca-certificates \
    tar \
    python3 \
    python3-pip

# Python and Pip are installed now, setting Python3 as the default Python
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# Download and install a specific version of Go
ENV GO_VERSION 1.15
RUN wget https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -xf go${GO_VERSION}.linux-amd64.tar.gz -C /usr/local && \
    rm go${GO_VERSION}.linux-amd64.tar.gz

# Set environment variables
ENV PATH="/usr/local/go/bin:${PATH}"

# Download and install Hugo
RUN wget https://github.com/gohugoio/hugo/releases/download/v0.125.7/hugo_extended_0.125.7_Linux-64bit.tar.gz \
&& tar -xzf hugo_extended_0.125.7_Linux-64bit.tar.gz -C /usr/local/bin/ \
&& rm hugo_extended_0.125.7_Linux-64bit.tar.gz

# Set the working directory
WORKDIR /code

# Copy your project files into the Docker image
COPY . /code

# Run hugo, delete the project files and make /tmp readable to ubuntu user
RUN hugo && \
    rm -rf /code/* && \
    chown ubuntu:ubuntu -R /tmp

# Command to run on container start
CMD ["bash"]
