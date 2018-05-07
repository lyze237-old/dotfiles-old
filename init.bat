"Windows\Tools\Dialogboxes\MessageBox.exe" "Do you want to apply cinema 4d settings?" "Dotfiles" "YesNo" "Question">.output.tmp
set /p Question=<.output.tmp

if "%Question%" == "yes" (
	CALL "Windows\Setup\cinema4d.bat"
)


"Windows\Tools\Dialogboxes\MessageBox.exe" "Do you want to apply notepad++ settings?" "Dotfiles" "YesNo" "Question">.output.tmp
set /p Question=<.output.tmp

if "%Question%" == "yes" (
	CALL "Windows\Setup\notepad++.bat"
)

"Windows\Tools\Dialogboxes\MessageBox.exe" "Do you want to apply git settings?" "Dotfiles" "YesNo" "Question">.output.tmp
set /p Question=<.output.tmp

if "%Question%" == "yes" (
	CALL "Windows\Setup\git.bat"
)

"Windows\Tools\Dialogboxes\MessageBox.exe" "Do you want to apply better discord settings?" "Dotfiles" "YesNo" "Question">.output.tmp
set /p Question=<.output.tmp

if "%Question%" == "yes" (
	CALL "Windows\Setup\betterDiscord.bat"
)
