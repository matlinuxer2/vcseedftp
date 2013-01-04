#!/usr/bin/env bash
#
# Copyright: Chun-Yu Lee (Mat) <matlinuxer2@gmail.com> since 2012
#

ROOT="$( readlink -f $(dirname $0) )"


function backup_httpdocs(){
	local SRC_DIR="$1"
	local DST_DIR="$2"
	local HTTPDOCS_GIT_DIR="$3"

	install -d "$HTTPDOCS_GIT_DIR"
	if [ ! -d "$HTTPDOCS_GIT_DIR/.git" ]; then
		pushd . ; cd  "$HTTPDOCS_GIT_DIR"
			git init
		popd
	fi

	rsync -rlptD -vz \
		--owner \
		--group \
		--delete \
		--exclude='.git' \
		--exclude='data/sqldata/' \
		--exclude='temp/caches/' \
		--exclude='temp/compiled/' \
		--exclude='temp/query_caches/' \
		--exclude='temp/static_caches/' \
		$SRC_DIR $DST_DIR

	pushd .; cd $DST_DIR
		if [ ! -d ".git" ]; then
			git init
		fi
		if [ $(git ls-files -d|wc -l) -gt 0 ]; then
			git ls-files -d -z | xargs -0 git rm
		fi
		git ls-files -o -z | xargs -0 git add
		git commit -a -m "save snapshot" || true
		pushd .; cd "$HTTPDOCS_GIT_DIR"
			git pull $DST_DIR
		popd
		#tar -cjf $HTTPDOCS_TBZ2 .
	popd
}

function backup_mysql(){
	local DB_USER="$1"
	local DB_PASSWD="$2"
	local DB_NAME="$3"
	local SQL_TBZ2="$4"
	local SQL_DIR="$(dirname $SQL_TBZ2)"

	install -d "$SQL_DIR"

	mysqldump --opt \
		  --skip-extended-insert \
		  --set-charset \
		  --default-character-set=utf8 \
		  --host=localhost \
		  --user=$DB_USER \
		  --password=$DB_PASSWD \
		  --database $DB_NAME > ${SQL_TBZ2%.bz2}

	bzip2 -z ${SQL_TBZ2%.bz2}
}


function restore_httpdocs(){
	local HTTPDOCS_DIR="$ROOT/$HTTPDOCS_DIR"
	local ORIG_HTTPDOCS_DIR="$1"
	local TARGET_HTTPDOCS_TBZ2="$2"
	local HTTPDOCS_USER="$3"
	local HTTPDOCS_GROUP="$4"

	pushd .; cd $ROOT

		test -d $HTTPDOCS_DIR && sudo rm -r $HTTPDOCS_DIR
		test -d $HTTPDOCS_DIR || mkdir $HTTPDOCS_DIR 

		# 這裡要加 sudo 來保持權限
		sudo tar -C $HTTPDOCS_DIR -jxf $TARGET_HTTPDOCS_TBZ2

		sudo chown -R $HTTPDOCS_USER:$HTTPDOCS_GROUP $HTTPDOCS_DIR


		# 這裡要加 sudo 來保持權限
		sudo rsync -rlptD -vz \
		    --owner \
		    --group \
		    --delete \
		    --exclude='data/sqldata/' \
		    --exclude='temp/caches/' \
		    --exclude='temp/compiled/' \
		    --exclude='temp/query_caches/' \
		    --exclude='temp/static_caches/' \
		    $HTTPDOCS_DIR $ORIG_HTTPDOCS_DIR

		# 加上可能遺漏的暫存目錄
		sudo install -d "$ORIG_HTTPDOCS_DIR/data/sqldata/"
		sudo install -d "$ORIG_HTTPDOCS_DIR/temp/caches/"
		sudo install -d "$ORIG_HTTPDOCS_DIR/temp/caches/{0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f}"
		sudo install -d "$ORIG_HTTPDOCS_DIR/temp/compiled/"
		sudo install -d "$ORIG_HTTPDOCS_DIR/temp/query_caches/"
		sudo install -d "$ORIG_HTTPDOCS_DIR/temp/static_caches/"
		sudo chown -R $HTTPDOCS_USER:$HTTPDOCS_GROUP "$ORIG_HTTPDOCS_DIR/temp/"
		sudo chmod a+w -R "$ORIG_HTTPDOCS_DIR/temp/"
		sudo chown $HTTPDOCS_USER:$HTTPDOCS_GROUP "$ORIG_HTTPDOCS_DIR/data/sqldata/"
		sudo chmod a+w -R "$ORIG_HTTPDOCS_DIR/data/sqldata/"

		test -d $HTTPDOCS_DIR && sudo rm -r $HTTPDOCS_DIR

	popd

}



function restore_mysql(){
	local DB_USER="$1"
	local DB_PASSWD="$2"
	local DB_NAME="$3"
	local TARGET_SQL_TBZ2="$4"

	local TEMP_SQL_BZ2="temp.sql.bz2"
	local TEMP_SQL="temp.sql"

	pushd .; cd $ROOT

		test -f $TEMP_SQL_BZ2 && rm $TEMP_SQL_BZ2
		test -f $TEMP_SQL && rm $TEMP_SQL

		cp $TARGET_SQL_TBZ2 $TEMP_SQL_BZ2
		bzip2 -k -d $TEMP_SQL_BZ2

		mysql -u $DB_USER -p$DB_PASSWD << EOF

		show databases;
		drop database $DB_NAME;
		create database $DB_NAME;

EOF

		mysql -u $DB_USER -p$DB_PASSWD < $TEMP_SQL

		test -f $TEMP_SQL_BZ2 && rm $TEMP_SQL_BZ2
		test -f $TEMP_SQL && rm $TEMP_SQL

	popd

}

case $1 in
	mysite)
	backup_httpdocs "/var/www/vhosts/mysite.com.tw/httpdocs/" "$ROOT/_tmp_mysite_httpdocs/" "$ROOT/backup_mysite/httpdocs/"
	backup_mysql "website_mysite" "mysite" "website_mysitecomtw" "$ROOT/backup_mysite/mysql/$(date +%Y-%m-%d-%H%M%S)_mysite.sql.bz2"
	;;

	*) 
	echo "請指定備份目標"
	;;
esac
