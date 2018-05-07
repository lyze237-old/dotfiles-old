@echo "Notepad++"

@echo "1. Applying theme structure to %APPDATA%\Notepad++\themes"

CALL "Windows\Scripts\bat\LinkDirectory.bat" "Windows\Programs\Notepad++\themes" "%APPDATA%\Notepad++\themes"

EXIT /B %ERRORLEVEL%