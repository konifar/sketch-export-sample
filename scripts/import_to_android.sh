#!/bin/bash -ue

# usage: import_to_android.sh

github_token=$GITHUB_TOKEN

readonly ROOT_DIR=$PWD
readonly RES_DIR='android/SketchExportSample/app/src/main/res'
readonly IMAGES_DIR="out/images"

readonly TMP_IMAGES_DIR="out/tmp_images_for_android"
readonly BLACKLIST_FILE = "scripts/android/blacklist"
readonly VECTOR_BLACKLIST_FILE = "scripts/android/vector_blacklist"

readonly BASE_BRANCH="master"
readonly COMPARE_BRANCH="import_android_images_to_$BASE_BRANCH"

function export_images() {
  mkdir $TMP_IMAGES_DIR
  cp -r $IMAGES_DIR $TMP_IMAGES_DIR

  sed -n '/^[^#]/s/.*/rm -f &.{png,svg,xml}; rm -f &@*.png/p' $BLACKLIST_FILE | (cd $TMP_IMAGES_DIR; /bin/bash -x)
  echo "Removed all files in blacklist."

  sed -n '/^[^#]/s/.*/rm -f &.xml/p' $BLACKLIST_FILE | (cd $TMP_IMAGES_DIR; /bin/bash -x)
  echo "Removed xml files in vector blacklist."

  find $TMP_IMAGES_DIR -name "img_*.xml" -type f -delete
  echo "Removed xml files which name has img_ prefix."

  # create_vector_drawables must be first to remove redundant PNGs
  create_vector_drawables $TMP_IMAGES_DIR "$RES_DIR/drawable"
  create_drawables $TMP_IMAGES_DIR "$RES_DIR/drawable-xxhdpi" "@3x" "png"
  create_drawables $TMP_IMAGES_DIR "$RES_DIR/drawable-xhdpi" "@2x" "png"
  create_drawables $TMP_IMAGES_DIR "$RES_DIR/drawable-hdpi" "@1.5x" "png"
  create_drawables $TMP_IMAGES_DIR "$RES_DIR/drawable-mdpi" "@1x" "png"
  create_drawables $TMP_IMAGES_DIR "$RES_DIR/drawable-mdpi" "" "png"
}


create_drawables() {
  local images_dir=$1
  local drawable_dir=$2
  local modifier=$3
  local ext=$4

  mkdir -p $drawable_dir

  for file in "$images_dir/"*$modifier.$ext ; do
    [[ -f $file ]] || continue
    dest_file=`basename $file`
    dest_file="$dest_file/$modifier/"
    expr $dest_file : "^[a-zA-Z_0-9]*\.$ext$" >& /dev/null || {
      echo "Illeagular file name: $file" >&2
      exit 1
    }
    mv $file "$drawable_dir/$dest_file"
  done
}

create_vector_drawables() {
  local -r images_dir=$1
  local -r drawable_dir=$2

  mkdir -p $drawable_dir

  for file in $images_dir/*.xml ; do
    [[ -f $file ]] || continue
    base_file=`basename $file.xml`
    # bundle exec vbw -v $file
    mv $file "$drawable_dir/vec_$base_file.xml"
    cat > "$drawable_dir/$base_file.xml" <<EOF
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@drawable/vec_$base_file"/>
</layer-list>
EOF
    rm -f "$images_dir/$base_file".png "${images_dir}/${base}"@*.png
  done
}

function send_pull_request() {
  git branch -D $COMPARE_BRANCH || true
  git checkout -b $COMPARE_BRANCH
  git add $RES_DIR

  if [[ -n "`git status --porcelain | grep $ASSETS_DIR`" ]]; then
    git commit -m "Import images from Sketch"
    git push -f "https://$github_token@github.com/konifar/sketch-export-sample.git" $COMPARE_BRANCH:$COMPARE_BRANCH
    curl -s -X POST -H "Authorization: token $github_token" -d @-
    https://api.github.com/repos/konifar/sketch-export-sample/pulls <<EOF
{
    "title":"Import images from Sketch",
    "head":"${COMPARE_BRANCH}",
    "base":"${BASE_BRANCH}"
}
EOF
    echo "Sent PullRequest."
  else
    echo "No changed files."
  fi
}

export_images
send_pull_request
