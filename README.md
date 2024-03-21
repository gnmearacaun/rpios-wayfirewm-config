# Rpios-wayfirewm

- A keyboard-centric approach to navigate the desktop efficiently on Raspberry Pi 4 & 5. 

Raspberry Pi OS is based on Debian (Bookworm release).  It doesn't look much different, but don't get fooled. It uses WayfireWM build on Wayland with wlroots under the hood. Wayland is a modern replacement for X11, which has been the default windowing system on Linux for decades. 

Originally I used HyprlandWM on the Pi5. To build it, I had to change the software repository from `stable` to `testing` and this move is not supported. Eventually it would not boot up. However, I get the same basic functions with WayfireWM. The Raspberry Pi Foundation did the heavy lifting to provide this deceptively simple desktop (and `stable` is supported well into the foreseeable future). The result is a smooth DE, extremely light on system resources (typically only requiring 2Gb ram). 

You can unlock the power of the plugins and commands with a customized `~/.config/wayfire.ini`. Actually most of the plugins are already included with the official OS, they just need to be configured. The following binaries make the shortcuts sweeter still:
- [space2meta](https://gitlab.com/interception/linux/plugins/space2meta): _turn your space key into the meta key when chorded to another key (on key release only)_
- [caps2esc](https://gitlab.com/interception/linux/plugins/caps2esc): _transforming the most useless key ever in the most useful one_ 

- This repo has an accompanying video [TBA](https://example.com) 

## Preparing the ground 

- Reset SSD to factory settings if it's badly worn. Ignore if using an sdcard.
```
sudo nvme format -s1 -lb=0 /dev/nvme0n1
```
- Change `BOOT_ORDER` line in order to boot from an SSD (I started with an sdcard). BOOT_ORDER options read from right to left, with 6 representing the nvme drive, 1 is sdcard and 4 is USB boot) 

```
sudo rpi-eeprom-config --edit
BOOT_ORDER=0xf416
```
- Flash Raspberry Pi OS onto your SSD/sdcard with `rpi-imagers`s

- Reboot and follow the RPiOS setup wizard.

## Now the good bits
- Install some packages we can use straight away
 
```
sudo apt-get update
sudo apt-get install aptitude ranger zsh ripgrep fd-find fzf vim-gtk3 wl-clipboard swaybg slurp alacritty cmake ninja-build interception-caps2esc interception-tools interception-compat wf-recorder timeshift obs-studio redshift wofi mako-notifier clipman kanshi 
```
- My process to record the video was to reboot (with camera and mic plugged in). The following augmented command is needed to run obs-studio (recording software):
```
MESA_GL_VERSION_OVERRIDE=3.3 obs
```
### Clone _this_ repo
```
git clone https://github.com/gnmearacaun/rpios-wayfirewm.git
```
### Put the configs into place

Put `wayfire.ini` and `zsh` into `~/.config` and move `interception` into `/etc`. 

```
mv -i wayfire.ini zsh ~/.config 
sudo mv interception /etc
```
- Now you can move around using Super+{a,s,f,w,b,h,j,k,l,<Tab>} and create tiles out of windows with <Alt>+{h,j,k,l}

- Note: When you edit wayfire.ini, you normally are automatically logged out. If not you can use `Ctrl-Alt-Backspace` to logout/login and test your edits.

- Customize lxterminal & taskbar, darken theme.

- My `zsh` and `nvim` (linked below) contain custom aliases and keybindings.

### A minimal Vim configuration 

- The package vim-gtk3 has better clipboard support than plain old Vim itself. Wayland users need `wl-clipboard` (installed above). 

I install the following config by [jdhao](https://github.com/jdhao) just for setting up the desktop, until neovim is built.

```
mv ~/.vimrc ~/.vimrc.bak
mkdir -p ~/.vim && cd ~/.vim
git clone https://github.com/jdhao/minimal_vim.git .
mv ~/.vimrc ~/.vimrc.bak
```
### Install Debian package-list 

- Some selections (can be downloading while we work).

```
sudo apt-get install dselect --yes
sudo dpkg --set-selections < "packages.txt"
sudo apt-get dselect-upgrade -y
```
To show if any didn't get installed
```
cut -f1 -d' ' packages.txt | xargs dpkg -l
```
### Install zsh and [zap](https://www.zapzsh.com/) 

To set zsh as your default shell, execute the following.
```
sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)
```
Install [zap](https://github.com/zap-zsh/zap) zsh plugin manager
```
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
```
Ensure .zshenv contains. Edit: this step may not be necessary. 
```
export ZDOTDIR=$HOME/.config/zsh
```
Reopen the shell, `zap update` automatically installs the plugins. 

### Get nerdfonts
https://github.com/getnf/getnf
```
curl -fsSL https://raw.githubusercontent.com/ronniedroid/getnf/master/install.sh | bash
```
Run `getnf` in the terminal and follow the prompts.

### Build interception-tools 

[Interception-tools](https://gitlab.com/interception/linux/tools) `caps2esc` (caps_lock is esc when tapped or ctrl when held down), `space2meta` (space key acts as meta when held down in combination with other keys) and `s2arrows`  acts as the arrow keys combining s+j,k,h,l

We installed `interception-caps2esc interception-tools interception-compat` with apt-get. We'll need to manually install `space2meta` and `s2arrows` if you want those. After building, you'll need to put `udevmon.yaml` into `/etc/interception/udevmon.d/` and enable `udevmon` as a service (see below). 

```
git clone https://gitlab.com/interception/linux/plugins/space2meta.git
cd space2meta
cmake -Bbuild
cmake --build build
sudo cp build/space2meta /usr/local/bin  
```
Make sure that usr/local/bin is in your $PATH.

https://github.com/kbairak/s2arrows 

```
git clone git@github.com:kbairak/s2arrows
cd s2arrows
mkdir build
cd build
cmake ..
make
sudo make install
```
Enable the service and you're good to go

```bash
sudo systemctl enable --now udevmon.service
```
The following daemonized sample execution increases udevmon priority (since it'll be responsible for the vital service of enabling key chords as described).
```
sudo nice -n -20 udevmon -c udevmon.yaml >udevmon.log 2>udevmon.err &
```
You may notice a lag typing `s` or `space` with an sdcard. For convenience, there's a version of the udevmon.yaml without s2arrows if you prefer it.

### Build Neovim 

Neovim is improving rapidly. To take advantage of recent developments in the plugins infrastructure we need a newer version of Neovim than Bookworm repositories are offering.  

- Note `CMAKE_BUILD_TYPE=RelWithDebInfo` would make a build with Debug info. `Release` runs a bit lighter.


- `git checkout nightly` for bleeding edge

Neovim dependencies, building and verification. 
```
sudo apt-get install ninja-build gettext cmake unzip curl build-essential
git clone https://github.com/neovim/neovim.git
git checkout stable 
make CMAKE_BUILD_TYPE=Release
cd build && sudo cpack -G DEB && sudo dpkg -i nvim-linux64.deb
nvim -V1 -v
```

If you don't already have an `nvim` directory to drop into `~/.config`, feel free to use mine. My neovim config is based on https://github.com/ChristianChiarulli/nvim BDFL of Lunarvim.

```
https://github.com/gnmearacaun/nvim-launch.git
```
- Troubleshooting: Mason was not showing up at first (throwing errors).
From the nvim commandline:
```
:Lazy reload mason.nvim
```
## Install nodejs 

I'm using [nodesource](https://github.com/nodesource/distributions). Run as root:
```
sudo su
curl -fsSL https://deb.nodesource.com/setup_21.x | bash - &&\
apt-get install -y nodejs
install a node version manager (optional) from https://www.chiarulli.me/Nodejs/02-Install-FNM/
curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir $HOME/.local/bin
```
## Rebuilding Neovim

In case you have previously built the image and want to switch branches or use on another installation, do this:
```
cd neovim && sudo cmake --build build/ --target uninstall
```

Alternatively, just delete the CMAKE_INSTALL_PREFIX artifacts:
```
sudo rm /usr/local/bin/nvim
sudo rm -r /usr/local/share/nvim/
```

## Upgrading Neovim

Later when you want to upgrade, go back into the neovim directory (wherever it's stashed). Assuming you're on the branch you want, to rebuild from scratch and replace the current build:

```
git pull
sudo make distclean && make CMAKE_BUILD_TYPE=Release
cd build && sudo cpack -G DEB && sudo dpkg -i nvim-linux64.deb
nvim -V1 -v
```
