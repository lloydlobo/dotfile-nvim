# nvim

a minimal, distraction-free Neovim configuration without plugins.

---

## notes

- Too spartan? -> `alias vim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'`
  ![NVIM_APPNAME="nvim-kickstart"](./docs/nvim-appname.gif)

- Format code? -> `stylua init.lua`

---

## keybindings

| Key         | Action                              |
| ----------- | ----------------------------------- |
| `<Esc>`     | Clear search highlighting           |
| `<leader>d` | Delete buffer                       |
| `<leader>m` | List marks/bookmarks                |
| `<leader>M` | Delete all marks                    |
| `<leader>y` | Yank file path to clipboard         |
| `<leader>c` | Run shell command in scratch buffer |

### marks (Built-in Bookmarks)

- `m{a-z}` — Set local mark
- `m{A-Z}` — Set global mark (across files)
- `'{a-z}` — Jump to mark (line)
- `` `{a-z}`` — Jump to mark (exact position)

---

## default mappings

```txt
DEFAULT MAPPINGS
                                                        *default-mappings*
Nvim creates the following default mappings at |startup|. You can disable any
of these in your config by simply removing the mapping, e.g. ":unmap Y". If
you never want any default mappings, call |:mapclear| early in your config.

- Y |Y-default|
- <C-U> |i_CTRL-U-default|
- <C-W> |i_CTRL-W-default|
- <C-L> |CTRL-L-default|
- & |&-default|
- Q |v_Q-default|
- @ |v_@-default|
- # |v_#-default|
- * |v_star-default|
- gc |gc-default| |v_gc-default| |o_gc-default|
- gcc |gcc-default|
- gr prefix |gr-default|
  - |grn|
  - |grr|
  - |gra|
  - |gri|
  - |grt|
  - |gO|
- <C-S> |i_CTRL-S|
- ]d |]d-default|
- [d |[d-default|
- [D |[D-default|
- ]D |]D-default|
- <C-W>d |CTRL-W_d-default|
- |[q|, |]q|, |[Q|, |]Q|, |[CTRL-Q|, |]CTRL-Q|
- |[l|, |]l|, |[L|, |]L|, |[CTRL-L|, |]CTRL-L|
- |[t|, |]t|, |[T|, |]T|, |[CTRL-T|, |]CTRL-T|
- |[a|, |]a|, |[A|, |]A|
- |[b|, |]b|, |[B|, |]B|
- |[<Space>|, |]<Space>|
- Nvim LSP client defaults |lsp-defaults|
  - K |K-lsp-default|

- |g;|, |g,| |CHANGE LIST JUMPS|
- |g?{motion}| |Rot13 encode {motion} text.|

 vim:tw=78:ts=8:sw=2:et:ft=help:norl:
```

---

## references

- [why I got rid of all my neovim plugins — yobibyte]
  - [yobibyte/yobitools/dotfiles/init.lua]
  - [wdomitrz/kitty_gruvbox_theme]
- [raster CRT Typography — masswerk]
- [devhints.io/vim]

---

[why I got rid of all my neovim plugins — yobibyte]: https://yobibyte.github.io/vim.html
[yobibyte/yobitools/dotfiles/init.lua]: https://github.com/yobibyte/yobitools/blob/main/dotfiles/init.lua
[wdomitrz/kitty_gruvbox_theme]: https://raw.githubusercontent.com/wdomitrz/kitty_gruvbox_theme/refs/heads/master/gruvbox_light.conf
[Raster CRT Typography — masswerk]: https://www.masswerk.at/nowgobang/2019/dec-crt-typography
[devhints.io/vim]: https://devhints.io/vim
