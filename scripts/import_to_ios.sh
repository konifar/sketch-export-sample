#!/bin/bash -ue

# usage: import_to_ios.sh

github_token=$GITHUB_TOKEN

readonly ROOT_DIR=$PWD
readonly ASSETS_DIR="ios/SketchExportSample/SketchExportSample/Assets.xcassets"
readonly IMAGES_DIR="out/images"

readonly BASE_BRANCH="master"
readonly COMPARE_BRANCH="import_ios_images_to_$BASE_BRANCH"

function export_images() {
  cd $IMAGES_DIR

  for file in *.png *@2x.png *@3x.png ; do
    if [[ $file == *"@"* ]] ; then
      local filename=${file%%@*}
    else
      local filename=${file%%.*}
    fi

    if [[ $filename == *"_android" ]]; then
      echo "Skipped $filename because it's only for Android."
      continue
    fi

    local imageset_dir="$ROOT_DIR/$ASSETS_DIR/$filename".imageset
    mkdir -p $imageset_dir
    cp $file "$imageset_dir/$file"

    create_contents_json $filename $imageset_dir

    echo "Exported $file"
  done

  echo "Exported all images."
}

function create_contents_json() {
  local filename=$1
  local imageset_dir=$2
  cat <<EOF > "$imageset_dir"/Contents.json
{
  "images" : [
    {
      "idiom" : "universal",
      "filename" : "$filename.png",
      "scale" : "1x"
    },
    {
      "idiom" : "universal",
      "filename" : "$filename@2x.png",
      "scale" : "2x"
    },
    {
      "idiom" : "universal",
      "filename" : "$filename@3x.png",
      "scale" : "3x"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}
EOF
}

function send_pull_request() {
  cd $ROOT_DIR

  git config user.email "example@example.com"
  git config user.name "Travis-CI"

  git branch -D $COMPARE_BRANCH || true
  git checkout -b $COMPARE_BRANCH
  git add $ASSETS_DIR

  if [[ -z $github_token ]] ; then
    echo "github token is not set."
    exit 1
  fi

  if [[ -n "`git status --porcelain | grep $ASSETS_DIR`" ]]; then
    git commit -m "Import images from Sketch"
    git push -f "https://$github_token@github.com/konifar/sketch-export-sample.git" $COMPARE_BRANCH:$COMPARE_BRANCH
    curl -s -X POST -H "Authorization: token $github_token" -d @- https://api.github.com/repos/konifar/sketch-export-sample/pulls <<EOF
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
