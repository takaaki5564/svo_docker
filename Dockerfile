FROM osrf/ros:noetic-desktop-full

ENV DEBIAN_FRONTEND noninteractive

RUN apt update
RUN apt install vim python3-pip python3-git python3-setuptools -y
RUN apt install python3-osrf-pycommon python3-catkin-tools python3-vcstool -y
RUN apt install python3-termcolor python3-wstool git libatlas3-base wget libglew-dev libopencv-dev libyaml-cpp-dev libblas-dev liblapack-dev libsuitesparse-dev autoconf automake libtool -y

RUN mkdir svo_ws && cd svo_ws && \
catkin config --init --mkdirs --extend /opt/ros/noetic --cmake-args -DCMAKE_BUILD_TYPE=Release -DEIGEN3_INCLUDE_DIR=/usr/include/eigen3 && \
cd src && \
git clone https://github.com/uzh-rpg/rpg_svo_pro_open.git && \
sed -i 's/git@github.com:/https:\/\/github.com\//g' ./rpg_svo_pro_open/dependencies.yaml && \
vcs-import < ./rpg_svo_pro_open/dependencies.yaml && \
sed -i 's/git@github.com:/https:\/\/github.com\//g' ./dbow2_catkin/CMakeLists.txt && \
touch minkindr/minkindr_python/CATKIN_IGNORE && \
cd rpg_svo_pro_open/svo_online_loopclosing/vocabularies && ./download_voc.sh && \
cd ../../..

RUN cd svo_ws && \
catkin build
