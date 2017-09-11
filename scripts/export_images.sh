#!/bin/bash

destDir="$1"

sketchtool=./sketchtool/bin/sketchtool

exportImages() {
    local srcFile="$1"
    ${sketchtool} export slices "$srcFile" --output="$destDir"
}

exportImages images.sketch
