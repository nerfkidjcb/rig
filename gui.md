# Set up display output

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
sudo make install
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

## Dynamic menu

I use rofi as a dynamic menu.
