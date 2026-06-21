zoxide init fish | source
# source (lua /home/mx/z.lua/z.lua --init fish once enhanced fzf | psub)
fish_config theme choose catppuccin-frappe
alias zc='z -c'      # 严格匹配当前路径的子路径
alias zz='z -i'      # 使用交互式选择模式
alias zf='z -I'      # 使用 fzf 对多个结果进行选择
alias zb='z -b'      # 快速回到父目录

function cd --description "Change directory with fzf + fd"
    if test (count $argv) -eq 0
        set -l target_dir (
            fd --type d --hidden --exclude .git . 2>/dev/null | \
            fzf --height 40% --reverse --border \
                --prompt="Select directory: " \
                --preview="ls -la {} | head -20" \
                --preview-window=right:50%
        )

        if test -n "$target_dir"
            builtin cd "$target_dir"
            commandline -f repaint
        end
    else
        builtin cd $argv
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
