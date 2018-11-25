#!/usr/bin/env bash

# Download imdb data

gcloud compute ssh jupyter@fastai-vm
cd ~/tutorials/fastai/courses/dl1/
mkdir -p data/
cd data/
wget https://data.vision.ee.ethz.ch/cvl/rrothe/imdb-wiki/static/imdb_0.tar
tar xvf imdb_0.tar
cd imdb/
mv 0{1,2,3,4,5,6,7}/ train/
mv 0{8,9}/ test/
mkdir -p sample/train/00/
cp train/00/nm0000100_* sample/train/00/
mkdir -p sample/train/07/
cp train/07/nm0000107_* sample/train/07/
mkdir -p sample/test/09/
cp test/09/nm0000009_* sample/test/09/
