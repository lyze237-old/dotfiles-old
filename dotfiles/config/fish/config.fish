#/!usr/bin/fish

sleep 0.1
# {{{ Weather Function 
function weather
    set cols (tput cols)
    set lines (tput lines)
    if test "$cols" -gt 125
    	if test "$lines" -gt 40
    		cat "$HOME/.cache/fish/weather"
            else if test "$lines" -gt 18
                    cat "$HOME/.cache/fish/weather?1"
            end
    else if test "$cols" -gt 63
    	if test "$lines" -gt 40
    		cat "$HOME/.cache/fish/weather?n"
    	else if test "$lines" -gt 18
    		cat "$HOME/.cache/fish/weather?n1"
    	end
    else if test "$cols" -gt 30
    	cat "$HOME/.cache/fish/weather?0"
    end
end
# }}} 

# {{{ Fish Greeting
#set fish_greeting (weather)
set fish_greeting ""
# }}}




# {{{ Fish Prompt

    # {{{ Colors
    set -l normal (set_color normal)
    set -l cyan (set_color cyan)
    set -l yellow (set_color yellow)
    set -l bpurple (set_color -o purple)
    set -l bred (set_color -o red)
    set -l bcyan (set_color -o cyan)
    set -l bwhite (set_color -o white)
    # }}}

    # {{{ Git Stuff
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
            ;
        case '* 0' # ahead of upstream
            echo "[>]"
        case '0 *' # behind upstream
            echo "[<]"
        case '*' # diverged from upstream
            echo "[<>]"
      end
    end
    # }}}


    # {{{ Fish Prompt
    function fish_prompt

        set global_status (echo $status)
        set prompt ""

        # git stuff
        set -l branch (_git_branch_name)
        set -l ahead (_git_ahead)
        if test -n "$branch"
            set prompt (echo $prompt  $branch $ahead)
        end

        if test $global_status -ne 0
            set prompt (echo $prompt ">v< ")
        else
            set prompt (echo $prompt "ovo ")
        end

        echo $prompt
    end
    # }}}

# }}}
