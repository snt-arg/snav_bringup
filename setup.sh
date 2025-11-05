#!/bin/bash

# This script scaffolds the workspace from scratch,
# fetching the source all packages specified in the
#.rosinstall file, installing their dependencies,
# if required, and running build everything with
# colcon build.
sudo apt update
sudo apt install -y python3-vcstool
sudo apt install -y libceres-dev
sudo apt install -y python3-pip

#install python dependencies
pip3 install torch==2.0.1+cu118 -f https://download.pytorch.org/whl/torch_stable.html
pip3 install torch-geometric==2.3.1
pip3 install torch-sparse==0.6.17+pt20cu118 -f https://data.pyg.org/whl/torch-2.0.1+cu118.html
pip3 install pyg-lib -f https://data.pyg.org/whl/torch-2.0.1+cu118.html
pip install protobuf==3.20.*

mkdir -p src

#rosdep init
rosdep update --include-eol-distros

#import all repos
vcs import --recursive src < .rosinstall

#install python requirements
pip3 install -r requirements.txt

#rosdep install
rosdep install --from-paths . -y --ignore-src -r

#Build the workspace
colcon build --symlink-install --cmake-args

source install/setup.bash