#!/usr/bin/python2

import os
import sys
import mailbox
import email.utils

def write_all_mail_to_logs(mbox_path='mbox', output_path='logs'):
	"""read mbox file and write each mail seperately to a file naming with datetime"""
	if not os.path.exists(output_path):
		os.makedirs(output_path)
	mbox = mailbox.mbox(mbox_path)
	for message in mbox:
		log_name = "%d-%02d-%02d_%02d-%02d-%02d.log.txt" %  email.utils.parsedate_tz(message['date'])[:-4]
		log_path = os.path.join(output_path, log_name)
		with open(log_path, 'w') as f:
				f.write(message.as_string())

def list_filenames_from_logs_dir(path='logs'):
	import json, subprocess
	#path = os.path.realpath(path)
	file_list = subprocess.check_output(['/bin/sh','-c', 'cd %s; find . ' % path ])
	filenames = json.dumps( sorted(file_list.strip().split('\n'), reverse=True), indent=4 )
	index_template = """<!DOCTYPE html><html><head><title>VCSeedFTP Log View</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<link rel="stylesheet" href="http://necolas.github.com/normalize.css/2.1.0/normalize.css">
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8">
var $lists = %s
</script>
<style utf-8"type="text/css">
	*{margin:0;padding:0;}
	html, body { height: 100%% }
	ul{list-style:none;}
	a{text-decoration:none;color:#00a;}
	h3 { padding: 10px; background: beige; cursor:pointer; }
	.content { padding: 10px; background: chocolate; }
	.icon-minus, .icon-plus{ cursor:crosshair; }
	#main{
	position: absolute; top: 0; bottom: 0; left: 0; width: 300px; height: 100%%;
	overflow: scroll; /*Disable scrollbars. Set to "scroll" to enable*/
	}
	#preview{ position: fixed; top: 0; left: 300px; right: 0; bottom: 0; overflow: auto; }
</style>
</head><body>
<div id="main">
%s
</div>
<script type="text/javascript" charset="utf-8">
$( document ).ready( function() {
	var $main = $('#main')
	$f = $lists[0]
	$n = $f.slice($f.lastIndexOf("/")+1)
	$log_block = $("<h3 class='category'><a href='"+$f+"'>"+$n+"</a><span class='icon-plus'> + </span></h3>")
	$content = $("<div class='content' style='display: none;'/>")
	$main.append($log_block)
	$main.append($content)
	for ( var i = 1; i < $lists.length; i++ ) {
		$f = $lists[i]
		$n = $f.slice($f.lastIndexOf("/")+1)
		$log_block = $("<div class='log'><a href='#' path='"+$f+"'>"+$n+"</a></div>")
		$content.append($log_block)
	}
	$main.on('click', 'h3', function() {
		$(this).next('.content').slideToggle('fast');
	    $(this).find('span').toggleClass("icon-minus icon-plus");
	    $(this).find('.icon-minus').html(' - ')
	    $(this).find('.icon-plus').html(' + ')
	});
	$main.on('click', '.log', function() {
		$src = $(this).find('a').attr('path');
		$('#preview').html($('<iframe>',{src:$src, width:'100%%', height:'100%%', border:0}));
	});
});
</script>
<div id="preview"></div>
</body></html>
""" % (filenames, "")

	with open('logs/index.html', 'w') as f:
		f.write(index_template )

if __name__ == "__main__":
	if len(sys.argv) <= 1:
		print(' NO mbox filename to read from')
		print('usage: %s <exported_mbox>'%sys.argv[0])
		sys.exit()
	write_all_mail_to_logs( mbox_path=sys.argv[1] )
	list_filenames_from_logs_dir()
