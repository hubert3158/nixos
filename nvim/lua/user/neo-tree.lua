vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

-- Every tree-mutating command in neo-tree opens with `assert(state.tree:get_node())`
-- (sources/common/commands.lua). When the command runs against a state whose tree
-- was never rendered — refresh in flight, stale window — that assert throws a raw
-- E5108 stack trace ("attempt to index field 'tree' (a nil value)") instead of a
-- message. Wrap those commands so they warn and no-op instead.
--
-- Overriding through setup() rather than patching the module: setup deep-copies
-- the source command table (setup/init.lua:538), so a later patch of the module
-- would never be seen.
local fs_commands = require("neo-tree.sources.filesystem.commands")
local log = require("neo-tree.log")

local guarded_commands = {}
for _, name in ipairs({
	"add",
	"add_directory",
	"copy",
	"copy_to_clipboard",
	"copy_to_clipboard_visual",
	"cut_to_clipboard",
	"cut_to_clipboard_visual",
	"delete",
	"delete_visual",
	"move",
	"paste_from_clipboard",
	"rename",
	"rename_basename",
}) do
	local original = fs_commands[name]
	if type(original) == "function" then
		guarded_commands[name] = function(state, ...)
			if not state or not state.tree then
				log.warn("neo-tree: no tree in this window yet, reopen the explorer (<leader>e)")
				return
			end
			return original(state, ...)
		end
	end
end

require("neo-tree").setup({
	close_if_last_window = false,
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = true,
	filesystem = {
		follow_current_file = {
			enabled = true,
		},
		hijack_netrw_behavior = "open_default",
		commands = guarded_commands,
	},
	buffers = {
		follow_current_file = {
			enabled = true,
		},
	},
	git_status = {
		window = {
			position = "float",
		},
	},
})
