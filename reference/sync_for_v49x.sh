#!/usr/bin/env bash
#
# Author: Chun-Yu Lee (Mat) <matlinuxer2@gmail.com>
#
# All rights reserved.
#

ROOT="$( readlink -f $(dirname $0) )"
NAME="$(basename $0)"

HOST=""
USER=""
PASS=""
LCD=""
RCD=""
PREV="$ROOT/.sync_for_$NAME.prev" # 用來紀錄最新變更時間

function init(){
if [ ! -d "$LCD" ]; then
	mkdir -p "$LCD"	
fi
}

function usage(){
cat << EOF

 usage:
	$0 login	

	$0 check	檢查遠端目錄列表

	$0 pull		下載遠端的程式至本機

	$0 push-dry	上傳本機的程式至遠端( 預覽 )

	$0 push		上傳本機的程式至遠端( only changed )

	$0 push-full	上傳本機的程式至遠端

EOF
}


function login(){
pushd . ; cd $ROOT

lftp -e "set ftp:list-options -a;
set ftp:ssl-allow no;
open ftp://$USER:$PASS@$HOST; 
lcd $LCD;
cd $RCD;
rels -trl;
"

popd
}

function check(){
pushd . ; cd $ROOT

lftp -c "set ftp:list-options -a;
set ftp:ssl-allow no;
open ftp://$USER:$PASS@$HOST; 
lcd $LCD;
cd $RCD;
rels -trl;
"

popd
}

PUSH_EXCL="(\.hg"
PUSH_EXCL="$PUSH_EXCL|\.htaccess"
PUSH_EXCL="$PUSH_EXCL|\.swp"
PUSH_EXCL="$PUSH_EXCL|\.orig"
PUSH_EXCL="$PUSH_EXCL|\.sh"
PUSH_EXCL="$PUSH_EXCL|\./templates/*/templates_c/"
PUSH_EXCL="$PUSH_EXCL)"

function upload(){

yesno=$1

pushd . ; cd $ROOT

pushd . ; cd $LCD
if [ -f "$PREV" ]; then
	FILES=""
	echo "find . -type f -newer $PREV | egrep -v \"$PUSH_EXCL\""

	for f in $(find . -type f -newer $PREV | egrep -v "$PUSH_EXCL" )
	do
		FILES="$FILES '$f'"
		ls -l $f
	done
fi
popd

if [ "x$FILES" != "x" -a $yesno == "yes" ]; then
lftp -c "set ftp:list-options -a;
set ftp:ssl-allow no;
open ftp://$USER:$PASS@$HOST; 
lcd $LCD;
cd $RCD;
mput -d $FILES;
"

touch $PREV

fi

popd
}

function upload_full(){
pushd . ; cd $ROOT

lftp -c "set ftp:list-options -a;
set ftp:ssl-allow no;
open ftp://$USER:$PASS@$HOST; 
lcd $LCD;
cd $RCD;
mirror --reverse \
       --verbose \
       --exclude \.htaccess \
       --exclude \.swp \
       --exclude \.orig \
       --exclude \.sh \
       --exclude \.hg \
       --exclude \.hgignore \
       --parallel=1 \
       $FILES
       ;
"

popd
}

EXCLUDES=""
EXCLUDES="$EXCLUDES --exclude .hg"
EXCLUDES="$EXCLUDES --exclude .hgignore"

EXCLUDES=""

function download(){
pushd . ; cd $ROOT

lftp -c "set ftp:list-options -a;
set ftp:ssl-allow no;
open ftp://$USER:$PASS@$HOST; 
lcd $LCD;
cd $RCD;
mirror \
       --delete \
       --verbose \
       $EXCLUDES \
       --parallel=3 ;
"

touch $PREV

popd
}


################################################################################
# 主程式
################################################################################

init

case $1 in
    login)
	login
	;;
    check)
	check
	;;
    push-dry)
	upload "no"
        ;;
    push)
	upload "yes"
        ;;
    push-full)
	upload_full
        ;;
    pull)
	download
        ;;
    *)
	usage
        ;;
esac

