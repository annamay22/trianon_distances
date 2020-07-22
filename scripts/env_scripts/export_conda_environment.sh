#!/usr/bin/env bash

conda env export -n geo_env --no-builds > requirements.yml
