#   DESCRIPTION: Python3 data science development container
#   AUTHOR:     Erik Howard <erikhoward@protonmail.com>
#   COMMENT:    A Python3 development environment that contains many
#               popular data science packages
#   USAGE:
#
#       Interactive terminal
#       docker run --rm -it --name py3ds -v $HOME/data:/data erikhoward/python3 /bin/bash
#
#       Jupyter notebook
#       docker run -rm \
#       -it -p 8888:8888 erikhoward/python3-datascience \
#       -v $HOME/src/notebooks:/src/notebooks \
#	-w /src/notebooks \
#       /bin/bash -c "mkdir -p /src/notebooks && /opt/conda/bin/jupyter notebook --notebook-dir=/src/notebooks --ip='*' --port=8888 --no-browser --allow-root"

# Base docker image
FROM continuumio/miniconda3:4.4.10

LABEL maintainer "Erik Howard <erikhoward@protonmail.com>"

# Install packages non-interactively
ENV DEBIAN_FRONTEND noninteractive

# Add version file to image
ADD VERSION .

# Install common packages
RUN apt-get update -y && apt-get install -y \
    wget \
    curl \
    git \
    g++ \
    autoconf \
    automake \
    checkinstall \
    cmake \
    python3-yaml \
    python3-pydot \
    locales \
    locales-all \
    openssl \
    unzip \
    libxml2-dev \
    libhdf5-dev \
    default-libmysqlclient-dev \
    libpq-dev \
    libgtk2.0-dev \
    libgl1-mesa-glx \
    postgresql-client \
    postgresql-client-common \
    software-properties-common \
    build-essential \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Ensure UTF-8 locale
RUN locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales

# Set the time zone to the local time zone
RUN echo "America/Los_Angeles" > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Install essential data science packages
RUN conda update -y conda && conda update -y python && \
    conda install -y scipy scikit-learn scikit-image nose readline pandas matplotlib sqlalchemy \
    seaborn bokeh notebook nltk pip scipy jupyter && \
    conda install -y cython hdf5 pytables && \
    conda install -y -c conda-forge rtree wordcloud lightgbm && \
    conda install pytorch-cpu torchvision -c pytorch && \
    conda install -y -c https://conda.anaconda.org/menpo opencv3

RUN pip install --upgrade pip && \
    pip install geopandas missingno xgboost catboost lightgbm && \
    pyro-ppl && \
    conda clean -yt

# Update numpy
RUN pip3 --no-cache-dir install -U numpy==1.13.3

# Install Tensorflow
RUN pip3 install --upgrade tensorflow

# Keras
ARG KERAS_VERSION=2.1.4
ENV KERAS_BACKEND=tensorflow
RUN pip3 --no-cache-dir install --upgrade keras

WORKDIR /src
