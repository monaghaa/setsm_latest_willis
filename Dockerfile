FROM setsm/setsm:latest-gnu_ubuntu-latest

RUN apt-get update && \
    apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3 \
    python3-pip \
    libgdal-dev \ 
    gdal-bin \
    wget
RUN rm -rf /var/lib/apt/lists*

COPY requirements.txt /tmp/

ARG CPLUS_INCLUDE_PATH=/usr/include/gdal
ARG C_INCLUDE_PATH=/usr/include/gdal

RUN mkdir /software
ARG STEREO_PIPELINE=StereoPipeline-3.0.0-2021-07-27-x86_64-Linux.tar.bz2
RUN wget https://github.com/NeoGeographyToolkit/StereoPipeline/releases/download/3.0.0/${STEREO_PIPELINE}
RUN mv ${STEREO_PIPELINE} /software/${STEREO_PIPELINE}
RUN tar -xvf /software/${STEREO_PIPELINE} --directory /software
RUN rm /software/${STEREO_PIPELINE}

##SETUP ENVIRONMENT 
ENV PATH="$PATH:/software/StereoPipeline-3.0.0-2021-07-27-x86_64-Linux/bin" 
ENV setsm_dir=/opt/setsmdir
ENV libtiff_path=/usr/lib64
ENV LD_LIBRARY_PATH="/usr/lib64:$LD_LIBRARY_PATH"
RUN /usr/bin/pip3 install --upgrade pip
RUN /usr/bin/pip3 install -r /tmp/requirements.txt

WORKDIR /app/bin

ENTRYPOINT ["/usr/bin/python3","wrapper.py","input.txt"]
