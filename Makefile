update:
	git pull; git push -f ; 

run:
	ps aux | grep vcseedftp | grep run && exit 0
	for ini in `find . -type f -name '*.ini'`; do ./vcseedftp $$ini; done

cron:
	make update
	crontab -l | sed -e '/vcseedftp/d' > cron.txt 
	echo "0 * * * * cd `pwd`; make update; make cron; make run;" >> cron.txt
	cat cron.txt | crontab - 
	crontab -l
	rm -v cron.txt

kill:
	ps aux | grep vcseedftp | grep run | grep -v 'grep' | awk '{print $$2}' | xargs kill
	ps aux | grep 'lftp -f /tmp/tmp'   | grep -v 'grep' | awk '{print $$2}' | xargs kill
