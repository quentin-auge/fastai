#!/usr/bin/env bash

# Setup
pip install feedparser
python -m spacy download en

# https://forums.fast.ai/t/error-while-running-lesson-4-notebook/23872/3
pip install torch==0.4.1
conda install pytorch
