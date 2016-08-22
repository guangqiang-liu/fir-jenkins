

#  Script.sh
#  LSBuyer
#
#  Created by Li Zhiyu on 16/6/27.
#  Copyright © 2016年 lianshang. All rights reserved.

#.mobileprovision
#-exportOptionsPlist exportPlist.plist
#<?xml version="1.0" encoding="UTF-8"?>
#<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
#<plist version="1.0">
#<dict>
#<key>teamID</key>
#<string>XP6MS9U2JD</string>
#<key>method</key>
#<string>app-store</string>  app-store, ad-hoc, enterprise, development
#<key>uploadSymbols</key>
#<true/>
#</dict>
#</plist>

##编译项目源码路径
WORK_DIR="/Users/guangqiang/Desktop/TestFir+Jenkins/"
#编译路径
BUILD_DIR="/Users/guangqiang/Desktop/auto_build"
APP_NAME="TestFir+Jenkins"
Target_name="TestFir+Jenkins"
archivePath=${BUILD_DIR}/${Target_name}.xcarchive
work_space=${WORK_DIR}/${APP_NAME}.xcworkspace
project_space=${WORK_DIR}/${APP_NAME}.xcodeproj
ipa_path=${BUILD_DIR}/${Target_name}.ipa
BUILD_LOG=${BUILD_DIR}/build_release.log
upload_log=${BUILD_DIR}/upload_log.log
PROVISIONING_PROFILE="a9b129a5-8359-418b-ac02-3d3ee50af243"
SIGN_IDENTITY="iPhone Developer: JUNHAO ZHAO (DVUEYJF46M)"
exportPlist=${BUILD_DIR}/exportPlist.plist


log_info() {
echo "`date +"%Y-%m-%d %H:%M:%S"` -- $*"
}

#xcodebuild -workspace Diaoser.xcodeproj/project.xcworkspace -scheme Diaoser  -configuration "Release" -arch "armv7 armv7s" -sdk iphoneos CODE_SIGN_IDENTITY="iPhone Distribution: Diao Ser" CONFIGURATION_BUILD_DIR='OUTPUT_DIRECTORY'

xcode_build(){
rm -rf ${archivePath}
rm -rf ${BUILD_LOG}

#/usr/local/bin/pod update --verbose

echo "1. 删除"${archivePath}+${BUILD_LOG}" ......."

xcodebuild -project  ${project_space} clean >> ${BUILD_LOG}

echo "2. clean Finish......."

cd ${WORK_DIR}

#pod update


echo "3. 开始编译......."
xcodebuild -workspace ${work_space}  -scheme ${Target_name} -configuration Debug -sdk iphoneos PROVISIONING_PROFILE="${PROVISIONING_PROFILE}" CODE_SIGN_IDENTITY="${SIGN_IDENTITY}" -archivePath ${archivePath} archive

echo "4. 编译完成......."




}

#上传ipa至蒲公英
upload_ipa(){

echo "7. 上传包至蒲公英-"+${ipa_path}+"......."
curl -F "file=@/${ipa_path}" -F "uKey=2d3fee8e91935ea1da4c2cfd25531f00" -F "_api_key=8ff7a20cc9f1340f3adc7ec1fa9ed204" http://www.pgyer.com/apiv1/app/upload >> ${upload_log}
echo "8. 上传包至蒲公英完成-"+${ipa_path}+"....... 下载安装路径:https://www.pgyer.com/fcGN"
}

xcode_archive(){
echo "5. 删除"+${ipa_path}+"......."

if [  -f "$ipa_path" ]; then
rm -rf ${ipa_path}
fi

#rm ${ipa_path} >> ${BUILD_LOG}
echo "6. 导出包-"+${ipa_path}+"......."
#

xcodebuild -exportArchive -archivePath ${archivePath} PROVISIONING_PROFILE="${PROVISIONING_PROFILE}" CODE_SIGN_IDENTITY="${SIGN_IDENTITY}" -exportOptionsPlist ${exportPlist} -exportPath ${BUILD_DIR}
echo "7. 导出包-"+${ipa_path}+"完成......."
}

execute() {

xcode_build

xcode_archive

upload_ipa

}


execute