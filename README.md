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

## 输入法
### Fcitx5-Rime框架安装
```shell
paru -Sy fcitx5-lotus

# 薄荷输入法
# 万象配置
# 雾凇配置
# weasel.yaml、squirrel.yaml 是鼠须管和小狼毫前端配置，对fcitx5前端不起作用，fcitx5需要另外下载皮肤
paru -S fcitx5-im
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


## 浏览器

```shell
paru -Sy brave-origin-bin

# 修改加速下载连接
kate /home/mx/.cache/paru/clone/brave-origin-nightly-bin/PKGBUILD
```

## 终端
## 桌面
## 浏览器
