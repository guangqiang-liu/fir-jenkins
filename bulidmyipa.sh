export LC_ALL="en_US.UTF-8"
fir_bulid
projectScheme="TestFir+Jenkins"
current_State="Release"
fir build_ipa ${WORKSPACE}/$projectScheme.xcworkspace  -w -S $projectScheme -C $current_State -p -V

security -v list-keychains -s "$KEYCHAIN" "$HOME/Library/Keychains/login.keychain"
security list-keychains # so we can verify that it was added if it fails again
security -v unlock-keychain -p "密码" "<span style="font-family: Arial, Helvetica, sans-serif;">$HOME/Library/Keychains/login.keychain</span><span style="font-family: Arial, Helvetica, sans-serif;">"</span>
codesign --sign "$SIGNER_IDENTITY" --force --signature-size 9600 \
--resource-rules src/AppResourceRules.plist --timestamp --verbose \
"$APP"