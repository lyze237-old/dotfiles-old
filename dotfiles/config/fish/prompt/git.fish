#!/usr/bin/fish

function _git_branch_name -d "Display current branch name"
    echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end 

function _git_ahead -d "git repository is ahead or behind origin"
    set -l commits (command git rev-list --left-right '@{upstream}...HEAD' ^/dev/null)
    
    if [ $status != 0 ] 
        return
    end 

    set -l behind (count (for arg in $commits; echo $arg; end | grep '^<'))
    set -l ahead (count (for arg in $commits; echo $arg; end | grep -v '^<'))
        
    switch "$ahead $behind"
        case '' # no upstream
            ;   
        case '0 0' # equal to upstream
            echo "[^v^]"
        case '* 0' # ahead of upstream
            echo "[>v>]"
        case '0 *' # behind upstream
            echo "[<v<]"
        case '*' # diverged from upstream
            echo "[<v>]"
    end 
end 


function _owlshell_git
    command -v git > /dev/null
    if test $status -ne 0
         return
    end
    
    set -l branch (_git_branch_name)
    set -l ahead (_git_ahead)
    if test -n "$branch"
        echo $prompt  $branch $ahead
    end
end
