FROM nvcr.io/nvidia/cuda-dl-base:25.04-cuda12.9-devel-ubuntu24.04

ARG DEBIAN_FRONTEND=noninteractive

# Environment variables
ENV CUDA_HOME=/usr/local/cuda \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    ROS_DISTRO=jazzy \
    PIP_BREAK_SYSTEM_PACKAGES=1

# --- Fix MPI issue ---
RUN mkdir -p /opt/hpcx/ompi/lib/x86_64-linux-gnu \
 && ln -s /opt/hpcx/ompi /opt/hpcx/ompi/lib/x86_64-linux-gnu/openmpi \
 && dpkg-reconfigure libc-bin

# --- System setup ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    python-is-python3 \
    git \
    openssh-client \
    wget \
    vim \
    curl \
    libeigen3-dev \
    build-essential \
    locales \
    software-properties-common \
    lsb-release \
    gnupg2 && \
    locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN add-apt-repository universe

# --- ROS 2 Jazzy APT source setup ---
RUN ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}') && \
    curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $VERSION_CODENAME)_all.deb" && \
    apt install -y /tmp/ros2-apt-source.deb

# --- Install ROS 2 Jazzy development tools ---
RUN apt update && apt upgrade -y && \
    apt install -y ros-dev-tools ros-${ROS_DISTRO}-desktop ros-${ROS_DISTRO}-rqt-tf-tree

# --- Source ROS globally ---
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /etc/bash.bashrc

RUN apt remove --purge python3-typing-extensions -y
RUN pip3 install typing-extensions==4.11.0 

# --- Initialize rosdep ---
RUN rosdep init && rosdep update

# --- SSH keys ---
# Define the SSH keys as build arguments for latter mounting
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# --- Clone repositories ---
RUN apt-get update && apt-get install -y \
    libepoxy-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    freeglut3-dev \
    libglew-dev \
    cmake \
    build-essential \
    git

RUN apt-get update && apt-get install -y \
  libgoogle-glog-dev libgflags-dev \
  libprotobuf-dev protobuf-compiler \
  libnlopt-dev libnlopt-cxx-dev


RUN pip install vcstool

WORKDIR /workspace/src
RUN --mount=type=ssh git clone git@github.com:snt-arg/snav_bringup.git -b main 
RUN --mount=type=ssh vcs import < snav_bringup/packages.repos
# Install dependencies
WORKDIR /workspace/
RUN rosdep install --from-paths src --ignore-src -r -y

# Compile ws
RUN source /opt/ros/$ROS_DISTRO/setup.bash && \
    colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release


WORKDIR /dependencies
WORKDIR /opt

# Install Cargo and mprocs
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
RUN /root/.cargo/bin/cargo install mprocs
RUN cp /root/.cargo/bin/mprocs /usr/local/bin/mprocs

RUN echo "source /workspace/install/setup.bash" >> ${HOME}/.bashrc
# SHELL ["/bin/bash", "-l", "-c"]
WORKDIR /workspace/src/snav_bringup

# export entrypoint into a file
# RUN echo '#!
# RUN chmod a+x /entrypoint.sh
# ENTRYPOINT ["/entrypoint.sh"]






# RUN apt-get update && apt-get install -y \
#   ros-${ROS_DISTRO}-pcl-ros \
#   ros-${ROS_DISTRO}-tf2-ros \
#   ros-${ROS_DISTRO}-tf2-eigen \
#   ros-${ROS_DISTRO}-ompl \
#   ros-${ROS_DISTRO}-cv-bridge \
#   ros-${ROS_DISTRO}-backward-ros 
  
#     ros-${ROS_DISTRO}-image-geometry \
#     ros-${ROS_DISTRO}-cv-bridge \
#     ros-${ROS_DISTRO}-image-pipeline
# RUN apt-get install -y libgoogle-glog-dev libgflags-dev 
# RUN apt-get install -y ros-${ROS_DISTRO}-ompl
# RUN apt-get install -y protobuf-compiler libprotobuf-dev 
# RUN apt-get install -y ros-${ROS_DISTRO}-tf2-ros ros-${ROS_DISTRO}-tf2-eigen ros-${ROS_DISTRO}-pcl-ros
# Build the workspace
# WORKDIR /workspace/
# RUN /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release && rosdep update"

# COPY ./entrypoint.sh /entrypoint.sh

# RUN chmod a+x /entrypoint.sh
# ENTRYPOINT ["/entrypoint.sh"]

