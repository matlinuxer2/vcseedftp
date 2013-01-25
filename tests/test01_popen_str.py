#!/usr/bin/env python
#encoding: utf8
#
# Copyright: Chun-Yu Lee (Mat) <matlinuxer2@gmail.com> || Dieter Hsu <dieterplex@gmail.com>
#

import vcseedftp

vcseedftp.LCD = "/tmp/"
cmd = "ls -l /tmp2/"
retcode, out, err = vcseedftp._popen(cmd)
print ( type( retcode ) ) 
print ( type( out )     )
print ( type( err )     )
if retcode != 0:
	print( "指令失敗, 原因: " + err.strip() )
