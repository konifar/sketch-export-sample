#!/bin/bash

destDir="$1"
shift

exportImages() {
    local srcFile="$1"
    local imagesDestDir = "$destDir/images"
    mkdir -p "$imagedestDir"
    sketchtool export slices "$srcFile" --output="$imagedestDir"

    (cd "$imagedestDir"; zip ../images.zip *)
    rm -r "$imagedestDir"
}

exportImages images.sketch
