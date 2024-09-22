#!/bin/bash
#编译打包

projectRoot=$(pwd)/../..

#打包APK
./apk/build.sh
mv $projectRoot/build/app/outputs/flutter-apk/app-release.apk DairoDFS.apk

#打包dmg
./mac/build.sh $projectRoot
mv $projectRoot/build/macos/Build/Products/Release/DairoDFS.dmg DairoDFS.dmg

#打包IOS
./ios/build.sh  $projectRoot
mv $projectRoot/build/ios/iphoneos/DairoDFS.ipa DairoDFS.ipa