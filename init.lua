local initializr = require("spring_initializr.initializr")

vim.api.nvim_create_user_command("SpringInitProject", initializr.create_project, {})
