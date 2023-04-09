local keymap = vim.keymap.set
return {

  {
    'tamton-aquib/duck.nvim',
    config = function()
      local duck = require('duck')
      vim.api.nvim_create_user_command('Duck',
        function(opts)
          if (opts.args == 'duck') then
            duck.hatch('🐤')
          elseif (opts.args == 'eggplant') then
            duck.hatch('🍆')
          elseif (opts.args == 'water') then
            duck.hatch('💧')
          elseif (opts.args == 'cook') then
            duck.cook()
          else
            duck.hatch()
          end
        end,
        {
          nargs = 1,
          complete = function(_, _, _) return { 'duck', 'eggplant', 'water', 'cook' } end
        })
      keymap('n', '<leader>dk', function() duck.cook() end, { desc = "kill ducks" })
    end
  },
  {
    'eandrju/cellular-automaton.nvim',
    config = function()
      keymap("n", "<leader>fml", "<cmd>CellularAutomaton game_of_life<CR>", { desc = "cellular game of life" })
    end
  },
  { 'danilamihailov/beacon.nvim' },
}
