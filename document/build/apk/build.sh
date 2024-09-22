#!/bin/bash
 flutter clean

# 在打包apk之前,请先修改一个配置
# /Users/zhoulq/.pub-cache/hosted/pub.dev/image_gallery_saver-2.0.3/android/build.gradle
# 将上面这个文件中的compileSdkVersion 30改为compileSdkVersion 31
# 因为这个依赖使用了旧版本的SDK编译,更新版本之后导致报错,后续image_gallery_saver依赖版本跟新之后可能会解决这个问题
# 暂时先强制修改依赖中的SDK版本号来解决这个问题
file="~/.pub-cache/hosted/pub.dev/image_gallery_saver-2.0.3/android/build.gradle"

# 使用 sed 替换字符串并写回文件
# linux环境请执行sed -i 's/compileSdkVersion 30/compileSdkVersion 31/g' $file
sed -i '' 's/compileSdkVersion 30/compileSdkVersion 31/g' $file

flutter build apk --release
