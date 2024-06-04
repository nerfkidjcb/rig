# System setup

Install system:

```bash
sudo pacman -S ...
```

- `alacritty`

- `feh`

- `firefox`

- `git`

- `github-cli`

- `lf`

- `nodejs`

- `npm`

- `sysstat`

- `ttf-jetbrains-mono-nerd`

- `ttf-nerd-fonts-symbols-mono`

- `wget`

- `zsh`

## Shell - ZHS

List installed shells:

```bash
chsh -l
```

Set ZHS as the default shell:

```bash
chsh -s </path/to/zhs>
```

### Config

- `~/.zshrc`

- `~/.zprofile`

## Window manager - DWM

Clone the DWM repository:

```bash
git clone https://git.suckless.org/dwm
```

Edit the `config.mk` file:

```bash
cd dwm
nvim config.def.h
```

Set the terminal to `alacritty` by replacing `st` with `alacritty` in the following line:

```c
static const char *termcmd[]  = { "st", NULL };
```

Change the mod key to the Super key by replacing `Mod1Mask` with `Mod4Mask` in the following line:

```c
#define MODKEY Mod1Mask
```

Write and quit the file.

Install DWM:

```bash
sudo make clean install
```

Open the `~/.xinitrc` file:

```bash
nvim ~/.xinitrc
```

Add the following line to the file:

```bash
exec dwm
```

Write and quit the file.

Start DWM:

```bash
startx
```

Add the following to the end of `~/.zprofile`:

```bash
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  exec startx
fi
```

### Patches

Create the `dwm/patches` directory.

Visit the [Suckless patches repository](https://dwm.suckless.org/patches/), select the patch diffs and use `wget` to clone them into the new `dwm/patches` directory.

Patches I use:

- `fullgaps`

- `barpadding`

- `statuspadding`

- `actualfullscreen`

- `underlinetags`

To test a patch can be integrated before commiting to it, run:

```bash
patch --dry-run <patches/<patch_name>.diff
```

If everything succeeds, integrate the patch:

```bash
patch <patches/<patch_name>.diff
```

After being integrated, most patches will have added some new variables and configurations to `config.def.h`, so the same process as above can be used to edit and build these changes.

### dwmblocks

Change into your `.config` directory and clone the dwmblocks repo:

```bash
git clone https://github.com/torrinfail/dwmblocks.git
```

Inside the `.config/dwmblocks` directory that this creates is a `blocks.def.h` config file that is edited and built in exactly the same was as `dwm/config.def.h`. This file can be used to customise each of the elements in the status bar. Each element has

- a tag,

- a command that it runs on the system and displays the output of,

- a query interval (how often the command is run),

- and a process ID that can be referred to by other processes to update the status bar.

#### Config

- `.config/dwmblocks/blocks.def.h`

## Terminal - Alacritty

### Config

- `.config/alacritty.toml`

## File explorer - lf

### Config

- `.config/lf/lfrc`

## Browser - Firefox
