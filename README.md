# Donut.nvim

> donut.c meets Neovim

Donut.nvim is the Neovim screensaver that spawns a spinning donut in each opened Neovim window.

**Note:** donut.nvim does not change any of the buffers, it just creates new buffers on top of existing ones
and after you press any key it restores your buffers.

## 📺 Showcase


https://github.com/NStefan002/donut.nvim/assets/100767853/f1b538ff-e0a8-4aac-b33b-8392f12b4bae



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
    sync_donuts = false,
}
```
</details>

## ✅☑️ TODO
- [ ] add colors to donuts
- [ ] center donut horizontally inside of the window

## 🎭 Inspiration
- [donut.c](https://www.a1k0n.net/2011/07/20/donut-math.html)

## Other Neovim screensavers
- [zone](https://github.com/tamton-aquib/zone.nvim)
- [cellular-automaton](https://github.com/Eandrju/cellular-automaton.nvim)
- [drop](https://github.com/folke/drop.nvim)
- [I'm waiting for this one](https://www.reddit.com/r/neovim/comments/1bsebep/raining_inside_neovim/)
