return {
    -- "thalesgelinger/applenotes.nvim"
    name = "applenotes.nvim",
    dir = "/Users/thalesgelinger/Projects/personal/applenotes.nvim",
    dev = true,
    dependencies = {
        "nvim-telescope/telescope.nvim"  
    },
    config = function()
        require("applenote").setup({
          auto_save = true,
          default_folder = "dump",
        })
    end
}
