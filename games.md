# Games

## Enable multilib

Uncomment the `multilib` section in `/etc/pacman.conf`:

```bash
[multilib]
Include = /etc/pacman.d/mirrorlist
```

Upgrade the system:

```bash
pacman -Syu
```

## Install Steam

```bash
sudo pacman -S steam
```

Generate the `en_US.UTF-8` locale.

Install `ttf-liberation`.

[Optional] Give permissions to external mount points if games are stored on them:

```bash
sudo chown -R <user> /home/<user>/games
```
