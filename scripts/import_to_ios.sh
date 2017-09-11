#!/bin/bash -ue

# usage: import_to_ios.sh ${GITHUB_TOKEN}

github_token="$1"

root_dir=$PWD

images_asssets_dir="ios/SketchExportSample/SketchExportSample/Assets.xcassets"

tmp_images_dir="import_images"
tmp_images_asssets_dir="$tmp_images_dir"/"Assets.xcassets"
tmp_app_icon_dir="import_app_icon"
tmp_app_icon_asssets_dir="$tmp_app_icon_dir"/"Assets.xcassets"

images_dir="out/images"

base_branch='master'
branch_name="import_ios_images_to_${base_branch}"

function exportImages() {
  # find "$images_dir" -name '*_android*.png' -type f -delete
  # echo "Removed files which are used in only Android app"

  cd "$images_dir"

  for file in *@2x.png *@3x.png ; do
    if [[ $file == *"@"* ]] ; then
      fname=${file%%@*}
    else
      fname=${file%%.*}
    fi

    images_assets_dir="$tmp_images_asssets_dir"/"$fname".imageset

    mkdir -p "$images_assets_dir"
    cp "$file" "$images_assets_dir"/"$file"

    createContentsJson "$fname" "$images_assets_dir"
  done
  echo "Created assets"

  cd $root_dir
  mkdir -p "$tmp_app_icon_dir"
  cp -R "$images_asssets_dir"/"AppIcon.appiconset" "${tmp_app_icon_dir}"/
  echo "Copied app icon"
}

function createContentsJson() {
  filename="$1"
  icon_assets_dir="$2"
  cat <<EOF > "$icon_assets_dir"/Contents.json
{
  "images" : [
    {
      "idiom" : "universal",
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


function replaceAssets() {
  # rm -rf "$images_asssets_dir"
  # mv "$tmp_app_icon_asssets_dir" ../
  # mv "$tmp_images_asssets_dir" ../
  echo "Replaced assets"
}


function deleteDirs() {
  # rm -rf ./"$tmp_images_dir"
  # rm -rf ./"$tmp_app_icon_dir"
  # rm -rf "$images_dir"
  echo "Removed dirs and files"
}


function sendPullRequest() {
  git branch -D "${branch_name}" || true
  git checkout -b "${branch_name}"
  git add $images_asssets_dir

  if [[ -z "$github_token" ]] ; then
    echo "github token is not set"
    exit 1
  fi

  if [[ -n "`git status --porcelain | grep ${images_asssets_dir}`" ]]; then
    git commit -m "Import images from Sketch"
    git push -f origin $branch_name
    curl -s -X POST -H "Authorization: token $github_token" -d @- https://api.github.com/repos/konifar/sketch-export-sample/pulls <<EOF
{
    "title":"Import images from Sketch",
    "head":"${branch_name}",
    "base":"${base_branch}"
}
EOF
    echo "Sent PullRequest"
  else
    echo "No changed files"
  fi
}


exportImages
replaceAssets
deleteDirs
sendPullRequest
