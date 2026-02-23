# LazyVim Essential Cheat Sheet

## File Explorer (Neo-tree)
| Key          | Action                                    |
|--------------|-------------------------------------------|
| `<leader>e`  | Toggle file explorer                      |
| `a`          | Create new file/folder (add `/` for folder) |
| `r`          | Rename file/folder                        |
| `d`          | Delete file/folder                        |
| `c`          | Copy file/folder                          |
| `x`          | Cut file/folder                           |
| `p`          | Paste file/folder                         |
| `<CR>`       | Open file                                 |
| `<Space>`    | Preview file                              |
| `H`          | Show hidden files                         |
| `R`          | Refresh tree                              |

## Navigation & Movement
| Key          | Action                                    |
|--------------|-------------------------------------------|
| `<leader>ff` | Find files (Telescope)                    |
| `<leader>fg` | Live grep (search in files)               |
| `<leader>fb` | Find buffers                              |
| `<leader>fr` | Recent files                              |
| `]]`         | Next function/class                       |
| `[[`         | Previous function/class                   |
| `}`          | Next paragraph/block                      |
| `{`          | Previous paragraph/block                  |
| `%`          | Jump to matching bracket                  |
| `gd`         | Go to definition                          |
| `gr`         | Go to references                          |
| `<C-o>`      | Go back                                   |
| `<C-i>`      | Go forward                                |

## Editing
| Key          | Action                                    |
|--------------|-------------------------------------------|
| `<leader>ca` | Code actions                              |
| `<leader>cr` | Rename symbol                             |
| `<leader>cf` | Format code                               |
| `gcc`        | Comment line                              |
| `gc`         | Comment selection (visual mode)           |
| `<leader>uw` | Toggle word wrap                          |
| `<leader>ul` | Toggle line numbers                       |
| `<leader>uc` | Toggle colorscheme                        |

## Buffers & Windows
| Key          | Action                                    |
|--------------|-------------------------------------------|
| `<leader>bd` | Delete buffer                             |
| `<S-h>`      | Previous buffer                           |
| `<S-l>`      | Next buffer                               |
| `<C-h/j/k/l>`| Navigate windows                          |
| `<leader>w`  | Window commands                           |
| `<leader>ww` | Other window                              |
| `<leader>wd` | Delete window                             |
| `<leader>ws` | Split window below                        |
| `<leader>wv` | Split window right                        |

## Search & Replace
| Key          | Action                                    |
|--------------|-------------------------------------------|
| `<leader>sg` | Grep (search in project)                 |
| `<leader>sw` | Search word under cursor                  |
| `<leader>sr` | Search & replace                          |
| `/`          | Search in file                            |
| `n`          | Next search result                        |
| `N`          | Previous search result                    |
| `<leader>nh` | Clear search highlight                    |

## Git (if setup)
| Key          | Action                                    |
|--------------|-------------------------------------------|
| `<leader>gg` | Lazygit                                   |
| `<leader>gb` | Git blame                                 |
| `<leader>gf` | Git files                                 |

## Quick Actions
| Key          | Action                                    |
|--------------|-------------------------------------------|
| `<leader><leader>` | Find files                          |
| `<leader>:`  | Command history                           |
| `<leader>qq` | Quit all                                  |
| `<leader>wq` | Save and quit                             |
| `K`          | Show hover info                           |
| `<leader>xl` | Location list                             |
| `<leader>xq` | Quickfix list                             |

---
**Note**: `<leader>` is typically `Space` in LazyVim.

## Vim Basics (if you need them)
| Key          | Action                                    |
|--------------|-------------------------------------------|
| `i`          | Insert mode                               |
| `v`          | Visual mode                               |
| `V`          | Visual line mode                          |
| `<C-v>`      | Visual block mode                         |
| `:w`         | Save file                                 |
| `:q`         | Quit                                      |
| `:wq`        | Save and quit                             |
| `u`          | Undo                                      |
| `<C-r>`      | Redo                                      |
| `dd`         | Delete line                               |
| `yy`         | Copy line                                 |
| `p`          | Paste                                     |
