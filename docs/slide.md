#
- iOSDC 2017 3/16, 17
- @konifar
- konifar's image

---
# How do you put the icons and images?
```
Designers
↓ (Sketch + Zeplin/raw image file)
Engineers
↓ (Manual/Script)
iOS/Android Repository
```

---
# Some problems
- Boring to communicate the images with the designer.
- Difficult to manage both Android and iOS icons by the designer.
- Bother to put the icons to Assets Catalog.
- Human error.

---
# Automatically export Sketch slices on CI
- https://github.com/konifar/sketch-export-sample

---
# Overview
```
Designers
↓ (Push Sketch file)
Design Repository
↓ (Automatically export slices by Sketch export)
↓ (Automatically create Assets catalogs)
↓ (Automatically send PR to both iOS and Android repository)
iOS/Android Repository
↑ (Just check PR)
Engineers
```

Demo

---
# 1. images.sketch
- Images.
- Naming rule (Point).
- Few members manages this.
- White color icons. (Point)

---
# 2. Automatically export slices
- https://www.sketchapp.com/tool/ (Point)
- `% sketchtool export slices images.sketch --output=out/images`
- Result images.

---
# 3. Automatically create Assets catalogs
- Code
- Ignore Android icons. (Point)

---
# 3. Automatically create Assets catalogs
- Assets catalog structure is easy
- File structure

---
# 4. Automatically send PR
- Send PR if there are changes.
- Delete doesn't support. (Point)
- Images

---
# Awesome

---
# But some problems happens
- Designers can not decide good icon name.
- Designers forget to slice.

---
# Other questions
- Which CI service is better?
=> Sketch tool depends on macos.
=> Graph.

- svg support.
=> See repository code.

- How to apply this way?
=> At first, create repository and put images.sketch.

---
# Thanks!
