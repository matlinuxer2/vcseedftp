run:
	cp ../vcseedftp ./vcseedftp.py
	make test03
	make test02
	make test01
	rm ./vcseedftp.py *.pyc 
	test -d __pycache__ && rm -r __pycache__

test01:
	( which python  && python --version  && python  ./test01_popen_str.py ) || true
	( which python2 && python2 --version && python2 ./test01_popen_str.py ) || true
	( which python3 && python3 --version && python3 ./test01_popen_str.py ) || true

test02:
	( which python  && python --version  && python  ./test02_special_filenames.py ) || true
	( which python2 && python2 --version && python2 ./test02_special_filenames.py ) || true
	( which python3 && python3 --version && python3 ./test02_special_filenames.py ) || true

test03:
	( which python  && python --version  && python  ./test03_ls_octal_name.py ) || true
	( which python2 && python2 --version && python2 ./test03_ls_octal_name.py ) || true
	( which python3 && python3 --version && python3 ./test03_ls_octal_name.py ) || true
