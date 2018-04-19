function dotdrop
    set dir (pwd)
    cd ~/.dotfiles/dotfiles-public
    if test -e secrets.env
        bash -c "cat secrets.env ; source secrets.env ; ./dotdrop.sh $argv"
    else
        ./dotdrop.sh $argv
    end
    cd $dir
end 
