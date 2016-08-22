
export LC_ALL="en_US.UTF-8"
fir_bulid
projectScheme="TestFir+Jenkins"
current_State="Release"
fir build_ipa ${WORKSPACE}/$projectScheme.xcworkspace  -w -S $projectScheme -C $current_State -p -V
