#!/bin/bash
#编译打包

#-----------------------------------IOS-----------------------------------
#TeamId
export IOS_TEAM_ID=XXXXXXXXXX

#APPID
export IOS_APPID=xxxx@xx.xxx

#APPID_APP_PWD
export IOS_APPID_APP_PWD=xxxx-xxxx-xxxx-xxxx


#-----------------------------------ANDROID-----------------------------------
#签名文件
export APK_SIGNING_STORE_FILE="/xx/xx/xx/xx.jks"

#签名密码
export APK_SIGNING_KEY_PASSWORD=xxxxxx
export APK_SIGNING_KEY_ALIAS=xxxxxx
export APK_SIGNING_STORE_PASSWORD=xxxxxx

#编译为各个平台可执行程序
./build-platform.sh