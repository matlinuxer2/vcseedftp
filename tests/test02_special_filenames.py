#!/usr/bin/env python
#encoding: utf8
#
# Copyright: Chun-Yu Lee (Mat) <matlinuxer2@gmail.com> || Dieter Hsu <dieterplex@gmail.com>
#

import vcseedftp
import codecs

sample_output = [ 
"""
D	shopadmin/images/big5/wi0114-48+.gif
D	templates/v49-1/images/bu t4.jpg
D	templates/v49-1/images/q 2.gif
D	templates/v49-1/images/q 22.gif
D	templates/v49-1/images/title- liulan.gif
D	"templates/v49-1/images/\\245\\274\\251R\\246W--1_09.jpg"
D	"templates/v49-1/images/\\245\\274\\251R\\246W--1_14.gif"
D	"templates/v49-1/images/\\245\\274\\251R\\246W--1_18.gif"
D	"templates/v49-1/images/\\251\\361\\244J\\301\\312\\252\\253\\250\\256.gif"
D	"templates/v49-1/images/\\251\\361\\244J\\301\\312\\252\\253\\250\\256.jpg"
"""
]

result = vcseedftp.convert_diff_to_ftp_commands( sample_output[0] )

print( result )
