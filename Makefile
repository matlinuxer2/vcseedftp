update:
	git pull; git push -f ; 

run:
	for ini in `find . -type f -name '*.ini'`; do ./vcseedftp $$ini; done

cron:
	make update
	crontab -l | sed -e '/vcseedftp/d' > cron.txt 
	echo "0 * * * * cd `pwd`; make update;" >> cron.txt
	cat cron.txt | crontab - 
	crontab -l
	rm -v cron.txt
