#!/bin/sh

#配置
#------------------------------------------------------------------------#

#备份服务器SSH 如 backup@10.0.0.1
BHOST=$($KITSSHELL/kits.sh private info_bhost)
#备份路径 远程服务器上的
BDST=/volume1/Backup

#SSH密钥文件 如 /Users/JinnLynn/.ssh/jkey
SSHKEY=$($KITSSHELL/kits.sh private info_sshkey)

#忽略的文件列表文件
EXCLUDE=./excludes.txt

#日志目录
LOGDIR=./log

echo $BHOST
echo $SSHKEY
exit

#配置结束
#------------------------------------------------------------------------#

#处理备份的函数 
#参数1: 要备份的文件夹路径 注意：最好以“/”结尾
#参数2: 备份的名称，用于在服务端建立文件夹
#参数3: 备份NAS上的文件
function single_backup() {
	echo "$(date +"%H:%M:%S") $2 start"
	echo "------------------------------------------------"
	#检查目录是否已存在，如果没有建立目录
	ssh $BHOST "if [ ! -d $BDST/$2 ]; then mkdir $BDST/$2 ; chown -R backup:users $BDST/$2 ; chmod -R 744 $BDST/$2 ; fi"
	#被修改回删除的文件保存处理 每天生成一个目录
	BDIR="$BDST/$2/$(date +0%u)"
	OPTS="-av --force --ignore-errors --delete --backup --backup-dir=$BDIR"
	SSH_OPT="ssh -i $SSHKEY"
	EXCULDE_OPT="--exclude-from=$EXCLUDE"
	#清除旧的增量备份数据
	rsync --delete -a $SCRIPTPATH/.emptydir/ $BHOST:$BDIR
	#同步文件
	if [ "$3" = 'nas' ]; then
		#同步NAS上文件
		$SSH_OPT $BHOST "rsync $OPTS $1 $BDST/$2/current"
	else
		#同步本地文件
		rsync $OPTS $EXCULDE_OPT -e "$SSH_OPT" $1 $BHOST:$BDST/$2/current
	fi
	
	echo "------------------------------------------------"
	echo "$(date +"%H:%M:%S") $2 ok\n\n"
}

function backup() {

	#创建空目录 用于清空旧的日增量变化备份
	[ -d .emptydir ] || mkdir .emptydir

	echo "$(date +"%H:%M:%S") backup start\n"

	#以下为备份列表 格式：backup 备份文件夹绝对路径 备份名
	#注意：备份文件夹路径最好以'/'结束
	#------------------------------------------------------------------------#


	#JMBP
	#备份iTunes
	single_backup /Users/JinnLynn/Music/iTunes/ JMBP.iTunes

	#备份Developer
	single_backup /Users/JinnLynn/Developer/ JMBP.Developer

	#备份Documents
	single_backup /Users/JinnLynn/Documents/ JMBP.Documents

	#备份Applications
	single_backup /Applications/ JMBP.Applications

	#备份Pictures
	single_backup /Users/JinnLynn/Pictures/ JMBP.Pictures

	#JMBPWin
	single_backup /Volumes/BOOTCAMP/Users/JinnLynn/Developer/ JMBPWin.Developer

	#JNAS SCMs
	single_backup /volume1/DevCenter/SCMs/ JNAS.SCMs nas


	#------------------------------------------------------------------------#

	#删除空目录
	rmdir .emptydir

	echo "$(date +"%H:%M:%S") backup finish\n\n"
}

#------------------------------------------------------------------------#

#脚本工作目录
if [ -L $0 ]; then
    SCRIPTPATH=$(dirname $(ls -l $0 | awk '{print $11}')) #由链接文件访问    
else
    SCRIPTPATH=$(cd $(dirname $0); pwd) #由直接访问
fi

#SSH密钥代理SOCKET 在cron中必须设置，否则无法成功备份
if [ -z $SSH_AUTH_SOCK ]; then
	export SSH_AUTH_SOCK=$( ls /tmp/launch-*/Listeners )
fi

#进入工作目录
cd $SCRIPTPATH

#建立日志目录
[ -d "$LOGDIR" ] || mkdir "$LOGDIR"

#日志文件
LOGFILE="$LOGDIR/$(date +%Y%m%d-%H%M%S).log"
# COUNTER=1
# while [ -f "$LOGFILE" ]; do
#     LOGFILE="$LOGDIR/$(date +%Y%m%d)-$COUNTER.log"
#     COUNTER=$(($COUNTER+1))
# done

backup | tee -a "$LOGFILE"