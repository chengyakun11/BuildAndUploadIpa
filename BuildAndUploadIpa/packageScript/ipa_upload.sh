#!/bin/sh
#

#出现过 can't find device 的错误，使用 rvm system 解决掉了
#rvm system

#ipaPath="/Users/apple/Desktop/new_fuck_source/iOS/trunk/XingChangTong/build/ipa-build/新昌通__2.2.6_Release_15_20161011.ipa"
ipaPath=$1


echo $ipaPath

appleid=""
applepassword=""


###################################
#发布到iTunesConnect
###################################

altoolPath="/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"

#validate
"$altoolPath" --validate-app -f "$ipaPath" -u "$appleid" -p "$applepassword" -t ios --output-format xml
osascript -e 'display notification "Release To AppStore" with title "Validate Complete!"'

#upload
"$altoolPath" --upload-app -f "$ipaPath" -u "$appleid" -p "$applepassword" -t ios --output-format xml
osascript -e 'display notification "Release To AppStore" with title "Upload Complete!"'
