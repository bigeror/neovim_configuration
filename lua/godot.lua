-- Enables compatibility with godot game engine
-- disabled by default, enable only if you need it

return function(enabled)
    if not enabled then return end

    -- paths to check for project.godot file
    local paths_to_check = {'/', '/../'}
    local is_godot_project = false
    local godot_project_path = ''
    local cwd = vim.fn.getcwd()

    -- iterate over paths and check
    for key, value in pairs(paths_to_check) do
        if vim.uv.fs_stat(cwd .. value .. 'project.godot') then
            is_godot_project = true
            godot_project_path = cwd .. value
            break
        end
    end

    -- check if server is already running in godot project path
    local is_server_running = vim.uv.fs_stat(godot_project_path .. 'server.pipe')
    -- start server, if not already running
    if is_godot_project and not is_server_running then
        local test = vim.fn.serverstart(godot_project_path .. 'server.pipe')
        vim.print(test)
    end

    if is_godot_project then
        -- ignore *.uid files introduced in godot 4.4
        -- ignore server.pipe file
        vim.cmd('let NERDTreeIgnore = ["\\.uid$", "server.pipe"]')

        MiniFiles.config.content.filter = function (file)
            return not vim.endswith(file.name, ".uid") and
                file.name ~= "server.pipe" and
                not vim.startswith(file.name, ".")
        end
    end

    local function gdscript()
    local port = os.getenv 'GDScript_Port' or '6005'
    local cmd = vim.lsp.rpc.connect('127.0.0.1', tonumber(port))

    ---@type vim.lsp.Config
    return {
      cmd = cmd,
      filetypes = { 'gd', 'gdscript', 'gdscript3' },
      root_markers = { 'project.godot', '.git' },
    }
    end
    gdscript()
    vim.lsp.config('gdscript', {})
    vim.lsp.enable('gdscript')
end
