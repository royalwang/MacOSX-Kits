#!/bin/bash

#检查环境变量
if [ -z $KITS ]; then
    . $(cd $(dirname $0); pwd)/profile.sh
fi

#Applescrit接口文件
OSASPORT=$KITSSHELL/osasport.applescript

#私有操作
function private() {
    if [ -f $KITSSHELL/private.sh ]; then 
        . $KITSSHELL/private.sh $1 $2
    else
        echo 'kits: private is not a kits command.'
    fi
}

# 使用`预览`打开man内容
function manp() {
  man -t $1 | open -f -a /Applications/Preview.app
}

case $1 in
    'backup' )     #备份文件到NAS
        $KITSSHELL/backup/backup.sh
        ;;
    'genpac' )     #通过GenPAC生成自动代理配置文件
        $KITS/GenPAC/genpac.py
        ;;
    'itunes' )     #部分itunes操作
        osascript $OSASPORT itunes $2 $3
        ;;
    'manp' )
        manp $2
        ;;
    * )
        echo "ERROR. Usage: kits.sh <backup|genpac|itunes|manp>"
        ;;
esac