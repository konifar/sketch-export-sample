# sketch-export-sample [![Build Status](https://travis-ci.org/konifar/sketch-export-sample.svg?branch=master)](https://travis-ci.org/konifar/sketch-export-sample)
This exports the icons in Sketch files to Android/iOS projects. [SpeakerDeck](https://speakerdeck.com/konifar/import-sketch-icons-to-assets-catalog-on-ci)
It makes the communication between the engineers and the desginers easier.

# Overview
![overview](docs/overview.png)

## 1. Push Sketch file to GitHub
- When the designer add or modify the icons, s/he pushes [Sketch file](https://github.com/konifar/sketch-export-sample/blob/master/images.sketch) to GitHubRepository.
- Sketch file has the images and icons which are used in Android/iOS app.
- Basically the icons' color is white. Simple icons are tinted programmatically.
- There is simple naming rule to export the image files automatically.

Type | Rule | Example
:--: | :--: | :--:
Image | img_{name} | img_quiz_result, img_tutorial_1
Icon | ic_{name}_{size} | ic_quiz_24, ic_star_48

- If the designer is not familiar with Git, [git-sketch-plugin](https://github.com/mathieudutour/git-sketch-plugin) might help. This tool provides `Git` menu and we can commit and push on Sketch. Plus, it generates the preview image file per Art board. We can check the image diff on Pull Request.

## 2. Export icons by Sketch tool
- [sketch tool](https://www.sketchapp.com/tool/) provides some command line tool for Sketch.

```shell
% sketchtool export slices images.sketch --output=out/images
Exported ic_todo_schedule_24.png
Exported ic_todo_schedule_24@1.5x.png
Exported ic_todo_schedule_24@2x.png
Exported ic_todo_schedule_24@3x.png
…
```

## 
