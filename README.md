# My Arch Linux Setup

The [Arch Linux wiki](https://wiki.archlinux.org/) contains a comprehensive, up-to-date guide on how to install Arch Linux. And the [Arch Linux Installation Guide](https://wiki.archlinux.org/index.php/Installation_guide) is a good starting point. The [Arch Linux website](https://www.archlinux.org/) provides the latest news on the distro which is important to keep up with.

## Pre-installation

### Install Ventoy

[Ventoy](https://www.ventoy.net/en/index.html) is a tool to create bootable USB drives. It is a great tool to have as it allows you to boot multiple ISOs from a single USB drive and not have to format the drive each time you want to try a different distro.

### Download the ISO

[Download the Arch Linux ISO from the bottom of the page](https://www.archlinux.org/download/) and place it inside the root of the Ventoy USB drive.

### Boot into the USB

Insert the Ventoy USB drive into the computer and boot into it by selecting it from the boot menu. You may need to change the boot order in the BIOS settings, or your BIOS may have a boot menu key that you can press at startup to select the USB drive.

Once Ventoy boots, you will see a list of ISOs that you can boot from. Select the Arch Linux ISO and press enter.

> **Note**: Disable Secure Boot in your BIOS settings if you have trouble booting into the USB drive.

When the Arch Linux ISO boots, you will be presented with a GRUB2 menu. Select the first option to boot into the live environment (if you are using UEFI mode). Arch Linux will boot into the live environment and you can start the installation process when it finishes copying the image to RAM.

> **Note**: If Arch Linux does not boot into the live environment because it cannot find a device or path, then you may need to enter GRUB2 mode in Ventoy by pressing `ctrl + r` before booting into the Arch Linux ISO.

Ensure the system is working by setting your font:

```bash
setfont ter-132b
```

Set the system timezone:

```bash
timedatectl set-timezone <Region>/<City>
```

## Initial network configuration

If you are using a wired connection, then you can skip this step. If you are using Wi-Fi, then you will need to connect to your network before proceeding with the installation.

Using `iwctl` (iNet Wireless Control), you can scan for networks and connect to them. First, list the available devices:

```bash
iwctl device list
```

Scan for available networks:

```bash
iwctl station <device> scan
```

List the available networks:

```bash
iwctl station <device> get-networks
```

Connect to your network:

```bash
iwctl --passphrase <password> station <device> connect <network>
```

Test the connection:

```bash
ping archlinux.org
```

If the connection is successful, you should see output from the `ping` appearing every second. Press `Ctrl + C` to stop the `ping`.

## Disk partitioning

List the available disks:

```bash
lsblk
```

Identify the disk you want to install Arch Linux on. If you are unsure, use the size of the disk to determine which is the primary disk.

Enter disk partitioning mode for the disk:

```bash
fdisk /dev/<device>
```

> **Note**: Make sure _not_ to select a partition (e.g., `/dev/sda1`) but the disk itself (e.g., `/dev/sda`).

Create an empty partition table:

```bash
g
```

> **Note**: At any point you can type `p` to print the current partition table.

### Create the boot partition

Create a new partition:

```bash
n
```

Leave the partition number as the default: press `Enter`.

Leave the first sector (beginning of the partition) as the default: press `Enter`.

Make this new partition 1 gigabyte in size:

```bash
+1G
```

If prompted to remove the signature, type `y` and press `Enter`.

### Create the EFI partition

Create a new partition:

```bash
n
```

Leave the partition number as the default: press `Enter`.

Leave the first sector (beginning of the partition) as the default: press `Enter`.

Make this new partition 1 gigabyte in size:

```bash
+1G
```

### Create the home LVM partition

Create a new partition:

```bash
n
```

Leave the partition number as the default: press `Enter`.

Leave the first sector (beginning of the partition) as the default: press `Enter`.

Make this new partition 500 gigabytes in size:

```bash
+500G
```

Enter type selection mode:

```bash
t
```

Select the partition you just created: press `Enter`.

Select the Linux large volume manager (LVM) type:

```bash
44
```

### Create the games LVM partition

Create a new partition:

```bash
n
```

Leave the partition number as the default: press `Enter`.

Leave the first sector (beginning of the partition) as the default: press `Enter`.

Press `Enter` to use the remaining space on the disk.

Enter type selection mode:

```bash
t
```

Select the partition you just created: press `Enter`.

Select the Linux large volume manager (LVM) type:

```bash
44
```

### Write the changes to disk

> **Note**: Running the following command will erase all data on the disk. Make sure you have backed up any important data before proceeding.

Write the changes to disk:

```bash
w
```

## Disk formatting

Format the boot (first) partition as FAT32:

```bash
mkfs.fat -F32 /dev/<device>p1
```

Format the EFI (second) partition as FAT32:

```bash
mkfs.ext4 /dev/<device>p2
```

Encrypt the home LVM (third) partition, as it will contain the root and swap volumes (i.e., the actual stuff we store and use on our computer):

```bash
cryptsetup luksFormat /dev/<device>p3
```

Type `YES` to confirm the encryption.

Enter and verify the passphrase for the encryption (i.e., the password you will use every time you log in to your computer).

Open the encrypted partition:

```bash
cryptsetup open --type luks /dev/<device>p3 lvm
```

> **Note**: The `lvm` name is arbitrary and can be anything you want - it is how we will refer to the partition in the next steps.

Create the physical volume:

```bash
pvcreate /dev/mapper/lvm
```

Create the system volume group:

```bash
vgcreate vg_system /dev/mapper/lvm
```

Create the logical volume for the root partition:

```bash
lvcreate -L 30GB vg_system -n lv_root
```

[Optional] Create the logical volume for the swap partition:

```bash
lvcreate -L <RAM-size>GB vg_system -n lv_swap
```

[Optional] Configure the swap partition:

```bash
mkswap /dev/vg_system/lv_swap
```

[Optional] Enable the swap partition:

```bash
swapon /dev/vg_system/lv_swap
```

Create the logical volume for the productivity user partition:

```bash
lvcreate -L 235GB vg_system -n lv_productivity
```

Create the logical volume for the entertainment user partition:

```bash
lvcreate -l 100%FREE vg_system -n lv_entertainment
```

> **Note**: We can run `vgdisplay` to see the volume group information, and `lvdisplay` to see the logical volume information.

Create the games volume group:

```bash
vgcreate vg_games /dev/sda4
```

Create the logical volume for the games partition:

```bash
lvcreate -l 100%FREE vg_games -n lv_games
```

Load the necessary kernel modules:

```bash
modprobe dm_mod
```

Scan for the LVM volumes:

```bash
vgscan
```

Activate the volume group:

```bash
vgchange -ay
```

Format the root partition as ext4:

```bash
mkfs.ext4 /dev/vg_system/lv_root
```

Format the productivity user partition as ext4:

```bash
mkfs.ext4 /dev/vg_system/lv_productivity
```

Format the entertainment user partition as ext4:

```bash
mkfs.ext4 /dev/vg_system/lv_productivity
```

Format the games partition as ext4:

```bash
mkfs.ext4 /dev/vg_games/lv_games
```

### Partition mounting

Mount the root partition:

```bash
mount /dev/vg_system/lv_root /mnt
```

Create the boot directory:

```bash
mkdir /mnt/boot
```

Mount the EFI (second) partition:

```bash
mount /dev/<device>p2 /mnt/boot
```

> **Note**: We are not mounting the boot (first) partition...

Create the productivity user directory:

```bash
mkdir /mnt/p
```

Mount the productivity user volume:

```bash
mount /dev/vg_system/lv_productivity /mnt/p
```

Create the entertainment user directory:

```bash
mkdir /mnt/e
```

Mount the entertainment user volume:

```bash
mount /dev/vg_system/lv_entertainment /mnt/e
```

Create the games directory:

```bash
mkdir /mnt/g
```

Mount the games partition:

```bash
mount /dev/vg_games/lv_games /mnt/g
```

### Install essential packages

```bash
pacstrap -i /mnt base
```

> **Note**: If any packages ask which version to install, select the default version: press `Enter`.

### Generate the `fstab` file

Generate the `fstab` file:

```bash
genfstab -U -p /mnt >> /mnt/etc/fstab
```

> This will append the UUIDs of the partitions to the `fstab` file: root, boot, home, and swap.

### Chroot into the new system

```bash
arch-chroot /mnt
```

Set root password:

```bash
passwd
```

Enter and confirm the root password.

Create user:

```bash
useradd -m -G wheel <username>
```

Set user password:

```bash
passwd <username>
```

Enter and confirm the user password.

Grant the user sudo privileges:

```bash
sudo EDITOR=nvim visudo
```

Uncomment the line:

```bash
%wheel ALL=(ALL) ALL
```

Install packages:

```bash
pacman -S base-devel grub efibootmgr networkmanager lvm2 neovim sudo xorg xorg-xinit alsa-tools alsa-utils pipewire pipewire-alsa pipewire-audio pipewire-pulse wireplumber
```

> **Note**: If any packages ask which version to install, select the default version: press `Enter`.

Install kernel:

```bash
pacman -S linux linux-headers
```

> **Note**: If any packages ask which version to install, select the default version: press `Enter`.

Install firmware:

```bash
pacman -S linux-firmware
```

Setup GPU drivers:

- For Intel:

  ```bash
  pacman -S mesa intel-media-driver
  ```

- For NVIDIA:

  ```bash
  pacman -S nvidia nvidia-utils
  ```

### System configuration

Make sure the kernel knows how to deal with encrypted partitions:

```bash
nvim /etc/mkinitcpio.conf
```

Add `encrypt` to the `HOOKS` array:

```bash
HOOKS=(... block encrypt lvm2 filesystems ...)
```

Generate the ramdisk:

```bash
mkinitcpio -p linux
```

Set locale:

```bash
nvim /etc/locale.gen
```

Uncomment the locale you want to use:

```bash
en_GB.UTF-8 UTF-8
```

Generate the locale:

```bash
locale-gen
```

Add the encrypt device to the GRUB configuration:

```bash
nvim /etc/default/grub
```

Add `cryptdevice=/dev/<device>p3:vg_system` to the `GRUB_CMDLINE_LINUX_DEFAULT` line:

```bash
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=/dev/<device>p3:vg_system"
```

Setup EFI partition:

```bash
mkdir /boot/EFI
```

Mount the EFI partition:

```bash
mount /dev/<device>p1 /boot/EFI
```

Install bootloader:

```bash
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
```

Generate the GRUB configuration:

```bash
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
```

Generate config file:

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

Enable network manager:

```bash
systemctl enable NetworkManager
```

### Reboot

Exit the chroot environment:

```bash
exit
```

Unmount the partitions:

```bash
umount -a
```

> **Note**: You can unplug the USB drive before the system reboots.

When the system restarts, you will be prompted to enter the encryption passphrase. Enter the passphrase to boot into the system. Then log in with the user you created.

### Post-installation

Connect to the network:

```bash
nmcli device wifi connect <SSID> password <password>
```

Name the device:

```bash
hostnamectl hostname <host>
```

## System setup

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

- `lm_sensors`

- `nodejs`

- `npm`

- `sysstat`

- `ttf-jetbrains-mono-nerd`

- `ttf-nerd-fonts-symbols-mono`

- `wget`

- `zsh`

### Shell - ZHS

List installed shells:

```bash
chsh -l
```

Set ZHS as the default shell:

```bash
chsh -s </path/to/zhs>
```

#### Config

- `~/.zshrc`

- `~/.zprofile`

### Window manager - DWM

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

#### Patches

Create the `dwm/patches` directory.

Visit the [Suckless patches repository](https://dwm.suckless.org/patches/), select the patch diffs and use `wget` to clone them into the new `dwm/patches` directory.

Patches I use:

- `fullgaps`

- `barpadding`

- `statuspadding`

- `actualfullscreen`

- `underlinetags`

- `statusallmons`

To test a patch can be integrated before commiting to it, run:

```bash
patch --dry-run <patches/<patch_name>.diff
```

If everything succeeds, integrate the patch:

```bash
patch <patches/<patch_name>.diff
```

After being integrated, most patches will have added some new variables and configurations to `config.def.h`, so the same process as above can be used to edit and build these changes.

#### dwmblocks

Change into your `.config` directory and clone the dwmblocks repo:

```bash
git clone https://github.com/torrinfail/dwmblocks.git
```

Inside the `.config/dwmblocks` directory that this creates is a `blocks.def.h` config file that is edited and built in exactly the same was as `dwm/config.def.h`. This file can be used to customise each of the elements in the status bar. Each element has

- a tag,

- a command that it runs on the system and displays the output of,

- a query interval (how often the command is run),

- and a process ID that can be referred to by other processes to update the status bar.

##### Config

- `.config/dwmblocks/blocks.def.h`

### Terminal - Alacritty

#### Config

- `.config/alacritty.toml`

### Browser - Firefox

## Development environment

### Neovim

Install `nvim` plugin dependencies:

```bash
sudo pacman -S ...
```

- `ripgrep`

- `fd`

- `unzip`

## Games

### Enable multilib

Uncomment the `multilib` section in `/etc/pacman.conf`:

```bash
[multilib]
Include = /etc/pacman.d/mirrorlist
```

Upgrade the system:

```bash
pacman -Syu
```

### Install Steam

```bash
sudo pacman -S steam
```

Generate the `en_US.UTF-8` locale.

Install `ttf-liberation`.

[Optional] Give permissions to external mount points if games are stored on them:

```bash
sudo chown -R <user> /home/<user>/games
```

## Global user config

Dependencies:

- `stow`

- `zoxide`

- `fzf`

Clone this repository.

Run the `stow` command to symlink the configuration files:

```bash
stow --adpot -t ~ -d rig/stow .
```

> Note: The `--adopt` flag overrides the dotfiles stored in this repo with the ones already configured on the system. This can be used to override all files dotfiles on the system easily without having to delete them first, and then after the symlinks are created, `git restore .` can be applied to the repo to revert all configs to how they are on this repo.

## P-User config

### NeoVim

#### Language servers, linters, and formatters

LSP, Mason, and None-LS (a fork of Null-LS) are used to provide language server support for NeoVim.

Mason is designed to install all of three of these types of components (LSP, linters, and formatters), however None-LS must be used to provide wrappers for the linters and formatters that Mason does not support. However, some linters and formatters (like ESLint) are directly supported by Mason and do not need to be wrapped by None-LS.

## E-User config

Install XFCE:

```bash
sudo pacman -S xfce4
```

Download Fluent XFCE theme:

```bash
git clone https://github.com/vinceliuice/Fluent-gtk-theme.git
```

Install Fluent XFCE theme:

```bash
Fluent-gtk-theme/install.sh -n Fluent -c dark -s standard -i arch --tweaks solid round noborder
```

> Note: XFCE themes are stored in `~/.local/share/themes`.

Set the active theme to Fluent inside the 'Appearence' and 'Window Manager' programs.

Also inside 'Window Manager', ensure workspaces are not wrapped when windows are dragged to the edge of the screen.

Inside the 'Desktop' application, set the wallpaper to be the one stored in `~/.config/wallpaper.png`.

Inside the 'Session and Startup' application, under 'Current Session' set the Restart Style of `xfce4-panel` to `Never` (do this for any programs that are running by default and that you don't want - e.g., Firefox will run on start if it was open when the system was powered off).

Go to 'Keyboard Settings' -> 'Application Shortcuts' and set the following commands:

- `xfce4-appfinder` : `Super-F`

- `poweroff` : `Shift-Super-Q`

- `reboot` : `Shift-Super-R`

- `/mnt/e/Scripts/logout.sh` : `Super-Q`

  In order to get this command to work, create the `/mnt/e/Scripts/logout.sh` file with the following content:

  ```bash
  #!/bin/bash
  pkill -KILL -u $USER
  ```

  It must then be made executable:

  ```bash
  chmod +x Scripts/logout.sh
  ```
