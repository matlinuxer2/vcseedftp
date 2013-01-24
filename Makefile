update:
	git pull; git push -f ; 

run:
	ps aux | grep 'vcseedftp' | grep -v 'grep' | grep -v '/bin/sh -c cd' || for ini in `find . -type f -name '*.ini' | sort `; do ./vcseedftp $$ini; done

cron:
	git checkout master;
	make update
	crontab -l | sed -e '/vcseedftp/d' > cron.txt 
	echo "*/30 * * * * cd `pwd`; make run; make cron; " >> cron.txt
	cat cron.txt | crontab - 
	crontab -l
	rm -v cron.txt

mkdir:
	for x in `grep LCD *.ini | awk '{print $$3}'`;do install -v -d $$x;done

kill:
	ps aux | grep 'make run'           | grep -v 'grep' | awk '{print $$2}' | xargs kill
	ps aux | grep 'lftp -f /tmp/tmp'   | grep -v 'grep' | awk '{print $$2}' | xargs kill
