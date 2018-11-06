function passsearch
    if test -d $argv
        echo Please provide a string to search for
        exit -1
    end

    for file in ~/.password-store/**/*.gpg
        set passFile (echo $file | sed "s:^$HOME/.password-store/::"| sed 's:.gpg$::')
        set grepOutput (pass $passFile | grep $argv)
        if test $status -eq 0
            echo "$passFile"
            echo "$grepOutput"
            echo ""
        end
    end
end
