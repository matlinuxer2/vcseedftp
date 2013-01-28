#!/usr/bin/python
from pprint import pprint as p;import subprocess as s;

def loop_list_print(cmds):
	oo = [ s.Popen(['/bin/sh','-c', cmd], stdout=s.PIPE).communicate()[0] for cmd in cmds]
	ooo = [ ( o, o.decode('unicode_escape',errors='replace'), o.decode('big5') ) for o in oo ]
	for oo in ooo:
		for o in oo:
			print(o.strip()) 

def plain_print(cmds):
	for cmd in cmds:
		out,_ = s.Popen(['/bin/sh','-c', cmd], stdout=s.PIPE).communicate()
		print(out.strip())
		print(out.decode('unicode_escape',errors='replace').strip())
		print(out.decode('big5').strip())

def test_sample():
	cmd = u"""ls $'/tmp/vcseedftp.slr/remote/templates/v49-1/images/\\245\\274\\251R\\246W--1_18.gif' """
	print(s.Popen(['/bin/sh','-c', cmd], stdout=s.PIPE).communicate()[0].decode('big5'))

def test_diff_output():
	content=s.Popen(['git', 'diff','--name-only','stash@{0}'], stdout=s.PIPE).communicate()[0];
	cmds=["ls $'%s'"%n[1:-1]for n in content.decode().strip().split('\n')]
	loop_list_print(cmds)


content = u"""\
D	"shopadmin/images/big5/wi0114-48+.gif"
D	"templates/v49-1/images/bu t4.jpg"
D	"templates/v49-1/images/q 2.gif"
D	"templates/v49-1/images/q 22.gif"
D	"templates/v49-1/images/title- liulan.gif"
D	"templates/v49-1/images/\\245\\274\\251R\\246W--1_09.jpg"
D	"templates/v49-1/images/\\245\\274\\251R\\246W--1_14.gif"
D	"templates/v49-1/images/\\245\\274\\251R\\246W--1_18.gif"
D	"templates/v49-1/images/\\251\\361\\244J\\301\\312\\252\\253\\250\\256.gif"
D	"templates/v49-1/images/\\251\\361\\244J\\301\\312\\252\\253\\250\\256.jpg"
"""
cmds = [ "ls $'%s'" % x.split('\t')[1][1:-1] for x in content.strip().split('\n') ]
p(cmds)
loop_list_print(cmds)
#plain_print(cmds)
