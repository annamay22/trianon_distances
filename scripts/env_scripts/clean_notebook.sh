#!/bin/bash

notebooks_file="$1"
markdown_file="${notebooks_file%.ipynb}.md"
markdown_folder="${notebooks_file%.ipynb}_files"

echo "convert to markdown $markdown_file"
jupyter nbconvert --to  "markdown" "$notebooks_file"

echo "clean cells"
jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace "$notebooks_file"

echo "now you can commit:"
echo "$notebooks_file"
echo "$markdown_file"
echo "$markdown_folder"