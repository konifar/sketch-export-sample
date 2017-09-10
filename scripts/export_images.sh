#!/bin/bash

destDir="$1"
shift

sketchtool=./sketchtool/bin/sketchtool

exportImages() {
    local srcFile="$1"
    local imagesDestDir="$destDir/images"
     mkdir -p "$imagesDestDir"
    ${sketchtool} export slices "$srcFile" --output="$imagesDestDir"

    (cd "$imagesDestDir"; zip ../images.zip *)
    rm -r "$imagesDestDir"
}

exportImages images.sketch
