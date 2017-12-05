sleep 0.1
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

set fish_greeting ""

