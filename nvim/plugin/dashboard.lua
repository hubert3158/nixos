-- Dashboard — configured eagerly so the start screen renders correctly on
-- first paint (was previously re-configured after UIEnter, racing the draw).

require("dashboard").setup({
	theme = "doom",
	config = {
		header = {
			"                                                       ",
			"                                                       ",
			"                                                       ",
			" ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
			" ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
			" ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
			" ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
			" ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
			" ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
			"                                                       ",
			"                  Professional Setup                  ",
			"                                                       ",
		},
		center = {
			{
				icon = " ",
				desc = "Find File                            ",
				key = "f",
				action = "Telescope find_files",
			},
			{
				icon = " ",
				desc = "Recent Files                        ",
				key = "r",
				action = "Telescope oldfiles",
			},
			{
				icon = " ",
				desc = "Live Grep                           ",
				key = "g",
				action = "Telescope live_grep",
			},
			{
				icon = " ",
				desc = "New File                            ",
				key = "n",
				action = "enew",
			},
			{
				icon = " ",
				desc = "Config                              ",
				key = "c",
				action = "edit $MYVIMRC",
			},
			{
				icon = " ",
				desc = "Quit                                ",
				key = "q",
				action = "quit",
			},
		},
		footer = {
			"",
			"🚀 Ready to code!",
		},
	},
})
