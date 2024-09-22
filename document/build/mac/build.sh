#!/bin/bash

flutter clean
flutter build macos --release

#create-dmg https://github.com/create-dmg/create-dmg

#进入编译目录
cd $1/build/macos/Build/Products/Release
create-dmg \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon-size 100 \
  --icon "DairoDFS.app" 200 190 \
  --hide-extension "DairoDFS.app" \
  --app-drop-link 600 185 \
  "DairoDFS.dmg" \
  "DairoDFS.app/"