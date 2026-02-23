# Neovim Keybindings Cheatsheet

> **Leader key = `Space`**

---

## 🚀 Quick Reference (Most Used)

| Key | Action |
|-----|--------|
| `<leader><leader>` | Find files |
| `<leader>e` | Toggle file explorer |
| `<leader>sg` | Grep search in project |
| `<leader>a` | Harpoon: add file |
| `Ctrl-e` | Harpoon: quick menu |
| `gd` | Go to definition |
| `K` | Show hover docs |

---

## 📌 Harpoon (Quick File Switching)

| Key | Action |
|-----|--------|
| `<leader>a` | Add current file to Harpoon |
| `Ctrl-e` | Open Harpoon quick menu |
| `<leader>h1` | Jump to Harpoon file 1 |
| `<leader>h2` | Jump to Harpoon file 2 |
| `<leader>h3` | Jump to Harpoon file 3 |
| `<leader>h4` | Jump to Harpoon file 4 |
| `Ctrl-p` | Previous Harpoon file |
| `Ctrl-n` | Next Harpoon file |

**Tip**: In Harpoon menu, reorder files by moving lines (`dd` then `p`).

---

## 🔍 Finding & Searching

### Telescope (Fuzzy Finder)
| Key | Action |
|-----|--------|
| `<leader><leader>` | Find files |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search content) |
| `<leader>sg` | Grep search in project |
| `<leader>sw` | Search word under cursor |
| `<leader>fb` | Find open buffers |
| `<leader>fr` | Recent files |
| `<leader>fp` | Find plugin files |
| `<leader>:` | Command history |
| `<leader>sk` | Search keymaps |
| `<leader>sh` | Search help |

**In Telescope**:
- `Ctrl-j/k` — Navigate results
- `Enter` — Open file
- `Ctrl-x` — Open in horizontal split
- `Ctrl-v` — Open in vertical split
- `Esc` — Close

### In-File Search
| Key | Action |
|-----|--------|
| `/` | Search forward |
| `?` | Search backward |
| `n` | Next match |
| `N` | Previous match |
| `*` | Search word under cursor (forward) |
| `#` | Search word under cursor (backward) |
| `<leader>sr` | Search & replace |

---

## 📁 File Explorer (Neo-tree)

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle explorer (focus) |
| `<leader>E` | Toggle explorer (root) |

**Inside Neo-tree**:
| Key | Action |
|-----|--------|
| `Enter` | Open file |
| `Space` | Preview file |
| `a` | Create file (add `/` for folder) |
| `r` | Rename |
| `d` | Delete |
| `c` | Copy |
| `x` | Cut |
| `p` | Paste |
| `H` | Toggle hidden files |
| `R` | Refresh |
| `/` | Filter |
| `?` | Show help |

---

## 🧭 Navigation & Movement

### Basic Motions
| Key | Action |
|-----|--------|
| `h j k l` | Left, Down, Up, Right |
| `w` | Next word start |
| `b` | Previous word start |
| `e` | Next word end |
| `W/B/E` | Same but by WORD (whitespace delimited) |
| `0` | Start of line |
| `^` | First non-blank character |
| `$` | End of line |
| `gg` | First line of file |
| `G` | Last line of file |
| `{number}G` | Go to line number |
| `%` | Jump to matching bracket |
| `{` / `}` | Previous/next paragraph |
| `[[` / `]]` | Previous/next function |

### Jumping
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `gy` | Go to type definition |
| `Ctrl-o` | Jump back (older) |
| `Ctrl-i` | Jump forward (newer) |
| `''` | Jump to last position |

### Scrolling
| Key | Action |
|-----|--------|
| `Ctrl-d` | Scroll down half page |
| `Ctrl-u` | Scroll up half page |
| `Ctrl-f` | Scroll down full page |
| `Ctrl-b` | Scroll up full page |
| `zz` | Center cursor on screen |
| `zt` | Cursor to top of screen |
| `zb` | Cursor to bottom of screen |

---

## 📝 Editing

### Insert Mode Entry
| Key | Action |
|-----|--------|
| `i` | Insert before cursor |
| `I` | Insert at line start |
| `a` | Insert after cursor |
| `A` | Insert at line end |
| `o` | New line below |
| `O` | New line above |
| `s` | Delete char and insert |
| `S` | Delete line and insert |

### Operators (combine with motions)
| Key | Action |
|-----|--------|
| `d` | Delete |
| `c` | Change (delete + insert) |
| `y` | Yank (copy) |
| `>` | Indent right |
| `<` | Indent left |

**Examples**: `dw` delete word, `ci"` change inside quotes, `yap` yank paragraph

