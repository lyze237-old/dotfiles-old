#!/usr/bin/fish

function _owlshell_dotnet
    # check if we have git installed
    command -v dotnet> /dev/null
    if test $status -ne 0
         return
    end   

    if test (find . -maxdepth 1 -name "*.csproj" | wc -l) -eq 0 -a (find . -maxdepth 1 -name "*.sln" | wc -l) -eq 0
        return
    end
    
    echo $blue""$normal 
end
