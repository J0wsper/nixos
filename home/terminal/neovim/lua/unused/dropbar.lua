local dropbar_api = require('dropbar.api')
map('<leader>;', dropbar_api.pick, "Pick symbols in winbar")
map('[;', dropbar_api.goto_context_start, "Go to start of current context")
map('];', dropbar_api.select_next_context, "Select next context")
