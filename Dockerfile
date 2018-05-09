#   DESCRIPTION: Python3 Machine Learning development container
#   AUTHOR:     Erik Howard <erikhoward@protonmail.com>
#   COMMENT:    A Python3 machine learning development environment that contains many
#               popular machine learning, data science and computer vision packages
#   USAGE:
#
#       Interactive terminal
#       docker run --rm -it --name pydisco erikhoward/py3-disco /bin/bash
#
#       Jupyter notebook
#       docker run -rm \
#       -it -p 8888:8888 erikhoward/py3-disco \
#       -v $HOME/src/notebooks:/src/notebooks \
#	-w /src/notebooks \
#       /bin/bash -c "/opt/conda/bin/jupyter lab --ip='*' --port=8888 --no-browser --allow-root --LabApp.notebook_dir=/src/examples/notebooks"

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
    seaborn bokeh notebook nltk pip scipy && \
    conda install -y cython hdf5 pytables && \
    conda install -y -c conda-forge rtree wordcloud lightgbm jupyterlab && \
    conda install pytorch-cpu torchvision -c pytorch && \
    conda install -y -c https://conda.anaconda.org/menpo opencv3

RUN pip install --upgrade pip && \
    pip install geopandas missingno xgboost catboost lightgbm allennlp&& \
    pip install pyro-ppl && \
    conda clean -yt

# Update numpy
RUN pip --no-cache-dir install -U numpy==1.13.3

# Install Tensorflow
RUN pip install --upgrade tensorflow

# Keras
ARG KERAS_VERSION=2.1.4
ENV KERAS_BACKEND=tensorflow
RUN pip --no-cache-dir install --upgrade keras

# Download spaCy models
RUN python -m spacy download en \
    && python -m spacy download de \
    && python -m spacy download es \
    && python -m spacy download fr \
    && python -m spacy download it \
    && python -m spacy download nl

RUN mkdir -p /src/examples/notebooks
COPY notebooks /src/examples/notebooks

WORKDIR /src
