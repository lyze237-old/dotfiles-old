#!/usr/bin/fish

set maildir ~/.Mail/mailbox/


while true
    set index 1 
    for dir in (ls $maildir)
        set fulldir (echo $maildir$dir)
        set newdir (echo $fulldir/new)
        
        set newstatus[$index] (find $newdir -maxdepth 1 -type f | wc -l)
        echo set $dir newstatus[$index] to $newstatus[$index]
    
        set index (math $index + 1)
    end
    
    offlineimap
    
    set index 1 
    set found 0
    for dir in (ls $maildir)
        set fulldir (echo $maildir$dir)
        set newdir (echo $fulldir/new)
        
        set newstatusafter[$index] (find $newdir -maxdepth 1 -type f | wc -l)
        echo set $dir newstatusafter[$index] to $newstatus[$index]
    
        set state (math $newstatusafter[$index] - $newstatus[$index])
    
        if test $state -eq 1 
            set found 1
            echo $result Got $state new mail in $dir\<br\>
            set result (echo $result Got $state new mail in $dir\<br\>)
        else if test $state -gt 1
            set found 1
            echo $result Got $state new mails in $dir\<br\>
            set result (echo $result Got $state new mails in $dir\<br\>)
        end
    
        set index (math $index + 1)
    end
    
    if test $found -eq 1
        echo $result
        notify-send "Mutt" "$result"
    end
    
    sleep 60
end
