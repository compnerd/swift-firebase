# Ensures that we copy the right things into the build folder when we run
# Ideally this would be done with an SPM plugin, but they don't work on
# Windows yet, so here we are.
Write-Output "Copying Info.plist..."
Copy-Item Examples\FireBaseUI\Info.plist .build\debug\

Write-Output "Copying manifest..."
Copy-Item Examples\FireBaseUI\FireBaseUI.exe.manifest .build\debug\

Write-Output "Running application"
swift run -Xswiftc "-I${env:SDKROOT}\usr\lib\swift_static\windows"