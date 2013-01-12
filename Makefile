update:
	git pull; git push -f ; 
	make cron

run:
	for ini in `find . -type f -name '*.ini'`; do ./vcseedftp $$ini; done

cron:
	crontab -l | sed -e '/vcseedftp/d' > cron.txt 
	echo "0 * * * * cd `pwd`; make update;" >> cron.txt
	cat cron.txt | crontab - 
	crontab -l
	rm -v cron.txt
