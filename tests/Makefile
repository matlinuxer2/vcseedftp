all:
	make test01
	make test02
	make test03
	make test04

pre:
	cp ../vcseedftp ./vcseedftp.py

post:
	rm ./vcseedftp.py *.pyc 
	test -d __pycache__ && rm -r __pycache__

test01:
	make pre
	( which python  && python --version  && python  ./test01_popen_str.py ) || true
	( which python2 && python2 --version && python2 ./test01_popen_str.py ) || true
	( which python3 && python3 --version && python3 ./test01_popen_str.py ) || true
	make post

test02:
	make pre
	( which python  && python --version  && python  ./test02_special_filenames.py ) || true
	( which python2 && python2 --version && python2 ./test02_special_filenames.py ) || true
	( which python3 && python3 --version && python3 ./test02_special_filenames.py ) || true
	make post

test03:
	make pre
	( which python  && python --version  && python  ./test03_ls_octal_name.py ) || true
	( which python2 && python2 --version && python2 ./test03_ls_octal_name.py ) || true
	( which python3 && python3 --version && python3 ./test03_ls_octal_name.py ) || true
	make post

test04:
	make pre
	( which python  && python --version  && python  ./test04_list_timezone.py ) || true
	( which python2 && python2 --version && python2 ./test04_list_timezone.py ) || true
	( which python3 && python3 --version && python3 ./test04_list_timezone.py ) || true
	make post
