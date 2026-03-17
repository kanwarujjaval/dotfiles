# Tmux Configuration

Managed by [chezmoi](https://chezmoi.io).

**Prefix key:** `C-a` on macOS (local), `C-b` on Linux servers — enables nested sessions without conflicts.

## Status Bar

```
LEFT:  [logo] session-name ●○○ │ hostname:current-dir
RIGHT: [MODE] [HH:MM]
```

| Element | Description |
|---------|-------------|
| Logo | Monokai Pro theme icon |
| Session name | Current tmux session (`#S`) |
| Session dots | `●` active, `○` inactive sessions — visual overview at a glance |
| Hostname | `#h` — identifies which machine (local/sv/nuc) |
| Current dir | Basename of the active pane's working directory |
| Mode | `TMUX` (normal) / `PREFIX` (after prefix key) / `COPY` (copy mode) / `SYNC` (panes synced) |
| Time | `HH:MM` |

---

## Keybindings Reference

> All bindings use the prefix key unless marked **(no prefix)**.
> Prefix is `C-a` on macOS, `C-b` on Linux servers. Examples below use `<prefix>`.

### Core

| Binding | Action |
|---------|--------|
| `C-a` (mac) / `C-b` (linux) | Prefix key |
| `<prefix> r` | Reload tmux config |
| `<prefix> g` | Popup shell (80% overlay in current dir) |
| `<prefix> m` | Toggle mouse on/off |

### Pane Navigation

| Binding | Action |
|---------|--------|
| `<prefix> h` | Move to left pane |
| `<prefix> j` | Move to lower pane |
| `<prefix> k` | Move to upper pane |
| `<prefix> l` | Move to right pane |

All prefix-based — works correctly in nested tmux sessions (outer `C-a`, inner `C-b`).

### Pane Resize

| Binding | Action |
|---------|--------|
| `<prefix> H` | Resize pane left 5 cells (repeatable) |
| `<prefix> J` | Resize pane down 5 cells (repeatable) |
| `<prefix> K` | Resize pane up 5 cells (repeatable) |
| `<prefix> L` | Resize pane right 5 cells (repeatable) |
| `<prefix> z` | Toggle pane zoom (fullscreen) |

### Windows & Splits

| Binding | Action |
|---------|--------|
| `<prefix> c` | New window (inherits current directory) |
| `<prefix> "` | Split pane vertically (inherits cwd) |
| `<prefix> %` | Split pane horizontally (inherits cwd) |
| `<prefix> <` | Move window left (repeatable) |
| `<prefix> >` | Move window right (repeatable) |

### Session Management

| Binding | Action |
|---------|--------|
| `<prefix> s` | Browse sessions (tree view) |
| `<prefix> w` | Browse windows (tree view) |
| `<prefix> C` | Create new session |
| `<prefix> S` | Switch session by name (prompt) |
| `<prefix> D` | Choose and detach a client |
| `<prefix> y` | Toggle synchronized panes (type in all panes) |
| `<prefix> [` | Previous session |
| `<prefix> ]` | Next session |

### Sesh — Smart Session Manager

[Sesh](https://github.com/joshmedeski/sesh) provides an fzf-powered session picker with zoxide integration.

| Binding | Action |
|---------|--------|
| `<prefix> T` | Open sesh session picker |
| `<prefix> O` | Toggle to last session |

**Inside the sesh picker:**

| Binding | Action |
|---------|--------|
| `Ctrl+a` | Show all (sessions + zoxide + configs) |
| `Ctrl+t` | Show tmux sessions only |
| `Ctrl+g` | Show config directories only |
| `Ctrl+x` | Show zoxide directories |
| `Ctrl+f` | Find directories (fd search from ~) |
| `Ctrl+d` | Kill selected session |
| `Tab` / `Shift+Tab` | Navigate list |

### tmux-fzf — Fuzzy Finder

[tmux-fzf](https://github.com/sainnhe/tmux-fzf) provides fzf-powered management of tmux objects.

| Binding | Action |
|---------|--------|
| `<prefix> F` | Open tmux-fzf popup |

**Inside the fzf popup**, manage: sessions, windows, panes, commands, keybindings, processes.

---

## Copy & Paste

Mouse is **off by default** for native terminal copy/paste:

- **Select text** with mouse drag (native terminal selection)
- **Cmd+C** to copy, **Cmd+V** to paste (macOS)
- **Ctrl+Shift+C** / **Ctrl+Shift+V** (Linux terminals)
- **`<prefix> m`** toggles mouse on/off (when on: scroll, click panes, resize — but selection requires Shift+drag)

### Copy Mode (vi-style, for scrollback)

Enter copy mode with `<prefix> [` to navigate and copy from scrollback buffer.

| Binding | Action |
|---------|--------|
| `v` | Begin selection |
| `V` | Select entire line |
| `C-v` | Toggle rectangle selection |
| `y` | Copy selection and exit copy mode |
| `Escape` | Cancel and exit copy mode |

---

## Plugins

Managed by [TPM](https://github.com/tmux-plugins/tpm) (Tmux Plugin Manager).

| Plugin | Purpose |
|--------|---------|
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | Sensible defaults (utf8, history, key timeouts) |
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) | Save/restore sessions across tmux restarts |
| [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) | Auto-save sessions every 10 minutes, auto-restore on start |
| [monokai-pro.tmux](https://github.com/loctvl842/monokai-pro.tmux) | Monokai Pro color theme ("machine" palette) with styled status bar and mode indicator |
| [tmux-fzf](https://github.com/sainnhe/tmux-fzf) | fzf-powered session/window/pane/command management |
| [tmux-session-dots](https://github.com/jtmcginty/tmux-session-dots) | Visual `●○○` dots in status bar showing all sessions |

### TPM Commands

| Binding | Action |
|---------|--------|
| `<prefix> I` | Install new plugins |
| `<prefix> U` | Update plugins |
| `<prefix> Alt+u` | Remove uninstalled plugins |

---

## Session Persistence (Resurrect + Continuum)

Sessions are automatically saved every 10 minutes and restored when tmux starts.

- Neovim sessions are preserved (`resurrect-strategy-nvim: session`)
- Pane contents are captured on save
- Auto-restore is enabled on tmux server start

**Manual controls:**

| Binding | Action |
|---------|--------|
| `<prefix> C-s` | Save sessions now (resurrect) |
| `<prefix> C-r` | Restore sessions (resurrect) |

---

## Theme

**Monokai Pro** ("machine" palette — blue-tinted) with custom separators and modules.

Available palettes (change via `@monokai-pro-filter`): `pro`, `classic`, `machine`, `octagon`, `ristretto`, `spectrum`

Valid status modules: `logo`, `mode`, `datetime`

The status bar uses post-TPM injection (`set -ga`) to append session info, hostname, and working directory after the theme renders its styled modules.

---

## Core Settings

| Setting | Value | Why |
|---------|-------|-----|
| `default-terminal` | `tmux-256color` | True color support |
| `escape-time` | `10ms` | Fast ESC for vim (no lag) |
| `history-limit` | `200000` | Large scrollback buffer |
| `base-index` | `1` | Windows/panes start at 1, not 0 |
| `renumber-windows` | `on` | No gaps after closing windows |
| `automatic-rename` | `on` | Window tabs show running command |
| `mouse` | `off` | Native terminal copy/paste; toggle with `<prefix> m` |
| `mode-keys` | `vi` | Vi bindings in copy/search mode |
| `set-clipboard` | `external` | OSC 52 clipboard integration |
| `focus-events` | `on` | Neovim autoread support |
| `extended-keys` | `always` | Shift+Enter and other modified keys work in apps |
| `word-separators` | `@"=()[]{}:,.` | Better word-by-word selection in copy mode |

---

## File Structure

```
~/.config/tmux/
├── tmux.conf              # Main config (this file describes it)
├── tmux.local.conf        # OS-specific overrides (generated by chezmoi)
├── plugins/               # TPM-managed plugins (auto-installed)
│   ├── tpm/
│   ├── tmux-sensible/
│   ├── tmux-resurrect/
│   ├── tmux-continuum/
│   ├── monokai-pro.tmux/
│   ├── tmux-fzf/
│   └── tmux-session-dots/
└── README.md              # This file
```

**Chezmoi source:** `~/.local/share/chezmoi/dot_config/tmux/`

---

## Dependencies

| Tool | Required by | Install |
|------|-------------|---------|
| tmux 3.0+ | everything | `brew install tmux` / `apt install tmux` |
| fish | default shell | `brew install fish` / `apt install fish` |
| fzf | sesh, tmux-fzf | `brew install fzf` / `apt install fzf` |
| zoxide | sesh | `brew install zoxide` |
| fd | sesh (dir search) | `brew install fd` / `apt install fd-find` |
| sesh | session management | `brew install sesh` |
| neovim | editor | `brew install neovim` / `apt install neovim` |

---

## Quick Start

```bash
# Install plugins (first time or after adding new ones)
# Inside tmux, press: <prefix> I

# Reload config after editing
# Inside tmux, press: <prefix> r

# Or from command line:
tmux source ~/.config/tmux/tmux.conf
```
