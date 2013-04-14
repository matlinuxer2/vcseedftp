update:
	git pull; git push -f ; 

run:
	ps aux | grep 'vcseedftp' | grep -v 'grep' | grep -v '/bin/sh -c cd' | grep -v 'git-upload-pack' || for ini in `find . -type f -name '*.ini' | sort `; do ./vcseedftp $$ini; done

cron:
	git checkout master;
	make update
	crontab -l | sed -e '/vcseedftp/d' > cron.txt 
	echo "*/30 * * * * cd `pwd`; make run; make cron; " >> cron.txt
	cat cron.txt | crontab - 
	crontab -l
	rm -v cron.txt

mkdir:
	for x in `find . -type f -name '*.ini'| xargs grep LCD | awk '{print $$3}'`;do install -v -d $$x;done

kill:
	ps aux | grep 'make run'           | grep -v 'grep' | awk '{print $$2}' | xargs kill
	ps aux | grep 'lftp -f /tmp/tmp'   | grep -v 'grep' | awk '{print $$2}' | xargs kill

docs/Doxyfile:
	( test -d docs && rm -rvf docs ) || true
	install -d docs
	cd docs; rm Doxyfile; doxygen -g
	cd docs; sed -i Doxyfile -e "s/^OUTPUT_DIRECTORY .*=.*/OUTPUT_DIRECTORY = ..\/docs /g"
	cd docs; sed -i Doxyfile -e "s/^OPTIMIZE_OUTPUT_JAVA .*=.*/OPTIMIZE_OUTPUT_JAVA = YES/g"
	cd docs; sed -i Doxyfile -e "s/^HIDE_SCOPE_NAMES .*=.*/HIDE_SCOPE_NAMES = YES/g"
	cd docs; sed -i Doxyfile -e "s/^INPUT .*=.*/INPUT = .. ..\/vcseedftp /g"
	cd docs; sed -i Doxyfile -e "s/^EXCLUDE .*=.*/EXCLUDE = ..\/reference ..\/.git /g"
	cd docs; sed -i Doxyfile -e "s/^RECURSIVE .*=.*/RECURSIVE = YES/g"
	cd docs; sed -i Doxyfile -e "s/^GENERATE_TREEVIEW .*=.*/GENERATE_TREEVIEW = YES/g"
	cd docs; sed -i Doxyfile -e "s/^GENERATE_LATEX .*=.*/GENERATE_LATEX = NO/g"
	cd docs; sed -i Doxyfile -e "s/^OUTPUT_LANGUAGE .*=.*/OUTPUT_LANGUAGE = Chinese-Traditional/g"
	cd docs; sed -i Doxyfile -e "s/^SHOW_DIRECTORIES .*=.*/SHOW_DIRECTORIES = YES/g"
	cd docs; sed -i Doxyfile -e "s/^SOURCE_BROWSER .*=.*/SOURCE_BROWSER = YES/g"
	cd docs; sed -i Doxyfile -e "s/^JAVADOC_AUTOBRIEF .*=.*/JAVADOC_AUTOBRIEF = YES/g"
	cd docs; sed -i Doxyfile -e "s/^FULL_PATH_NAMES .*=.*/FULL_PATH_NAMES = YES/g"
	cd docs; sed -i Doxyfile -e "s/^STRIP_FROM_PATH .*=.*/STRIP_FROM_PATH = .. /g"
	cd docs; sed -i Doxyfile -e "s/^EXTENSION_MAPPING .*=.*/EXTENSION_MAPPING = no_extension=Python /g" # no_extension 的功能是 2013-01-20 的 1.8.3.1 版之後才有。
	cd docs; sed -i Doxyfile -e "s/^FILE_PATTERNS .*=.*/FILE_PATTERNS = vcseedftp *.py /g"
	cd docs; sed -i Doxyfile -e "s/^GENERATE_TODOLIST .*=.*/GENERATE_TODOLIST = YES /g"
	#cd docs; sed -i Doxyfile -e "s/^INPUT_FILTER .*=.*/INPUT_FILTER = .\/input_filter.php /g"
	#cd docs; sed -i Doxyfile -e "s/^HAVE_DOT .*=.*/HAVE_DOT = YES/g"
	#cd docs; sed -i Doxyfile -e "s/^ALWAYS_DETAILED_SEC .*=.*/ALWAYS_DETAILED_SEC = YES/g"
	#cd docs; sed -i Doxyfile -e "s/^ALLEXTERNALS .*=.*/ALLEXTERNALS = YES/g"
	#cd docs; sed -i Doxyfile -e "s/^CREATE_SUBDIRS .*=.*/CREATE_SUBDIRS = YES/g"
	#cd docs; sed -i Doxyfile -e "s/^EXTRACT_STATIC .*=.*/EXTRACT_STATIC = YES/g"
	#cd docs; sed -i Doxyfile -e "s/^XXX .*=.*/XXX = YES/g"

logs/mbox:
	test -d logs || install -d logs
	rsync -avz --rsh="ssh -p 11022" mat@219.84.143.48:mbox logs/mbox

log: logs/mbox
	test -d logs || install -d logs
	./logview.py logs/mbox	

doc:  docs/Doxyfile
	if [ `( doxygen --version ; echo "1.8.3.1" ) | sort -r | head -1` == `doxygen --version` ]; then make doc_new; else make doc_old ;fi

doc_new:
	cd docs;                                  doxygen;

doc_old:
	cd docs; cp ../vcseedftp ../vcseedftp.py; doxygen; rm ../vcseedftp.py

view:
	xdg-open ./docs/html/index.html
	xdg-open ./logs/index.html

clean:
	( test -d docs && rm -rf docs ) || true
	( test -d logs && rm -rf logs ) || true
