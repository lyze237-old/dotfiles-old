#/!usr/bin/fish

fish_vi_key_bindings

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

    # {{{ Source
    set curDir (dirname (status -f))
    source $curDir/promt/colors.fish
    source $curDir/promt/git.fish
    # }}}

    # {{{ Fish Prompt
    function fish_prompt
        
        # init
        set global_status $status
        set prompt ""

        # pwd
        set prompt $prompt(prompt_pwd)

        # git stuff
        set prompt $prompt (_owlshell_git)

        if test $global_status -ne 0
            printf "$prompt\n>v< "
        else
            printf "$prompt\n>v> "
        end
    end
    # }}}

# }}}
