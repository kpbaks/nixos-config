# https://www.nushell.sh/book/line_editor.html#user-defined-menus
$env.config.menus = [
	{
		name: frozen_jobs
		marker: "job "
					type: {


layout: list
page_size: 5
		}
		style: {
			text: blue
			selected_text: blue_reverse
			description_text: yellow
		}
		source: { |buffer, position|
	job list | where type == frozen | each { |row| {value: $row.pids.0 description: "desc"} }
		}
	}
]

# each line with a selection with only whitespace or EOL to the right of it
# specifically the remote-trailing-whitespace when editor is unfocused and write file on unfocus is enabled

$env.config.keybindings = [
        {
          name: ctrl-z
          modifier: control
          keycode: char_z
          mode: [emacs vi_insert]
		event: {
			until: [
				{send: executehostcommand cmd: "if (job list | where type == frozen | is-not-empty) { job unfreeze e> /dev/null }"}
				{edit: Undo}
			]
		}
          # event: { send: }
        }
      ]
