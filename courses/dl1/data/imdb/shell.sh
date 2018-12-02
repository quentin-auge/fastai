#!/usr/bin/env bash

# Download imdb data

gcloud compute ssh jupyter@fastai-vm
cd ~/tutorials/fastai/courses/dl1/
mkdir -p data/
cd data/
wget https://data.vision.ee.ethz.ch/cvl/rrothe/imdb-wiki/static/imdb_0.tar
tar xvf imdb_0.tar
wget https://data.vision.ee.ethz.ch/cvl/rrothe/imdb-wiki/static/imdb_meta.tar
tar xvf imdb_meta.tar
cd imdb/
mv 0{0,1,2,3,4,5,6,7}/ train/
mv 0{8,9}/ test/
mkdir -p sample/train/00/
cp train/00/nm0000100_* sample/train/00/
mkdir -p sample/train/07/
cp train/07/nm0000107_* sample/train/07/
mkdir -p sample/test/09/
cp test/09/nm0000009_* sample/test/09/


# Resizing

# Local

cd ~/dl/fastai/courses/dl1/data/imdb/sample/train/

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

cd ~/tutorials/fastai/courses/dl1/data/imdb/train/

mkdir -p resized/0{0,1,2,3,4,5,6,7}/
for f in ./*/*.jpg; do
  echo "$f"
  convert "$f" -resize 224x224^ "./resized/$f"
done


# Apply validation blacklist

# Local
cd ~/dl/fastai/courses/dl1/data/imdb/train/resized/

# Remote
cd ~/tutorials/fastai/courses/dl1/data/imdb/train/resized/

mv 06/ old_06/
mv 07/ old_07/
mkdir 0{6,7}/

for f in $(cat ../../whitelist_paths_06.txt); do
  cp -v "old_$f" "$f"
done


for f in $(cat ../../whitelist_paths_07.txt); do
  cp -v "old_$f" "$f"
done
