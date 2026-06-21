# =============================================================================
# Fish Shell 主配置文件
# =============================================================================

# ----- 加载系统级 Fish 配置 -----
source /usr/share/cachyos-fish-config/cachyos-config.fish

# 1. 将 brew 加入 PATH
set -gx PATH /home/linuxbrew/.linuxbrew/bin $PATH

# 2. 可选：使用 `brew shellenv` 进行更全面的环境设置
# 这行会设置 MANPATH、INFOPATH 等，但需要先确保 brew 在 PATH 中
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)


# ----- Homebrew 镜像配置（使用国内镜像加速）-----
# 注意：这需要 Homebrew 已经安装，但如果尚未安装 brew，请注释掉这些行
set -x HOMEBREW_BREW_GIT_REMOTE "https://mirrors.bfsu.edu.cn/git/homebrew/brew.git"
set -x HOMEBREW_CORE_GIT_REMOTE "https://mirrors.bfsu.edu.cn/git/homebrew/homebrew-core.git"
set -x HOMEBREW_API_DOMAIN      "https://mirrors.bfsu.edu.cn/homebrew-bottles/api"
set -x HOMEBREW_BOTTLE_DOMAIN   "https://mirrors.bfsu.edu.cn/homebrew-bottles"

# ----- Homebrew 初始化（在 PATH 设置之后）-----
# 使用绝对路径，避免 "未知的命令：brew" 错误
# Apple Silicon Mac: /opt/homebrew/bin/brew
# Intel Mac: /usr/local/bin/brew
if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
else if test -x /usr/local/bin/brew
    eval (/usr/local/bin/brew shellenv)
end

# ----- 其他自定义配置（可根据需要添加）-----
# 例如：zoxide 初始化
# zoxide init fish | source
