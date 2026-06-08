
local function import_directory(dir_path)
	local combined_data = {}
	local is_windows = package.config:sub(1, 1) == "\\"
	local cmd = is_windows and ("dir /b " .. dir_path:gsub("/", "\\")) or ("ls " .. dir_path)

	local p = io.popen(cmd)
	if not p then return combined_data end

	for file in p:lines() do
		if file:match("%.lua$") then
			local file_path = dir_path .. "/" .. file
			local chunk = assert(loadfile(file_path))
			local success, file_table = pcall(chunk)
			if success then
				table.insert(combined_data, file_table)
			else
				print("Runtime error in file " .. file .. ": " .. tostring(file_table))
			end
		end
	end
	p:close()

	return combined_data
end

local packages = import_directory(vim.fn.stdpath('config') .. "/lua/packages")

local function add_deps(deps)
	if not deps then
		return
	end

	for _, dep in ipairs(deps) do
		vim.pack.add({ dep })
	end
end

for _, value in ipairs(packages) do
	add_deps(value.dependencies)
	vim.pack.add({ value[1] })
	if value.event then
		vim.api.nvim_create_autocmd(value.event, {
			callback = function()
				value.setup()
			end,
			once = true,
		})
	elseif not value.lazy then
		value.setup()
	end
end

vim.api.nvim_create_autocmd("BufRead", {
	callback = function()
		for _, value in ipairs(packages) do
			if value.lazy then
				value.setup()
			end
		end
	end,
	once = true,
})
