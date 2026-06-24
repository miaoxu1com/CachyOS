# Arch Linux / CachyOS 系统配置指南

## 目录

- [系统信息](#系统信息)
- [系统配置](#系统配置)
- [源切换工具](#源切换工具)
  - [GitHub 源配置](#github-源配置)
  - [Arch Linux 源配置](#archlinux-源配置)
  - [Paru 安装](#paru-安装)
  - [Chsrc 安装](#chsrc-安装)
  - [切换源](#切换源)
  - [软件中心安装](#软件中心安装)
- [显卡驱动](#显卡驱动)
- [快速跳转](#快速跳转)
  - [z.lua (已废弃)](#zlua-已废弃)
  - [cd + fzf + fd 组合](#cd--fzf--fd-组合)
  - [Zoxide](#zoxide)
- [输入法](#输入法)
  - [Fcitx5-Rime 框架安装](#fcitx5-rime-框架安装)
  - [皮肤](#皮肤)
- [编辑器](#编辑器)
  - [Kate 特性](#kate-特性)
- [浏览器](#浏览器)
- [终端](#终端)
  - [Fish](#fish)
    - [主题](#主题)
  - [Ghostty](#ghostty)
    - [自带分屏](#自带分屏)
    - [配置文件可视化编辑](#配置文件可视化编辑)
    - [命令](#命令)
    - [DotFile](#dotfile)
    - [配色](#配色)
- [KDE 系统设置](#kde-系统设置)
  - [字体](#字体)
  - [快速设置](#快速设置)
  - [全局搜索工具](#全局搜索工具)
  - [键盘](#键盘)
  - [默认应用程序](#默认应用程序)
  - [文件关联](#文件关联)
- [终端文件管理](#终端文件管理)
  - [特性](#特性)
  - [配置文件](#配置文件)
- [桌面](#桌面)

---

## 系统信息

查看系统信息了解环境

## 系统配置

查看配置中心修改适合自己的配置

## 源切换工具

### github源配置
```shell
git config --global  url.https://gh.jasonzeng.dev/https://github.com/.insteadOf "https://github.com/"
git config --global protocol.https.allow always
```

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

### 多系统引导修复
```shell
# 重新生成引导会检测其他可用efi分区，生成新的引导项
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
### Plasma登录管理器开机打开数字键盘
- [开机打开数字键盘](https://wiki.archlinuxcn.org/wiki/%E5%90%AF%E5%8A%A8%E6%97%B6%E6%89%93%E5%BC%80%E6%95%B0%E5%AD%97%E9%94%81%E5%AE%9A%E9%94%AE#Plasma_%E7%99%BB%E5%BD%95%E7%AE%A1%E7%90%86%E5%99%A8)

```shell
# 编辑 /var/lib/plasmalogin/.config/kdedefaults/kcminputrc
/var/lib/plasmalogin/.config/kdedefaults/kcminputrc
[Keyboard]
NumLock=0
```



## 显卡驱动
[驱动安装](./nvidia.md)

## 快速跳转
### z.lua  废弃
```shell
mkdir -p ~/.config/fish/conf.d/ & kate z.fish

source (lua /home/mx/z.lua/z.lua --init fish once enhanced fzf | psub)
alias zc='z -c'      # 严格匹配当前路径的子路径
alias zz='z -i'      # 使用交互式选择模式
alias zf='z -I'      # 使用 fzf 对多个结果进行选择
alias zb='z -b'      # 快速回到父目录

```
### cd、fzf、fd组合
```shell
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

### zoxide
```shell
# 初始化
zoxide init fish | source
# 导入atuin、autojump、fasd、z、z.lua、zsh-z的数据
zoxide import --from z /home/mx/.zlua --merge

```

## 电源方案
```shell
# 安装
sudo pacman -S power-profiles-daemon
# 启动
sudo systemctl unmask power-profiles-daemon
sudo systemctl enable --now power-profiles-daemon

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

#输入和输出 --> 键盘 --> 虚拟键盘 里激活 Fcitx5 Wayland 启动器
# 防止漏字，在 [Formats] 里面添加一行
kate ~/.config/plasma-localerc
LC_CTYPE=en_US.UTF-8

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

## 编辑器
### Kate 特性
1. 支持复制文件路径
2. 打开配置文件持续编辑，不用重复敲命令行


## 浏览器

```shell
paru -Sy brave-origin-bin

# 修改加速下载连接
kate /home/mx/.cache/paru/clone/brave-origin-nightly-bin/PKGBUILD
```

## 终端
### Kconsole
#### 美化
1. 菜单 > 设置 > 显示工具栏 > 去掉两个勾选。
2. 右键 > 菜单 > 编辑当前配置方案。
3. 外观->配色方案和字体->编辑->背景透明度20%
4. 外观->其他->窗口->取消激活调整大小后显示终端大小提示
5. 外观->字体->Maple Mono NF ->大小15pt
6. 外观->配色方案和字体->获取新方案->Catppuccin Frappe->选中
7. 滚动->滚动条位置隐藏->应用->确定


```shell

```

### fish
#### 主题

```shell
# 提示符
Fish + Starship
# fish + Tide
```

```shell
# powerlinepk10 for fish
tide
# 添加到配置文件
/home/mx/.config/fish/conf.d/z.fish
```

```shell
# fish主题配置
status list-files themes
fish_config theme list
# 设置主题到配置文件
~/.config/fish/config.fish
fish_config theme choose "dracula"
fish_config theme choose "catppuccin-frappe"
```
###	ghostty
#### 自带分屏
1. 多终端并行操作
2. 内置多种主题自由选择
3. 定制化


#### 配置文件可视化编辑

- [ghostty](https://ghostty.zerebos.com/app/import-export)

#### 命令
```shell
# 查看主题
ghostty +list-themes
# 查看按键
ghostty +list-keybinds --default

```
#### DotFile
- [1](https://github.com/BruceLanLan/bruceblue-ghostty-config)
- 


#### 配色
- [draculatheme.com](http://github.com/dracula/dracula-theme)

- [catppuccin](https://github.com/catppuccin/fish)

## kde系统设置
### 字体
- 设置系统默认字体Maple Mono
- 抗锯齿

### 快速设置
- 显示历史常用设置

### 全局搜索工具
- Alt+F2

### 键盘
- NumLock开机状态设置
- 常用软件快捷键设置

### 默认应用程序
- 终端
- 网页浏览器
- 文本编辑器
- 音乐视频播放器
- 日历
- 邮箱
- pdf
- 文件管理器
- 压缩包管理器
- 地图

### 文件关联
- 扩展名关联设置

### 窗口管理器
#### niri+Noctalia Shell+kde安装
```shell
# 1.qt5-wayland 比如brave-origin浏览器，QT软件在Wayland协议下需要，否则无法启动
# 2.qt6-wayland QT软件在Wayland协议下需要，否则无法启动

paru -S --needed niri xcb-util-cursor tree noctalia-shell xwayland-satellite polkit-kde-agent cliphist brightnessctl pamixer qt5-wayland qt6-wayland 

```
**注意事项**
1. kate需要niri的window-rule规则，否则默认是全屏模式，noctalia-shell的关机电源的浮动面板无法显示
2. 解决niri+kde混合桌面环境，托盘和app启动器中图标显示色块问题，无法正常显示
```shell
cd /usr/share/wayland-sessions/
touch niri_kde.desktop
kate niri_kde.desktop
# 添加
[Desktop Entry]
Name=Niri + KDE
Comment=Wayland session with niri compositor and KDE Plasma
Exec=env KDE_SESSION_VERSION=6 KDE_FULL_SESSION=true niri
Type=Application
```
3. konsole不要设置记住窗口大小，否则无法按照niri配置的0.5宽度自动分屏
4. noctalia-shell壁纸必须要放在配置的壁纸目录，放在其他目录选择了也无法显示
5. noctalia-shell设置Dock栏->背景透明度，需要重启否则配置不生效
6. noctalia-shell设置启动器->屏最上方显示，否则会被置顶程序遮挡
7. noctalia-shell设置地区->天气搜索位置

## 终端文件管理
### 特性
1.	集成各个工具实现在鸭子中直接预览文件内容
2.	使用快捷键调用集成命令直接编辑文件
3.	集成搜、编辑、定位、预览与一体
```shell
paru -S yazi-git ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick
# q退出yazi时 终端自动切换到 退出时的目录
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	command yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
		builtin cd -- "$cwd"
	end
	command rm -f -- "$tmp"
end

kate .config/yazi/yazi.toml
```
### 配置文件
**注意**：可配合deepseek生成toml格式的中文注释
- [https://github.com/sxyazi/yazi/blob/shipped/yazi-config/preset/yazi-default.toml](https://github.com/sxyazi/yazi/blob/shipped/yazi-config/preset/yazi-default.toml)
- [https://github.com/sxyazi/yazi/blob/shipped/yazi-config/preset/keymap-default.toml](https://github.com/sxyazi/yazi/blob/shipped/yazi-config/preset/keymap-default.toml)


## 桌面
kde plasame
