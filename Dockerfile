FROM tensorflow/tensorflow:latest-devel-py3

ENV SRC_DIR=/tmp

RUN apt-get update && \
    apt-get install -y \
        python3 \
        python3-dev \
        python3-pip \
        python3-numpy \
        python3-scipy \
        python3-matplotlib \
        cmake \
        wget \
        unzip \
        libjpeg-dev \
        libpng++-dev \
        libtiff-dev \
        libopenexr-dev \
        libwebp-dev
    # download opencv source
RUN mkdir -p ${SRC_DIR} && \
    cd ${SRC_DIR} && \
    wget https://github.com/opencv/opencv/archive/3.2.0.zip && \
    unzip 3.2.0.zip && \
    mv opencv-3.2.0 opencv && \
    rm 3.2.0.zip && \

    # download opnecv_contrib source
    wget https://github.com/opencv/opencv_contrib/archive/3.2.0.zip && \
    unzip 3.2.0.zip && \
    mv opencv_contrib-3.2.0 opencv_contrib && \
    rm 3.2.0.zip

    # build
RUN  mkdir -p ${SRC_DIR}/opencv/build  && \
     cd ${SRC_DIR}/opencv/build  && \
     cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules/ -D BUILD_DOCS=OFF ..  && \
     make -j4  && \
     make install  && \
     rm -rf ${SRC_DIR}  && \
     rm -rf /var/lib/apt/lists/* && \
     ln /dev/null /dev/raw1394