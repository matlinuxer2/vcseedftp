#!/usr/bin/env python
#encoding: utf8
#
# Copyright: Chun-Yu Lee (Mat) <matlinuxer2@gmail.com> || Dieter Hsu <dieterplex@gmail.com>
#

import os
import vcseedftp

vcseedftp.LCD = os.path.dirname( __file__ )

_, sample_output, _ = vcseedftp.popen( 'cat test02_data/diff_output.txt' )

result = vcseedftp.convert_diff_to_ftp_commands( sample_output )

print( result )
