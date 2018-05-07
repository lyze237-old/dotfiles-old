@REM Params: fromDir toDir (both without "!)
move /Y "%~2" "%~2_tmp"
mklink /J "%~2" "%~1"
xcopy /E /C /F /H /Y "%~2_tmp\*" "%~2"
rmdir /S /Q "%~2_tmp"