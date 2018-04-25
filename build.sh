#!/bin/bash

set -ex

#docker hub username
IMAGEPREFIX=erikhoward

#image name
IMAGE=py3-disco

docker build -t $IMAGEPREFIX/$IMAGE:latest .
