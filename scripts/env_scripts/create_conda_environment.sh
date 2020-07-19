#!/usr/bin/env bash

# (re)create conda env

ENV_NAME=geo_env
REQ_FILE=requirements.yml

if conda env list | grep $ENV_NAME; then
    echo "conda env $ENV_NAME already exists"
    echo "it will be deleted first"
    echo "deactivate"
    conda deactivate
    echo "conda remove -n $ENV_NAME --all --yes"
    conda remove -n $ENV_NAME --all --yes --force
fi

echo "let's re/create the environment with requirements.yml"
conda env create -f $REQ_FILE

touch .conda_env_created
