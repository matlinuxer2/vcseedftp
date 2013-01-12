update:
	git pull; git push -f ; 
	make cron

run:
	for ini in `find . -type f -name '*.ini'`; do ./vcseedftp $$ini; done

cron:
	echo -e "`crontab -l|grep -v vcseedftp`\n0 * * * * cd `pwd`; make update;"| crontab - 
	crontab -l

