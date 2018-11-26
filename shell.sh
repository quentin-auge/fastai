#!/usr/bin/env bash

# Local setup
mkvirtualenv fastai --python=python3.7
pip install jupyter
ipython kernel install --user --name=fastai
cd ~/dl/fastai/
pip install -e .
pip install bcolz opencv-python seaborn graphviz sklearn_pandas isoweek pandas_summary torchtext


# Remote setup
gcloud compute ssh jupyter@fastai-vm
cd ~/tutorials/
rm -rf fastai/
# From local
#gcloud compute scp ~/.ssh/{config,id_rsa,id_rsa.pub} jupyter@fastai-vm:~/.ssh/
git config --global user.name "Quentin Augé"
git config --global user.email 'quentin.auge@gmail.com'
git clone https://github.com/quentin-auge/fastai
cd fastai/
git remote add upstream https://github.com/fastai/fastai.git
pip install graphviz sklearn_pandas isoweek pandas_summary torchtext


# Local
cd ~/dl/fastai/courses/dl1/
jupyter notebook

# SSH tunneling
gcloud compute ssh jupyter@fastai-vm -- -L 8080:localhost:8080

# SSH
gcloud compute ssh jupyter@fastai-vm
cd ~/tutorials/fastai/courses/dl1/
