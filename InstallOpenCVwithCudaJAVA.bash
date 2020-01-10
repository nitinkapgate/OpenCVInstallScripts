#
# opencv_v4l2 - opencv_install_script.bash file
#
# Copyright (c) 2017-2018, e-con Systems India Pvt. Ltd.  All rights reserved.
#
# Script to install optimized OpenCV

info () {
	info_msg=$1
	echo "INFO: $info_msg"
}

error () {
	error_msg=$1
	echo "ERROR: $error_msg"
	exit 1
}

OPENCV_VERSION='4.2.0'
CUDA_INCLUDE_DIR='/usr/local/cuda/include'
SCRIPT_DIR="$(pwd)"

if (
	info "Installing basic dependencies required for OpenCV" &&
	sudo apt-get --assume-yes install build-essential &&
	sudo apt-get --assume-yes install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
)
then
	info "Installing dependencies succeeded."
else
	error "Installing dependencies failed!"
fi

if (
	info "Installing additional dependencies required for this build" &&
	sudo apt-get --assume-yes install libtbb-dev libeigen3-dev libopenblas-dev liblapacke-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgtk2.0-dev libgtkglext1 libgtkglext1-dev python-dev python-numpy python3-dev python3-numpy
)
then
	info "Installing additional dependencies succeeded."
else
	error "Installing additional dependencies failed!"
fi

if (
	info "Downloading OpenCV version ${OPENCV_VERSION}" &&
	wget -O opencv-${OPENCV_VERSION}.zip https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip --progress=dot &&
	unzip -q opencv-${OPENCV_VERSION}.zip
  wget -O opencv-${OPENCV_VERSION}.zip https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip --progress=dot &&
	unzip -q opencv-${OPENCV_VERSION}.zip
)
then
	info "Downloading and extracting OpenCV succeeded."
else
	error "Downloading and extracting OpenCV failed."
fi


if (
	info "Build and installing OpenCV ${OPENCV_VERSION}." &&
	cd opencv-${OPENCV_VERSION} &&
	mkdir -p build &&
	cd build &&
	cmake -C ${SCRIPT_DIR}/opencv_build_options.cmake .. &&
	make -j4 && # An higher value of -j may speed-up the process a little
	sudo make install
)
then
	info "Building and installation succeeded"
else
	error "Building and installing OpenCV ${OPENCV_VERSION} failed."
fi
