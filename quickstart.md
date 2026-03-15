# Dotfiles Quickstart

Single reference for managing dotfiles with [chezmoi](https://www.chezmoi.io/).

---

## Repo Structure

```
~/.local/share/chezmoi/            # chezmoi source (this repo)
├── .chezmoi.toml.tmpl             # machine config prompts (role, email, etc.)
├── .chezmoidata/packages.yaml     # all packages: brew, apt, npm, manual
├── .chezmoiignore                 # files excluded per OS
├── .chezmoiscripts/               # run_once / run_onchange scripts
├── Brewfile.tmpl                  # generated from packages.yaml
├── dot_config/                    # ~/.config (fish, nvim, tmux, starship, k9s, gh)
├── dot_local/bin/                 # ~/.local/bin (bootstrap, doctor)
├── private_dot_ssh/               # ~/.ssh (config, allowed_signers)
├── dot_gitconfig.tmpl             # git config (signing, user, merge)
├── dot_gitconfig.local.tmpl       # work-specific safe directories
├── dot_bashrc.tmpl                # minimal bashrc
├── dot_zshrc.tmpl                 # minimal zshrc
├── dot_profile.tmpl               # PATH additions
└── dot_ideavimrc                  # JetBrains vim keybinds (macOS only)
```

---

## New Machine Bootstrap

### macOS

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install chezmoi and init from GitHub
brew install chezmoi
chezmoi init --apply <your-github-username>
```

You'll be prompted for:
- **Machine role**: `mac-workstation` or `ubuntu-server`
- **Is work machine**: yes/no (adds work email + safe directories)
- **Full name / email**: for git config

After `chezmoi apply`, run scripts automatically:
1. Set fish as default shell
2. Install TPM (tmux plugin manager)
3. `brew bundle` to install all formulae and casks

### Ubuntu

```bash
# 1. Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <your-github-username>
```

Same prompts. Run scripts will:
1. Set fish as default shell
2. Install TPM
3. `apt install` common packages + custom installs (starship, zoxide, eza, Docker Engine)

### Post-Setup

```bash
# Verify everything is healthy
~/.local/bin/doctor
```

---

## Edit and Apply Configs

```bash
# Edit a managed file in the source directory
chezmoi edit ~/.config/fish/config.fish

# Preview what would change
chezmoi diff

# Apply all changes
chezmoi apply

# Or edit + apply in one step
chezmoi edit --apply ~/.config/fish/config.fish
```

---

## Push Changes to Other Machines

On the machine where you made changes:

```bash
cd ~/.local/share/chezmoi
git add -A && git commit -m "description" && git push
```

On other machines:

```bash
chezmoi update
```

---

## Add/Remove Brew Packages

All packages are managed in `.chezmoidata/packages.yaml`.

### Add a formula

Add to the relevant category under `formulae`:

```yaml
formulae:
  - category: common
    packages:
      - bat
      - new-package    # add here
```

### Add a cask

Add to the relevant category under `casks`:

```yaml
casks:
  - category: dev_tools
    packages:
      - new-cask-app    # add here
```

### Remove a package

Delete the line from `packages.yaml`.

### Apply changes

```bash
chezmoi apply
# The run_onchange script detects packages.yaml changed and runs brew bundle
```

### Current categories

| Type    | Categories                                              |
|---------|---------------------------------------------------------|
| Formulae | common, dev, devops, ai, system                       |
| Casks    | dev_tools, productivity, security, system, media, fonts |

---

## Add/Remove NPM Packages

In `packages.yaml` under `npm`:

```yaml
npm:
  - ccusage
  - new-package    # add here
```

Requires Node.js (via fnm) to be available. Installed during `chezmoi apply`.

---

## Manual Installs

These are NOT managed by chezmoi/brew. Install them by hand.

### Standalone installs (macOS)
- **1Password** - standalone installer
- **Tailscale** - standalone installer (https://tailscale.com/docs/install/mac)
- **Mem** - standalone installer

### Mac App Store
- Amphetamine
- Bear
- DaisyDisk
- Dropover
- GoodLinks
- Reeder
- SSH Config Editor
- Velja
- Wipr

### Linux
- **Docker Engine** - installed automatically via run script (official apt repo)

### OrbStack (macOS)
Replaces Docker Desktop. Installed via brew cask. Provides Docker runtime on macOS.

---

## Re-Setup an Existing Machine

If configs have drifted or you want to reset:

```bash
# See what's different
chezmoi diff

# Re-apply everything (safe, won't delete unmanaged files)
chezmoi apply

# Full re-init (re-prompts for machine config)
chezmoi init --apply <your-github-username>

# Run doctor to verify
~/.local/bin/doctor
```

---

## Doctor Health Check

```bash
~/.local/bin/doctor
```

Checks:
- Required binaries present (bat, eza, fd, fish, fzf, nvim, rg, starship, tmux, tree, zoxide)
- macOS extras (brew, gh, helm, k9s, op, wget)
- Shell config (fish default, starship/zoxide/fzf init)
- Git signing (SSH format, signing enabled, 1Password agent on macOS, allowed_signers on Linux)
- SSH agent and config
- Chezmoi state (source dir exists, no pending diff)
- macOS: brew bundle check, Tailscale and OrbStack running
- Linux: Docker installed and running

Output: pass/fail/warn counts.

---

## Key Files Reference

| File | Purpose |
|------|---------|
| `.chezmoi.toml.tmpl` | Machine config prompts (role, work, name, email) |
| `.chezmoidata/packages.yaml` | All packages: brew, apt, npm, manual installs |
| `.chezmoiignore` | Excludes Brewfile, .ideavimrc, macOS SSH on Linux |
| `.chezmoiscripts/run_onchange_after_install-packages.sh.tmpl` | Package installer (triggers on packages.yaml change) |
| `.chezmoiscripts/run_once_after_set-default-shell.sh.tmpl` | Sets fish as default shell |
| `.chezmoiscripts/run_once_after_install-tpm.sh` | Installs tmux plugin manager |
| `dot_config/fish/config.fish.tmpl` | Fish shell config (aliases, PATH, tool init) |
| `dot_config/nvim/init.lua` | Neovim config (lazy.nvim, telescope, nvim-tree) |
| `dot_config/tmux/tmux.conf` | Tmux config (prefix C-a, vim keys, TPM plugins) |
| `dot_config/starship.toml` | Starship prompt symbols |
| `dot_local/bin/executable_bootstrap.tmpl` | Runs chezmoi apply + doctor |
| `dot_local/bin/executable_doctor.tmpl` | System health checker |
| `private_dot_ssh/config.tmpl` | SSH config with modular includes |
| `dot_gitconfig.tmpl` | Git config with SSH signing |
