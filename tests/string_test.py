#!/usr/bin/env python
#encoding: utf8
#
# Copyright: Chun-Yu Lee (Mat) <matlinuxer2@gmail.com> || Dieter Hsu <dieterplex@gmail.com>
#

import vcseedftp

cmd = "ls -l /tmp/; ls -l /tmpp/"
retcode, out, err = _popen(cmd)
if retcode != 0:
	print("指令失敗, 原因: " + err.decode().strip() )
