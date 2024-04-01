# Donut.nvim

> donut.c meets Neovim

Donut.nvim is the Neovim screensaver that spawns a spinning donut in each opened Neovim window.

## 📺 Showcase


## 📋 Installation

[lazy](https://github.com/folke/lazy.nvim):

```lua
{
    "NStefan002/donut.nvim",
    event = "VeryLazy",
    opts = {
        -- your config
    },
}
```

[packer](https://github.com/wbthomason/packer.nvim):

```lua
use({
    "NStefan002/donut.nvim",
    config = function()
        require("donut").setup({
            -- your config
        })
    end,
})
```

[rocks.nvim](https://github.com/nvim-neorocks/rocks.nvim):

`:Rocks install donut.nvim`

### Configuration

<details>
    <summary>Full list of options:</summary>

```lua
{
    timeout = 60,
}
```
</details>

## 🎭 Inspiration
- [donut.c](https://www.a1k0n.net/2011/07/20/donut-math.html)

## Other Neovim screensavers
- [zone](https://github.com/tamton-aquib/zone.nvim)
- [cellular-automaton](https://github.com/Eandrju/cellular-automaton.nvim)
- [drop](https://github.com/folke/drop.nvim)
- [I'm waiting for this one](https://www.reddit.com/r/neovim/comments/1bsebep/raining_inside_neovim/)
