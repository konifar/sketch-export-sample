#!/bin/bash

dest_dir="$1"
file_name="$2"

sketchtool=./sketchtool/bin/sketchtool

${sketchtool} export slices "$file_name" --output="$dest_dir"
${sketchtool} export slices "$file_name" --formats="svg" --output="$dest_dir"
${sketchtool} export slices "$file_name" --formats="pdf" --output="$dest_dir"
