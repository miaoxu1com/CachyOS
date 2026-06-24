zoxide init fish | source
export FZF_DEFAULT_OPTS='
   --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
   --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
   --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
   --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
 '
# source (lua /home/mx/z.lua/z.lua --init fish once enhanced fzf | psub)
fish_config theme choose catppuccin-frappe

function zfp
    set dir (zoxide query -l | fzf --preview 'tree -L 2 {}')
    if test -n "$dir"
        z "$dir"
        ls -la
    end
end
# 不能替换cd，会覆盖cd原功能，函数需要时调用
function cdz --description "Change directory with fzf + fd (zoxide integration)"
    if test (count $argv) -eq 0
        set -l target_dir (
            zoxide query -l | \
            fzf --height 40% --reverse --border \
                --prompt="Select directory: " \
                --preview="tree -L 2 {}" \
                --preview-window=right:50%
        )

        if test -n "$target_dir"
            z "$target_dir"
            commandline -f repaint
            ls -la
        end
    else
        z $argv
    end
end

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	command yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
		builtin cd -- "$cwd"
	end
	command rm -f -- "$tmp"
end
