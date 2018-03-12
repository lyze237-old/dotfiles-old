#!/usr/bin/fish

function _owlshell_dotnet
    # check if we have git installed
    command -v dotnet> /dev/null
    if test $status -ne 0
         return
    end   

    # check if we are in a project or in a solution directory
    if test (find . -maxdepth 1 -name "*.csproj" | wc -l) -gt 0
        set version (grep -oE '<RuntimeFrameworkVersion>(.*)<\/RuntimeFrameworkVersion>' *.csproj | sed -e 's/^<RuntimeFrameworkVersion>//g' -e 's/<\/RuntimeFrameworkVersion>$//g')
        echo $blue" "$version$normal
    else if test (find . -maxdepth 1 -name "*.sln" | wc -l) -gt 0
        echo $blue""$normal 
    end
end
