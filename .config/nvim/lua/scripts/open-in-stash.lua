local git = require("gitblame.git")
local utils = require("gitblame.utils")
local stash_pattern = "that's private"
local git_pattern = "also this one is private"

function convert_url(original, use_default_branch)

  -- we an optional stash/ substring and lua does not support optional non capture groups so we just replace it
  -- with an empty string
  local project, repo, ref, path, line = original:gsub("stash/", ""):match(git_pattern)
  local params = ""

  if not use_default_branch then
    params="?at="..ref
  end

  local stash_url = string.format(stash_pattern, project, repo, path, params, line)
  vim.cmd("!xdg-open '" .. stash_url .. "'")
end

vim.api.nvim_create_user_command('So',
  function(opts)
    local filepath = utils.get_filepath()

    if filepath == nil then
        return
    end

    local line_number = utils.get_line_number()

    git.get_file_url(filepath, line_number, function(url)
       convert_url(url, false)
    end)

  end,
  {}
)


vim.api.nvim_create_user_command('Sod',
  function(opts)
    local filepath = utils.get_filepath()

    if filepath == nil then
        return
    end

    local line_number = utils.get_line_number()

    git.get_file_url(filepath, line_number, function(url)
       convert_url(url, true)
    end)

  end,
  {}
)
