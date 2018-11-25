#!/usr/bin/env bash

# Download dogscats data

gcloud compute ssh jupyter@fastai-vm
cd ~/tutorials/fastai/courses/dl1/
mkdir -p data/
cd data/
wget http://files.fast.ai/data/dogscats.zip
unzip dogscats.zip
