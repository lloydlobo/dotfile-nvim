# Hacks

## Today I Learned (TIL)

| Shortcut/Command             | Description                                                                                     |
| ---------------------------- | ----------------------------------------------------------------------------------------------- |
| `!column -c=30` (Visual)     | Pretty print long rows into columns with --output-width=30.                                     |
| `!echo $?`                   | Show the exit code of the last command.                                                         |
| `!jq -r` (Visual)            | Pretty print minified json object with `jq`.                                                    |
| `$ vim * -p`                 | Opens all files in the current directory in separate tabs.                                      |
| `'a`, `'A`                   | Return to a mark in the file (local/global).                                                    |
| `20%`                        | Go to 20% of the file                                                                           |
| `8g8`                        | Find illegal UTF-8 byte sequences.                                                              |
| `:C-f`                       | Open previous commands in an editable buffer.                                                   |
| `:[any letter]` → `<Ctrl-d>` | Show all possible commands starting with the letter.                                            |
| `:e $MYVIMRC`                | Opens your Neovim config file.                                                                  |
| `:hor term`                  | Opens terminal in a horizontal split.                                                           |
| `:norm A";`                  | Append `";` at the end of each visual-selected line.                                            |
| `:norm`                      | Execute normal mode commands in command-line mode.                                              |
| `:r !dir`                    | Reads shell command output into the buffer.                                                     |
| `:sort!`                     | Sorts in reverse lexicographical order.                                                         |
| `C-\ C-n`                    | Escape INSERT mode in terminal (`:term`).                                                       |
| `C-^` / `C-6`                | Switch between the last two files.                                                              |
| `C-j` / `C-M`                | Simulate `Enter` key press.                                                                     |
| `C-n`, `C-x C-f`             | Autocomplete words, filenames, and paths.                                                       |
| `C-o`                        | Continue where you left off when reopening Neovim.                                              |
| `C-t`                        | Go back after jumping to a definition (LSP helper).                                             |
| `C-w o`                      | Close all other windows except the current one.                                                 |
| `C-x C-f`                    | Expand any $PATH-like variable under cursor. `*:set_env* *expand-env* *expand-environment-var*` |
| `D`                          | Delete from cursor to end of line.                                                              |
| `M-o` / `M-O`                | Insert new line below/above (Alt + o/O).                                                        |
| `g C-a`                      | Increment numbers across multiple lines in visual selection.                                    |
| `g,`                         | Go to [count] newer position in change list.                                                    |
| `g8`                         | Print hex values of a UTF-8 character.                                                          |
| `g;`                         | Go to [count] "2g; -> go to second..." older position in change list. (similar to git hunks?)   |
| `g?`                         | Rot13 encode {motion} text (quick Caesar Cypher).                                               |
| `gM`                         | Like "g0", but to halfway the text of the line.                                                 |
| `g^a`                        | increment rows of `0` in incremental order (`0 0 0 0` → `1 2 3 4`).                             |
| `g_`                         | Go to the last non-blank character of the line.                                                 |
| `ga`                         | Print ASCII value of the character under the cursor.                                            |
| `gi`                         | Go to the last inserted text location.                                                          |
| `gm`                         | Like "g0", but half a screenwidth to the right (or as much as possible).                        |
| `go`                         | Go to the first column in the first line. (similar to gg, which maintains column number)        |
| `gp`                         | Just like "p", but leave the cursor just after the new text.                                    |
| `gv`                         | Reselect the last visual selection.                                                             |
| `gx`                         | Open links in popups (like LSP windows) OR edit file under cursor.                              |
| `g~it`                       | Capitalize text inside tags.                                                                    |
| `ma`, `mA`                   | Set a mark in the file (local/global).                                                          |
| `o` (Visual)                 | Switch cursor position while selecting.                                                         |
| `vg_`                        | Select from cursor to last non-blank character of the line.                                     |
| `vib`, `viB`                 | Select inside `()`, `{}`.                                                                       |
| `z=`                         | Spelling suggestions.                                                                           |

### todo | from kickstart

| `vib`, `viB`, `viq`, `vit`   | Select inside `()`, `{}`, `""`, `<tags>`.                                                       |
| `<leader>/`                  | Fuzzy search in current buffer.                                                                 |
| `F8`                         | Toggle debugger (DAP) view.                                                                     |

