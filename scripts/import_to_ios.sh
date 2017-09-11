#!/bin/bash -ue

# usage: import_to_ios.sh ${GITHUB_TOKEN}

github_token="$1"

root_dir=$PWD
images_asssets_dir="ios/SketchExportSample/SketchExportSample/Assets.xcassets"
images_dir="out/images"

base_branch='master'
branch_name="import_ios_images_to_${base_branch}"

function exportImages() {
  find "$images_dir" -name '*_android*.png' -type f -delete
  echo "Removed files which are used in only Android app"

  cd "$images_dir"

  for file in *.png *@2x.png *@3x.png ; do
    if [[ $file == *"@"* ]] ; then
      filename=${file%%@*}
    else
      filename=${file%%.*}
    fi

    imageset_dir="$root_dir"/"$images_asssets_dir"/"$filename".imageset

    mkdir -p "$imageset_dir"
    cp "$file" "$imageset_dir"/"$file"

    echo "${imageset_dir}/$file"

    createContentsJson "$filename" "$imageset_dir"
  done

  echo "Created assets"
}

function createContentsJson() {
  filename="$1"
  imageset_dir="$2"
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


function sendPullRequest() {
  cd $root_dir

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


# exportImages
sendPullRequest
