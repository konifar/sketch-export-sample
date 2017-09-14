#!/bin/bash

readonly vector_blacklist_file="scripts/android/vector_blacklist"
readonly vdtool="scripts/android/vd-tool/bin/vd-tool"
readonly IMAGES_DIR="out/images"

local svg_file=
local -r log_file="tmp.log"

while read svg_file; do
  $vdtool -c -in $svg_file 3>&2 2>&1 1>&3 | tee $log_file | grep "^ERROR@ " && (basename $svg_file | sed 's/\.svg$//' >> $vector_blacklist_file)
  cat $log_file # print all logs
  rm $log_file
done < <(find $IMAGES_DIR -name "*.svg")
