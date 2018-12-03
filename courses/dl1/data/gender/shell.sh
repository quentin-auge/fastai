#!/usr/bin/env bash

# Download gender data

gcloud compute ssh jupyter@fastai-vm
cd ~/tutorials/fastai/courses/dl1/
mkdir -p data/gender/
cd data/
wget https://data.vision.ee.ethz.ch/cvl/rrothe/imdb-wiki/static/imdb_meta.tar
tar xvf imdb_meta.tar
wget https://data.vision.ee.ethz.ch/cvl/rrothe/imdb-wiki/static/imdb_0.tar
wget https://data.vision.ee.ethz.ch/cvl/rrothe/imdb-wiki/static/imdb_2.tar
tar xvf imdb_0.tar
tar xvf imdb_1.tar
cd gender/
mv 0{0,1,2,3,4,5,6,7,8,9}/ train/
mv 1{0,1,2,3,4,5,6,7,8,9}/ train/
mkdir -p sample/00/
cp train/00/nm0000100_* sample/00/
mkdir -p sample/07/
cp train/07/nm0000107_* sample/07/


# Resizing

# Local

cd ~/dl/fastai/courses/dl1/data/gender/sample/

# Look at images size
for f in ./*/*.jpg; do
  convert "$f" -print "%wx%h\n" /dev/null
done | sort -n

mkdir -p resized/0{0,7}/
for f in ./*/*.jpg; do
  echo "$f"
  convert "$f" -resize 224x224^ "./resized/$f"
done

# Remote

gcloud compute ssh jupyter@fastai-vm

cd ~/tutorials/fastai/courses/dl1/data/gender/train/

mkdir -p resized/0{0,1,2,3,4,5,6,7,8,9}/
mkdir -p resized/1{0,1,2,3,4,5,6,7,8,9}/
for f in ./*/*.jpg; do
  echo "$f"
  convert "$f" -resize 224x224^ "./resized/$f"
done


# Apply validation blacklist

# Local
cd ~/dl/fastai/courses/dl1/data/gender/train/resized/

# Remote
cd ~/tutorials/fastai/courses/dl1/data/gender/train/resized/

mv 06/ old_06/
mv 07/ old_07/
mkdir 0{6,7}/

for f in $(cat ../../whitelist_paths_06.txt); do
  cp -v "old_$f" "$f"
done


for f in $(cat ../../whitelist_paths_07.txt); do
  cp -v "old_$f" "$f"
done
