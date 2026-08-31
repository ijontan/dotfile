
local root_markers = { '.git', 'Makefile' }
local root = vim.fs.root(0, root_markers)

local function run_cmd_in_buffer(...)

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(0, buf)

	vim.fn.jobstart({ ... }, {
		cwd = root,
		term = true,
	})

	vim.keymap.set("n", "q", ":close<CR>", { buffer = buf, silent = true })
end

vim.api.nvim_create_user_command('BuildCurrentFile', function()
	local rel_path = vim.fn.expand("%:.")
	local obj_path = vim.system({ "make", rel_path .. ".printobj" }, { cwd = root, text = true }):wait()

	vim.cmd("10split")
	run_cmd_in_buffer("make", obj_path.stdout)
end, {})

vim.api.nvim_create_user_command('Build', function()
	vim.cmd("split")

	run_cmd_in_buffer("make", "-j10")
end, {})
