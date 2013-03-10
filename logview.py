#!/usr/bin/python2

import os
import json
import textwrap

# TODO: use File API load all log contents display on grid
template = textwrap.dedent(
"""	<!DOCTYPE html><html><head><title>VCSeedFTP Log View</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<link rel="stylesheet" href="http://necolas.github.com/normalize.css/2.1.0/normalize.css">
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
	<script type="text/javascript" charset="utf-8">
	var $lists = %s
	</script>
	<style type="text/css">
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
		var main = $('#main')
		//prefix = 'file:///home/user/.config/vcseedftp/logs'
		prefix = 'logs'
		for (proj in $lists)
		{
			proj_uri = prefix + '/' + proj
			log_block = $("<h3 class='category'><a href='" + proj_uri + "'>" + proj + "</a><span class='icon-plus'> + </span></h3>")
			main.append(log_block)
			block_content = $("<div class='content' style='display: none;'/>")
			for (batch in $lists[proj])
			{
				batch_uri = proj_uri + '/' + batch +'/log'
				log_entry = $("<div class='log'><a href='#' path='" + batch_uri + "'>" + batch + "</a></div>")
				block_content.append(log_entry)
			}
			main.append(block_content)
		}
		main.on('click', 'h3', function() {
			$(this).next('.content').slideToggle('fast');
			$(this).find('span').toggleClass("icon-minus icon-plus");
			$(this).find('.icon-minus').html(' - ')
			$(this).find('.icon-plus').html(' + ')
		});
		main.on('click', '.log', function() {
			raw_path = $(this).find('a').attr('path');
			$('#preview').html($('<iframe>',{src:raw_path, width:'100%%', height:'100%%', border:0}));
		});
	});
	</script>
	<div id="preview"></div>
	</body></html>
	""")

## generate index.html for logs
def list_filenames_from_logs_dir(log_path='logs'):
	file_list = {}
	# log_path = os.path.join(os.getenv('XDG_CONFIG_HOME', os.path.join(os.getenv('HOME'),'.config')), 'vcseedftp', 'logs')
	for project in os.listdir(log_path):
		file_list.update({project: {}})
		project_path = os.path.join(log_path, project)
		for batch in os.listdir(project_path):
			batch_path = os.path.join(project_path, batch)
			log_list = [f for f in sorted(os.listdir(batch_path), reverse=True) if os.path.isfile(os.path.join(batch_path, f))]
			file_list[project].update({batch: log_list})
	filenames = json.dumps( file_list, indent=4 )
	index_template = template % (filenames, "")
	# FIXME: if place in logs/ and "for f in os.listdir(log_path) if os.path.isdir(f)" will give wrong results
	with open('log.html', 'w') as f:
		f.write(index_template )

if __name__ == "__main__":
	list_filenames_from_logs_dir()