---
  			
## Digraphs & Special Characters

| Input            | Output    | Description          |
| ---------------- | --------- | -------------------- |
| `'B' <BS> 'B'`   | `¦` (166) | Broken vertical bar. |
| `'a' <BS> '>'`   | `â` (226) | A with circumflex.   |
| `CTRL-K '-' '-'` | `­` (173) | Soft hyphen.         |
| `i C-k hh`       | `─`       | Horizontal line.     |
| `CTRL-K 'O' 'K'` | `✓`       | Checkmark.         |

---

## Terminal Commands

| Command           | Description                                           |
| ----------------- | ----------------------------------------------------- |
| `$ stty -a`       | Display all terminal settings.                        |
| `$ stty erase ^H` | Set backspace to `^H` (use `Ctrl-v Ctrl-h` to input). |

---

## Search & Preview Settings

| Command                  | Description                                           |
| ------------------------ | ----------------------------------------------------- |
| `:%s/search/replace/gc`  | Step through each substitution                        |
| `:%s@search@replace@gc`  | search or replace string has /, no need of \ escape.  |
| `:set inccommand=split`  | Show live preview of substitutions in a split window. |
| `:set previewheight=<n>` | Set preview window height.                            |

---

## Miscellaneous Commands

| Command                     | Description                                |
| --------------------------- | ------------------------------------------ |
| `:[range]# [count] [flags]` | Synonym for `:number` (show line numbers). |

---

## Multiple Neovim Configurations

| Feature                                                                             | Description                                                 |
| ----------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| `NVIM_APPNAME=nvim-NAME`                                                            | Use different config directories.                           |
| Example:                                                                            | `alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'` |
| Config Path:                                                                        | `~/.config/nvim-kickstart`                                  |
| Data Path:                                                                          | `~/.local/share/nvim-kickstart`                             |
| [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim?tab=readme-ov-file#faq) | More info on using multiple Neovim configurations.          |

---

## Parallel Processing

| Command                                  | Description                                                  |
| ---------------------------------------- | ------------------------------------------------------------ |
| `$ parallel -j4 --bar --eta tokei ::: .` | Run `tokei` (code statistics tool) in parallel across files. |

---

## Terminal tricks

### popd pushd

...

### history

- C-r (reverse-i-search)
- C-s (fwd-i-search)

### Delete before/after cursor

- C-U (before)
- C-k (after)

### Redirections

- `1>` (stdout)
- `2>` (stderr)

### man command sections

> Source: https://www.howtogeek.com/663440/how-to-use-linuxs-man-command-hidden-secrets-and-basics/
> The sections are:
>
> 1. General commands: Commands you use on the command line.
> 2. System calls: Functions the kernel provides that a program can call.
> 3. Library functions: Functions programs can call in code libraries (mainly the C standard).
> 4. Special files: Usually devices, such as those found in /dev, and their drivers.
> 5. File formats and conventions: Formats for files, such as the passwd, cron table, and tar archive files.
> 6. Games: Descriptions of commands, like fortune, that display quotes from a database when you run them.
> 7. Miscellaneous: Descriptions of things like inodes, boot parameters, and man itself.
> 8. System administration: Commands and daemons usually reserved for root to work with.
> 9. Kernel Routines: Information related to the internal operation of the kernel.
>    This includes function interfaces and variables useful to programmers who
>    are writing device drivers, for example. On most systems, this section isn't installed.

Example:

```sh
man 1 passwd
man 3 passwd
man 5 passwd
```

---

## 📚 Lua & Neovim Documentation

| Resource                                                      | Description                               |
| ------------------------------------------------------------- | ----------------------------------------- |
| [Learn Lua](https://learnxinyminutes.com/docs/lua/)           | Quick Lua syntax reference.               |
| `:help lua-guide`                                             | Neovim's Lua guide documentation.         |
| [Neovim Lua Guide](https://neovim.io/doc/user/lua-guide.html) | HTML version of the Neovim Lua guide.     |
| `:options`                                                    | Type \|gO\| to see the table of contents. |

---

<!-- 
vim:filetype=markdown:
vim:tw=78:ts=4:sw=4:et:ft=help:norl:
-->
