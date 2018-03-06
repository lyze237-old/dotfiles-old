#!/usr/bin/fish

function _owlshell_git
    # check if we have git installed
    command -v git > /dev/null
    if test $status -ne 0
         return
    end

    # fetch infos about the git repo
    set -l index (command git status --porcelain -b 2> /dev/null)
    # if we are not in a git repo, abort
    if test $status -ne 0
        return
    end

    # print branch name
    set branch (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
    printf "$cyan $branch $normal"

    # branch is ahead
    if echo $index\n | command grep -E '^## .* \[.*ahead' > /dev/null
        set isAhead true
    end

    # branch is behind
    if echo $index\n | command grep -E '^## .* \[.*behind' > /dev/null
        set isBehind true
    end

    if test -n "$isAhead" -a "$isBehind"
        set eyeLeft "<"
        set beak "v"
        set eyeRight ">"
        printf '<v>'
    else if test -n "$isAhead"
        set eyeLeft ">"
        set beak "v"
        set eyeRight ">"
    else if test -n "$isBehind"
        set eyeLeft "<"
        set beak "v"
        set eyeRight "<"
    else
        set eyeLeft "^"
        set beak "v"
        set eyeRight "^"
    end

    printf "$yellow$eyeLeft$normal$beak$yellow$eyeRight$normal"

    set state ""
    # untracked files
    if echo $index\n | command grep -E '^ \?\? ' > /dev/null
        set state $state"?"
    end

    # staged (git add)
    if echo $index\n | command grep -E '^ A[ MDAU] ' > /dev/null
        set state $state"+"
    else if echo $index\n | command grep -E '^ UA' > /dev/null
        set state $state"+"
    end

    # modified
    if echo $index\n | command grep -E '^ M[ MD] ' > /dev/null
        set state $state"!"
    else if echo $index\n | command grep -E '^ [MARC]M ' > /dev/null
        set state $state"!"
    end

    # renamed
    if echo $index\n | command grep -E '^ R[ MD] ' > /dev/null
        set state $state"»"
    end

    # deleted
    if echo $index\n | command grep -E '^ [MARCDU ]D ' > /dev/null
        set state $state"x"
    else if echo $index\n | command grep -E '^ D[ UM] ' > /dev/null
        set state $state"x"
    end

    # stashes
    if command git rev-parse --verify refs/stash 2> /dev/null
        set state $state"\$"
    end

    # unmerged
    if echo $index\n | command grep -E '^ U[UDA] ' > /dev/null
        set state $state"="
    else if echo $index\n | command grep -E '^ AA ' > /dev/null
        set state $state"="
    else if echo $index\n | command grep -E '^ DD ' > /dev/null
        set state $state"="
    else if echo $index\n | command grep -E '^ [DA]U ' > /dev/null
        set state $state"="
    end    

    if test -n "$state"
        printf "$cyan/$red\"$cyan/$purple%s$normal" "$state"
    end
end
