function dotdrop
    set dir (pwd)
    cd /home/lyze/.dotfiles/dotfiles-public
    if test -e secrets.env
        posix-source secrets.env
    end
    ./dotdrop.sh $argv
    cd $dir
end 
