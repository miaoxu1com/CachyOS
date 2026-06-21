# CachyOS
## 系统信息

查看系统信息了解环境

## 系统配置

查看配置中心修改适合自己的配置

## 源切换工具
### ArachLinux源配置
```shell
kate /etc/pacman.conf
[archlinuxcn]
Server = https://mirrors.aliyun.com/archlinuxcn/$arch
SigLevel = Never
```
### paru安装

```shell
pacman -Sy paru
```
### chsrc安装

```shell
paru -S chsrc-bin
```

### 切换源

```shell
chsrc set python
chsrc set node
chsrc set rust
chsrc set java
```

### 软件中心安装

```shell
paru -Sy discover
paru -Sy spark
```


## 显卡驱动

## 快速跳转
```shell
mkdir -p ~/.config/fish/conf.d/ & kate z.fish

source (lua /home/mx/z.lua/z.lua --init fish once enhanced fzf | psub)
alias zc='z -c'      # 严格匹配当前路径的子路径
alias zz='z -i'      # 使用交互式选择模式
alias zf='z -I'      # 使用 fzf 对多个结果进行选择
alias zb='z -b'      # 快速回到父目录


# 添加cd模糊搜索目录的功能
kate ~/.config/fish/conf.d/ & kate z.fish

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


```


## 输入法
### Fcitx5-Rime框架安装
```shell
paru -Sy fcitx5-lotus
paru -S fcitx5-kde-kwin-settings

# 薄荷输入法
# 万象配置
支持声调
# 雾凇配置
# weasel.yaml、squirrel.yaml 是鼠须管和小狼毫前端配置，对fcitx5前端不起作用，fcitx5需要另外下载皮肤
paru -Sy fcitx5-im
paru -Sy fcitx5-rime
kcm-fcitx5
paru -Sy fcitx5-chinese-addons
paru -Sy fcitx5-config-qt

# 配置环境变量
kate ~/.pam_environment

GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx

kate /etc/environment

XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus

```
### 皮肤

```shell
# 微信皮肤
paru -Sy fcitx5-theme-wechat

# 苹果皮肤
paru -Sy fcitx5-theme-macos12
paru -Sy otf-apple-pingfang
paru -Sy otf-apple-pingfang-relaxed
paru otf-apple-pingfang-ui

# 薄荷同款皮肤
paru -Sy fcitx5-theme-mint

# Gruvbox皮肤
https://github.com/ayamir/fcitx5-gruvbox

# Ori皮肤
paru -Sy fcitx5-skin-ori-git

```

## 浏览器

```shell
paru -Sy brave-origin-bin

# 修改加速下载连接
kate /home/mx/.cache/paru/clone/brave-origin-nightly-bin/PKGBUILD
```

## 终端
### fish
#### 主题
```shell
# powerlinepk10 for fish
tide 
```
[draculatheme.com](http://github.com/dracula/dracula-theme)
[catppuccin](https://github.com/catppuccin/fish)

```shell
status list-files themes
fish_config theme list
# 设置主题到配置文件
~/.config/fish/config.fish
fish_config theme choose "dracula"
fish_config theme choose "catppuccin-frappe"
```
```shell
paru -S yazi-git ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick

```

### zsh
### 配色
[draculatheme.com](http://github.com/dracula/dracula-theme)
[catppuccin](https://github.com/catppuccin/fish)
## 桌面
kde plasame
