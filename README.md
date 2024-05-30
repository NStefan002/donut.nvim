# Donut.nvim

> donut.c meets Neovim

Donut.nvim is the Neovim screensaver that spawns a spinning donut in each opened Neovim window.

**Note:** donut.nvim does not change any of the buffers, it just creates new buffers on top of existing ones
and after you press any key it restores your buffers.

## 📺 Showcase

https://github.com/NStefan002/donut.nvim/assets/100767853/f1b538ff-e0a8-4aac-b33b-8392f12b4bae

## 📋 Installation

> [!NOTE]
>
> -   Neovim version >= 0.9.5 is required.
> -   No need to call `setup` function, donut.nvim is ready to use out of the box.
> -   Only call `setup` function if you want to change the default configuration.
> -   No need to lazy load it via Lazy.nvim, donut.nvim lazy loads by default.


[lazy](https://github.com/folke/lazy.nvim):

```lua
{
    "NStefan002/donut.nvim",
    version = "*",
    lazy = false,
}
```

[rocks.nvim](https://github.com/nvim-neorocks/rocks.nvim):

`:Rocks install donut.nvim`

## ⚙️ Configuration

<details>
    <summary>Default configuration</summary>

```lua
{
    timeout = 300,
    sync_donuts = false,
}
```
</details>

\
If you want to change the default configuration, you can call the `setup` function.

```lua
require("donut").setup({
    timeout = 60,
    sync_donuts = true,
}
```
or you can just set `vim.g.donut_config` to a table with the configuration you want.

```lua
vim.g.donut_config = { timeout = 30, sync_donuts = false }
```


## 🎭 Inspiration

-   [donut.c](https://www.a1k0n.net/2011/07/20/donut-math.html)

## Other Neovim screensavers

-   [zone](https://github.com/tamton-aquib/zone.nvim)
-   [cellular-automaton](https://github.com/Eandrju/cellular-automaton.nvim)
-   [drop](https://github.com/folke/drop.nvim)
-   [I'm waiting for this one](https://www.reddit.com/r/neovim/comments/1bsebep/raining_inside_neovim/)
