
alias ll="ls -h -l"

# Sublime Text 2的命令行模式
alias subl="/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl"

# SSH相关
# SSH秘钥 SOCK等重置
alias ssh.reset="$KITSSHELL/network.sh ssh reset"
# SSH快速连接
alias ssh.home="ssh $JHOST"
alias ssh.scm="ssh scm@$JHOST"
alias ssh.work="ssh jinnlynn@172.16.5.14"
alias ssh.github="ssh -T git@github.com"

# 改变路径
alias to.kits="cd $KITS; pwd"
alias to.shell="cd $KITSSHELL; pwd"
alias to.desktop="cd ~/Desktop; pwd"
alias to.scms="cd ~/Developer/SCMs; pwd"


# KITS
alias kits="kits.sh"

# 备份
alias kits.backup="kits backup"
# 使用gfwlist生成自动代理配置文件
alias kits.genpac="kits genpac"
# 使用`预览`打开man内容
# $1 待查程序名 必须
alias kits.manp="kits manp"

# 锁定电脑
alias kits.lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# itunes
# $1 类型 lyric = 获取当前播放音乐的歌词 rate = 给当前播放的歌曲评级
# $2 如果$1=rate才有效 1~5
alias kits.itunes="kits itunes"

# MAMP控制
alias mamp.start="kits mamp start"
alias mamp.stop="kits mamp stop"
alias mamp.restart="kits mamp restart"

# 隐藏文件的显示控制
alias finder.hidden.show="$KITSSHELL/filesystem.sh hiddenfiles show"
alias finder.hidden.hide="$KITSSHELL/filesystem.sh hiddenfiles hide"

# 在Finder中打开文件夹
# 参数如果为空 则打开当前工作目录
alias finder.open="$KITSSHELL/filesystem.sh finder open"