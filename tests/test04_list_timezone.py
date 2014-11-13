#!/usr/bin/env python
#encoding: utf8
#
# Copyright: Chun-Yu Lee (Mat) <matlinuxer2@gmail.com> || Dieter Hsu <dieterplex@gmail.com>
#

import vcseedftp

vcseedftp.LCD = "/tmp/"

result = vcseedftp.listTimezones()

for itm in result:
    print( itm )
