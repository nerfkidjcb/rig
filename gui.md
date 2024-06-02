# Set up display output

## Fonts

```bash
sudo pacman -S ttf-nerd-fonts-symbols-mono
```

## Window manager

I use DWM. It is a lightweight and therefore fast and efficient window manager.

Clone the DWM repository (into the home directory - it can be removed later):

```bash
git clone https://git.suckless.org/dwm
```

Edit the `config.mk` file:

```bash
nvim dwm/config.def.h
```

Set the terminal to `kitty` by replacing `st` with `kitty` in the following line:

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

Add the following to the end of `~/.bash_profile`:

```bash
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  exec startx
fi
```

### Patches

Create the `dwm/patches` directory.

Visit the [Suckless patches repository](https://dwm.suckless.org/patches/), select the patch diffs and use `wget` to clone them into the new `dwm/patches` directory.

Patches I use:

- fullgaps

- barpadding


### dwmblocks

I use dwmblocks to customise my DWM statusbar.




## Dynamic menu

I use rofi as a dynamic menu.
