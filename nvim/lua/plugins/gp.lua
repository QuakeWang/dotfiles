return {
  "robitx/gp.nvim",
  config = function()
    require("gp").setup({
      openai_api_key = { "bw", "get", "notes", "openai_key" },
      chat_confirm_delete = false,
      hooks = {
        Review = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please analyze for code smells and suggest improvement."
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.popup, nil, agent.model, template, agent.system_prompt)
        end,

        UnitTests = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please respond by writing table driven unit tests for the code above."
          local agent = gp.get_command_agent()
          gp.Prompt(params, gp.Target.enew, nil, agent.model, template, agent.system_prompt)
        end,

        BufferChatNew = function(gp, _)
          vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew" .. " vsplit")
        end,
      },
    })
  end,
  keys = {
    { "<C-\\>", "<cmd>GpChatToggle<cr>", mode = { "n", "i" }, desc = "Toggle GPT chat" },
    { "<C-\\>", ":<C-u>'<,'>GpChatToggle<cr>", mode = { "v" }, desc = "Toggle GPT chat Visual mode" },
  },
}
