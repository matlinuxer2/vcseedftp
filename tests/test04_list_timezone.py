#!/usr/bin/env python
#encoding: utf8
#
# Copyright: Chun-Yu Lee (Mat) <matlinuxer2@gmail.com> || Dieter Hsu <dieterplex@gmail.com>
#

import vcseedftp

vcseedftp.LCD = "/tmp/"

print( vcseedftp.listTimezones() )
