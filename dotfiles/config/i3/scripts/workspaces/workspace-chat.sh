#!/usr/bin/fish

function applyWindowLayout
	for window in (xdotool search --onlyvisible -class $argv)
		echo $window
		for line in (xdotool getwindowgeometry --shell $window)
			set key (echo $line | cut -f 1 -d "=")
			set value (echo $line | cut -f 2 -d "=")

			if test "$key" = "WIDTH" -a "$value" -gt 20
				echo Hide/Unhide window $window
				xdotool windowunmap $window
				xdotool windowmap $window
			end
		end
	end
end

# wait till actual discord window is open
set found 0
while test "$found" -eq 0
	for window in (xdotool search --onlyvisible -class discord)
	         echo $window
	         for line in (xdotool getwindowgeometry --shell $window)
	                set key (echo $line | cut -f 1 -d "=")
	                set value (echo $line | cut -f 2 -d "=")

	                if test "$key" = "WIDTH" -a "$value" -gt 350
	                        echo Found actual discord window with id $window
				set found 1
	                end
	        end
	end
	sleep 0.1
end


i3-msg 'workspace "3 "; append_layout ~/.config/i3/scripts/workspaces/workspace-chat.json'

applyWindowLayout discord
applyWindowLayout TelegramDesktop
applyWindowLayout Corebird

