-- Helper module to read .gitignore and convert to telescope patterns
-- Uses lazy-loading and caching for performance
local M = {}

-- Cache storage
local cache = {
	patterns = nil,
	git_root = nil,
	timestamp = 0,
}

-- Cache TTL in seconds (patterns refresh after this time)
local CACHE_TTL = 300 -- 5 minutes

-- Binary/generated file patterns that should always be ignored
M.base_patterns = {
	-- Binary files
	"%.class$",
	"%.jar$",
	"%.war$",
	"%.ear$",
	"%.zip$",
	"%.tar%.gz$",
	"%.o$",
	"%.a$",
	"%.so$",
	"%.dylib$",
	"%.dll$",
	"%.exe$",
	"%.out$",
	-- Images
	"%.png$",
	"%.jpg$",
	"%.jpeg$",
	"%.gif$",
	"%.ico$",
	"%.pdf$",
	-- Lock files (usually not useful to search)
	"package%-lock%.json$",
	"yarn%.lock$",
	"pnpm%-lock%.yaml$",
	"Cargo%.lock$",
}

-- Get git root directory (cached)
local function get_git_root()
	local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
	if not handle then
		return nil
	end
	local result = handle:read("*l")
	handle:close()
	return result
end

-- Convert a gitignore pattern to a Lua pattern for telescope
local function gitignore_to_lua_pattern(pattern)
	-- Skip empty lines and comments
	if pattern == "" or pattern:match("^#") then
		return nil
	end

	-- Skip negation patterns (we don't support un-ignoring)
	if pattern:match("^!") then
		return nil
	end

	-- Remove trailing spaces
	pattern = pattern:gsub("%s+$", "")

	-- Remove leading/trailing slashes for normalization
	local anchored = pattern:match("^/") ~= nil
	pattern = pattern:gsub("^/", "")
	pattern = pattern:gsub("/$", "")

	-- Escape Lua pattern special characters (except * and ?)
	pattern = pattern:gsub("([%.%+%-%^%$%(%)%[%]%%])", "%%%1")

	-- Convert gitignore wildcards to Lua patterns
	-- ** matches any path
	pattern = pattern:gsub("%*%*", ".*")
	-- * matches anything except /
	pattern = pattern:gsub("%*", "[^/]*")
	-- ? matches single character except /
	pattern = pattern:gsub("%?", "[^/]")

	-- If pattern was anchored (started with /), anchor to start
	if anchored then
		pattern = "^" .. pattern
	end

	-- Directory patterns should match the directory and contents
	if not pattern:match("%$$") then
		pattern = pattern .. "/"
	end

	return pattern
end

-- Read patterns from a file
local function read_ignore_file(filepath)
	local patterns = {}
	local file = io.open(filepath, "r")
	if not file then
		return patterns
	end

	for line in file:lines() do
		local lua_pattern = gitignore_to_lua_pattern(line)
		if lua_pattern then
			table.insert(patterns, lua_pattern)
		end
	end

	file:close()
	return patterns
end

-- Build patterns (internal, called by lazy getter)
-- NOTE: We deliberately do NOT translate .gitignore into Lua patterns here.
-- ripgrep (used by telescope's find_command and vimgrep_arguments) already
-- honors .gitignore natively. Re-applying the same filter as Lua regex inside
-- telescope cost ~1.3s per find_files on a 7k-file monorepo (151 patterns x
-- ~7000 entries). The base binary/image patterns below are cheap and catch
-- files that .gitignore typically does NOT list (e.g. *.png, *.jar).
local function build_patterns()
	local patterns = {}

	for _, p in ipairs(M.base_patterns) do
		table.insert(patterns, p)
	end

	cache.git_root = get_git_root()

	table.insert(patterns, "^%.git/")

	return patterns
end

-- Check if cache is valid
local function is_cache_valid()
	if not cache.patterns then
		return false
	end
	local now = os.time()
	return (now - cache.timestamp) < CACHE_TTL
end

-- Get all ignore patterns for telescope (lazy-loaded with cache)
function M.get_file_ignore_patterns()
	if is_cache_valid() then
		return cache.patterns
	end

	cache.patterns = build_patterns()
	cache.timestamp = os.time()
	return cache.patterns
end

-- Force refresh the cache
function M.refresh_cache()
	cache.patterns = nil
	cache.timestamp = 0
	return M.get_file_ignore_patterns()
end

-- Get ripgrep arguments (ripgrep respects .gitignore by default)
function M.get_rg_args()
	return {
		"rg",
		"--color=never",
		"--no-heading",
		"--with-filename",
		"--line-number",
		"--column",
		"--smart-case",
		"--hidden", -- Search hidden files
		"--glob=!.git/", -- Always exclude .git
		-- ripgrep automatically respects .gitignore when in a git repo
	}
end

-- Command to refresh patterns manually
vim.api.nvim_create_user_command("RefreshIgnorePatterns", function()
	M.refresh_cache()
	vim.notify("Ignore patterns refreshed", vim.log.levels.INFO)
end, { desc = "Refresh telescope ignore patterns from .gitignore" })

return M
