# rpios-wayfirewm
Raspberry Pi OS Bookworm WayfireWM.
A base configuration to quickly get 'up and running' with workspaces and navigational shortcuts.

## Steps To Setting Up Raspberry Pi For Ease Of Navigation

Raspberry Pi Os Bookworm edition uses WayfireWM, based on Wayland, a modern way of rendering windows (vs X11, the old way). The result is a pleasing desktop experience that is very lightweight on system resources. The ~/.config/wayfire.ini file is the place to unlock the potential, with plugins and commands to navigate 9 default workspaces using simplified keyboard shortcuts. This config includes 
    - [caps2esc](https://gitlab.com/interception/linux/plugins/caps2esc): _transforming the most useless key ever in the most useful one_ 
    - [space2meta](https://gitlab.com/interception/linux/plugins/space2meta): _turn your space key into the meta key when chorded to another key (on key release only)_

This repo is related to the accompanying video. 

## Preparing The Ground 

- Reset SSD to factory settings if it badly worn. Ignore if using an sdcard.
```
sudo nvme format -s1 -lb=0 /dev/nvme0n1
```
- Flash RPiOS with `rpi-imager`.

- Change `BOOT_ORDER` line in order to boot from an SSD (I started with an sdcard). BOOT_ORDER options read from right to left, with 6 representing the nvme drive, 1 is sdcard and 4 is USB boot) 

```
sudo rpi-eeprom-config --edit
BOOT_ORDER=0xf416
```
- Now reboot into RPiOS

## Install some initial packages

```
sudo apt-get update
sudo apt-get install aptitude zoxide lsd zsh ranger ripgrep fd-find fzf vim-gtk3 alacritty kitty cmake ninja-build interception-caps2esc interception-tools interception-compat wf-recorder timeshift wl-clipboard wl-copy obs-studio dselect slurp
```
- My process was to reboot with camera and mic plugged in to record session to record the video with the following command:
```
MESA_GL_VERSION_OVERRIDE=3.3 obs
```
## Clone the config files 
```
git clone https://github.com/gnmearacaun/rpios-wayfirewm.git
```
## Drop the configurations into place

Put wayfire.ini, config.txt and other configs into place. Assuming you're somewhat familiar with Linux already, I've named the files and folders to indicate where they belong. If it's not obvious you can hit me up in the Issues of this repo. 
    Note: When you make changes to wayfire.ini, RPiOS will log you out, to force you to log back in.

- Customize lxterminal & taskbar, darken theme to taste.

## Install Debian package-list 
Optional, this is my personal list of favorite packages

```
sudo apt-get install dselect --yes
sudo dpkg --set-selections < "packages.txt"
sudo apt-get dselect-upgrade -y
```
To show if any didn't get installed
```
cut -f1 -d' ' packages.txt | xargs dpkg -l
```
## Build interception-tools keybinds

[Interception-tools](https://gitlab.com/interception/linux/tools) `caps2esc` (caps_lock is esc when tapped or ctrl when held down), `space2meta` (space key acts as meta when held down in combination with other keys) and `s2arrows`  acts as the arrow keys combining s+j,k,h,l

We installed `interception-caps2esc interception-tools interception-compat` were already in the repo. We'll need to manually install space2meta and s2arrows if you want those. After building, you'll need to put udevmon.yaml into /etc/interception/udevmon.d/ and enable udevmon as a service. 

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
Now enable the service and enjoy your new keybindings

```bash
sudo systemctl enable --now udevmon.service
```
The following daemonized sample execution increases udevmon priority (since it'll be responsible for the vital service of enabling key chords as described).
```
sudo nice -n -20 udevmon -c udevmon.yaml >udevmon.log 2>udevmon.err &
```

## Install jdhao's minimal Vim config 

For Wayland users on Linux, make sure that wl-clipboard is installed. The package vim-gtk3 has clipboard support. Run in terminal gvim -v. The vim config is based on this https://github.com/nvim-zh/minimal_vim
To avoid default conf interfering with this conf do this
```
mv ~/.vimrc ~/.vimrc.bak
```
and move the .vim folder into the home directory

## Get Nerdfonts
https://github.com/getnf/getnf
```
curl -fsSL https://raw.githubusercontent.com/ronniedroid/getnf/master/install.sh | bash
```
Run `getnf`

## [Zap](https://www.zapzsh.com/) Zsh-plugin manager

To set zsh as your default shell, execute the following.
```
sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)
```
- Or change shell with: `sudo chsh -s $(which zsh) $USER`

Install [zap](https://github.com/zap-zsh/zap)
```
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
```

Ensure .zshenv contains
```
export ZDOTDIR=$HOME/.config/zsh
```
Reopen the shell, `zap update` will automatically run. Temporarily set editor to vim in `~/.config/zsh/exports.zsh` for ranger file manager, until neovim is built.
```
export EDITOR="vim"
```
## Building Neovim 

Neovim dependencies, building and verification
```
sudo apt-get install ninja-build gettext cmake unzip curl build-essential
git clone https://github.com/neovim/neovim.git
git checkout nightly
make CMAKE_BUILD_TYPE=Release
cd build && sudo cpack -G DEB && sudo dpkg -i nvim-linux64.deb
nvim -V1 -v
```

Later when you want to upgrade, go back into the neovim directory (wherever it's stashed). Assuming you're on the branch you want, this will rebuild from scratch and replace the current build.

```
git pull
sudo make distclean && make CMAKE_BUILD_TYPE=Release
cd build && sudo cpack -G DEB && sudo dpkg -i nvim-linux64.deb
nvim -V1 -v
```

Install nodejs (run as root)
```
curl -fsSL https://deb.nodesource.com/setup_21.x | bash - &&\
apt-get install -y nodejs
install a node version manager (optional) from https://www.chiarulli.me/Nodejs/02-Install-FNM/
curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir $HOME/.local/bin
```
## Troubleshooting

Mason was not showing up in neovim
I had to run 
```
:Lazy reload mason.nvim
```