### Quick Edits
| Key | Action |
|-----|--------|
| `dd` | Delete line |
| `yy` | Yank line |
| `cc` | Change line |
| `D` | Delete to end of line |
| `C` | Change to end of line |
| `x` | Delete character |
| `r{char}` | Replace character |
| `~` | Toggle case |
| `J` | Join lines |
| `u` | Undo |
| `Ctrl-r` | Redo |
| `.` | Repeat last change |

### Comments
| Key | Action |
|-----|--------|
| `gcc` | Comment/uncomment line |
| `gc{motion}` | Comment motion (e.g., `gcap` comment paragraph) |
| `gc` (visual) | Comment selection |

---

## 🎯 Text Objects

Use with operators: `d`, `c`, `y`, `v`

| Key | Meaning |
|-----|---------|
| `iw` / `aw` | Inner/around word |
| `i"` / `a"` | Inner/around double quotes |
| `i'` / `a'` | Inner/around single quotes |
| `i)` / `a)` | Inner/around parentheses |
| `i]` / `a]` | Inner/around brackets |
| `i}` / `a}` | Inner/around braces |
| `it` / `at` | Inner/around HTML tag |
| `ip` / `ap` | Inner/around paragraph |
| `if` / `af` | Inner/around function |

**Examples**:
- `ci"` — Change inside double quotes
- `da)` — Delete around parentheses
- `vif` — Select inside function
- `yap` — Yank around paragraph

---

## 🪟 Windows & Buffers

### Buffers
| Key | Action |
|-----|--------|
| `Shift-h` | Previous buffer |
| `Shift-l` | Next buffer |
| `<leader>bd` | Delete buffer |
| `<leader>bD` | Delete buffer (force) |
| `<leader>fb` | Find buffers |

### Windows
| Key | Action |
|-----|--------|
| `Ctrl-h/j/k/l` | Navigate windows |
| `<leader>w` | Window menu |
| `<leader>ww` | Switch to other window |
| `<leader>wd` | Delete window |
| `<leader>ws` | Split horizontal |
| `<leader>wv` | Split vertical |
| `<leader>w=` | Equalize window sizes |
| `Ctrl-w +/-` | Increase/decrease height |
| `Ctrl-w >/<` | Increase/decrease width |

### Tabs
| Key | Action |
|-----|--------|
| `<leader><tab>l` | Last tab |
| `<leader><tab>f` | First tab |
| `<leader><tab><tab>` | New tab |
| `<leader><tab>d` | Close tab |
| `<leader><tab>]` | Next tab |
| `<leader><tab>[` | Previous tab |

---

## 💻 LSP & Code

| Key | Action |
|-----|--------|
| `K` | Hover documentation |
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `<leader>ca` | Code actions |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format file |
| `<leader>cd` | Line diagnostics |
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |
| `]e` | Next error |
| `[e` | Previous error |
| `]w` | Next warning |
| `[w` | Previous warning |

---

## 🌿 Git

| Key | Action |
|-----|--------|
| `<leader>gg` | Open Lazygit |
| `<leader>gG` | Lazygit (cwd) |
| `<leader>gb` | Git blame line |
| `<leader>gB` | Git browse |
| `<leader>gf` | Git files |
| `<leader>gc` | Git commits |
| `<leader>gs` | Git status |
| `]h` | Next hunk |
| `[h` | Previous hunk |
| `<leader>ghp` | Preview hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghs` | Stage hunk |

---

## ⚙️ UI Toggles

| Key | Action |
|-----|--------|
| `<leader>uw` | Toggle word wrap |
| `<leader>ul` | Toggle line numbers |
| `<leader>uL` | Toggle relative numbers |
| `<leader>us` | Toggle spelling |
| `<leader>ud` | Toggle diagnostics |
| `<leader>uc` | Toggle conceal |
| `<leader>uf` | Toggle format on save |

---

## 🔧 Misc

| Key | Action |
|-----|--------|
| `<leader>qq` | Quit all |
| `<leader>l` | Lazy plugin manager |
| `<leader>cm` | Mason (LSP installer) |
| `<leader>xl` | Location list |
| `<leader>xq` | Quickfix list |
| `<leader>fn` | New file |

---

## 💡 Pro Tips

1. **Combine operators + motions**: `d2w` deletes 2 words, `c$` changes to end of line
2. **Use `.` to repeat**: Make a change, then `.` repeats it
3. **Text objects are powerful**: `ci(` to change inside parens, `da"` to delete around quotes
4. **Use `*` and `#`**: Quick search for word under cursor
5. **Harpoon for project files**: Add your most-used files (tests, main, config)
6. **`Ctrl-o` in insert mode**: Execute one normal mode command, then return to insert

---

*Press `<leader>sk` to search all keymaps in Telescope*
