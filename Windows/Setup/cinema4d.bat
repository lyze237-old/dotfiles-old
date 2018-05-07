@echo "Cinema 4D"
@echo "1. Select the Cinema 4D directory (%APPDATA%\MAXON\CINEMA 4D<id>)"

"Windows\Tools\Dialogboxes\OpenFolderBox.exe" "%APPDATA%\MAXON" "Cinema 4D directory">.output.tmp
set /p Cinema4DPath=<.output.tmp

@if %ERRORLEVEL% NEQ 0 (
	@echo "User cancled dialog, aborting"
	@goto :eof
)

@echo "3. Applying library structure to %Cinema4DPath%\library"
CALL "Windows\Scripts\bat\LinkDirectory.bat" "Windows\Programs\Cinema4D\library\layout" "%Cinema4DPath%\library\layout"
CALL "Windows\Scripts\bat\LinkDirectory.bat" "Windows\Programs\Cinema4D\library\scripts" "%Cinema4DPath%\library\scripts"

@echo "3. Applying library structure to %Cinema4DPath%\plugins"
CALL "Windows\Scripts\bat\LinkDirectory.bat" "Windows\Programs\Cinema4D\plugins" "%Cinema4DPath%\plugins"

EXIT /B %ERRORLEVEL%

@REM Params: fromDir toDir (both without "!)
:createSymlink
move /Y "%~2" "%~2_tmp"
mklink /J "%~2" "%~1"
xcopy /E /C /F /H /Y "%~2_tmp\*" "%~2"
rmdir /S /Q "%~2_tmp"