#!/usr/bin/fish

function positionWindowName
        set windowName $argv[1]
        set posX $argv[2]
        set posY $argv[3]
        set sizeX $argv[4]
        set sizeY $argv[5]

        echo $argv

        for window in (xdotool search --onlyvisible -name $windowName)
                echo $window
                for line in (xdotool getwindowgeometry --shell $window)
                        set key (echo $line | cut -f 1 -d "=")
                        set value (echo $line | cut -f 2 -d "=")

                        if test "$key" = "WIDTH" -a "$value" -gt 20
                                echo xdotool windowsize $window $sizeX $sizeY
                                xdotool windowsize $window $sizeX $sizeY

                                echo xdotool windowmove $window $posX $posY
                                xdotool windowmove $window $posX $posY
                        end
                end
        end
end

function positionWindowClass
        set windowClass $argv[1]
        set posX $argv[2]
        set posY $argv[3]
        set sizeX $argv[4]
        set sizeY $argv[5]

        echo $argv

        for window in (xdotool search --onlyvisible -class $windowClass)
                echo $window
                for line in (xdotool getwindowgeometry --shell $window)
                        set key (echo $line | cut -f 1 -d "=")
                        set value (echo $line | cut -f 2 -d "=")

                        if test "$key" = "WIDTH" -a "$value" -gt 20
                                echo xdotool windowsize $window $sizeX $sizeY
                                xdotool windowsize $window $sizeX $sizeY

                                echo xdotool windowmove $window $posX $posY
                                xdotool windowmove $window $posX $posY
                        end
                end
        end
end


echo wait till discord is open
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

echo "Applying music stuff"
positionWindowClass Terminator 28 28 1864 996

echo "Applying chat stuff"
positionWindowClass discord 3860 50 1212 979
positionWindowClass TelegramDesktop 5094 578 406 480
positionWindowClass Corebird 5072 35 451 525

