#!/bin/bash
flutter clean
flutter build ios --release


#1. 使用 xcodebuild 生成 .xcarchive
xcodebuild -workspace $1/ios/Runner.xcworkspace \
  -scheme Runner \
  -sdk iphoneos \
  -configuration Release \
  archive \
  -archivePath $1/build/ios/iphoneos/DairoDFS.xcarchive



#2. 使用 xcodebuild 导出 .ipa
#exportOptions.plist文件中的teamID获取方式
#执行指令security find-identity -p codesigning -v (该指令需要先安装xcode才能不执行)
#得到如下信息
#  1) 814544779C3DB11A0A0CF38452AF98A45165C8B9 "Apple Development: YourAppId (xxxx)"
#  2) 734635E5DBB88FAD4034A3F322FE4E3BF30BB160 "iPhone Distribution: YourName (xxxx)"
#     2 valid identities found
#因为我们当前编译的是IOS应用,所以iPhone Distribution: YouName (xxxx)中的xxxx部分就是你的teamID

#生成exportOptions.plist文件
cat <<EOF > $1/build/ios/iphoneos/exportOptions.plist
<?xml version="1.0" encoding="UTF-8"?>
 <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
 <plist version="1.0">
   <dict>
       <key>method</key>
       <string>app-store</string><!-- 或 ad-hoc, enterprise, development -->
       <key>teamID</key>
       <string>$IOS_TEAM_ID</string>
       <key>uploadSymbols</key>
       <true/>
       <key>compileBitcode</key>
       <true/>
   </dict>
 </plist>
EOF

#导出 .ipa
xcodebuild -exportArchive \
  -archivePath $1/build/ios/iphoneos/DairoDFS.xcarchive \
  -exportPath $1/build/ios/iphoneos \
  -exportOptionsPlist $1/build/ios/iphoneos/exportOptions.plist

#3. 使用 altool 上传 .ipa
#上传时使用的密码并不是appid登录密码,而是应用专用密码,如何生成应用专用密码,请参考以下步骤
#     如何获取应用专用密码：
#     1.登录 Apple ID 账户：https://account.apple.com/account/manage
#     前往 Apple ID 管理页面，并使用您的 Apple ID 和密码登录。

#     2.进入安全设置：
#     在安全部分，您会看到“生成应用专用密码”的选项。

#     3.生成密码：
#     点击该选项，按照提示生成一个新的应用专用密码。生成后，您可以在 xcrun altool 或其他需要访问您 Apple ID 的服务中使用该密码。
xcrun altool --upload-app -f $1/build/ios/iphoneos/DairoDFS.ipa -t ios -u $IOS_APPID -p $IOS_APPID_APP_PWD

#到此变异的ipa文件就被上传了Appstore,可在Connect应用查看状态,可能会有几分钟延迟
