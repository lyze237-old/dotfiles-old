#/!usr/bin/fish

if test (tty) = "/dev/tty1"
    startx
end

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

    # {{{ Source
    set curDir (dirname (status -f))
    source $curDir/prompt/colors.fish
    source $curDir/prompt/git.fish
    # }}}

    # {{{ Fish Prompt
    function fish_prompt
        if test $status -ne 0
            echo (prompt_pwd) ">v< "
        else
            echo (prompt_pwd) "ovo "
        end
    end
    # }}}

    # {{{
    function fish_right_prompt
        # init
        set prompt ""

        # git stuff
        set prompt $prompt (_owlshell_git)
        printf "$prompt"
    end
    # }}}

# }}}
