# rpios-wayfirewm

- A keyboard-centric approach to navigate the desktop quickly and efficiently for Raspberry Pi 4 & 5. 

The default Operating System for Raspberry Pi (Bookworm edition) uses WayfireWM based on Wayland. Wayland is a modern replacement for X11, which has been the default windowing system on Linux for decades. However, the inherent power of the Window Manager will only become apparent once the plugins are activated in `~/.config/wayfire.ini` to navigate the grid of nine default workspaces using simplified keyboard shortcuts, including 
- [caps2esc](https://gitlab.com/interception/linux/plugins/caps2esc): _transforming the most useless key ever in the most useful one_ and 
- [space2meta](https://gitlab.com/interception/linux/plugins/space2meta): _turn your space key into the meta key when chorded to another key (on key release only)_

When the shortcuts are configured its a very smooth desktop experience and extremely light on resources, usually running on 2Gb ram. 
- These are my personal configs. Vim is your friend to change my zsh aliases into your own.
- This repo has an accompanying video [TBA](https://example.com) 

## Preparing The Ground 

- Reset SSD to factory settings if it's badly worn. Ignore if using an sdcard.
```
sudo nvme format -s1 -lb=0 /dev/nvme0n1
```
- Flash Raspberry Pi OS onto your SSD/sdcard with `rpi-imager`
 
- Change `BOOT_ORDER` line in order to boot from an SSD (I started with an sdcard). BOOT_ORDER options read from right to left, with 6 representing the nvme drive, 1 is sdcard and 4 is USB boot) 

```
sudo rpi-eeprom-config --edit
BOOT_ORDER=0xf416
```
- Reboot and follow the RPiOS setup wizard.

## Now the Good Stuff

- Install some packages we can use straight away
 
```
sudo apt-get update
sudo apt-get install aptitude ranger zsh ripgrep fd-find fzf vim-gtk3 alacritty kitty cmake ninja-build interception-caps2esc interception-tools interception-compat wf-recorder timeshift wl-clipboard obs-studio slurp 
```
- My process in video-recording was to reboot (with camera and mic plugged in) with the following command to run obs:
```
MESA_GL_VERSION_OVERRIDE=3.3 obs
```
## Clone _This_ Repo
```
git clone https://github.com/gnmearacaun/rpios-wayfirewm.git
```
## Place The Configs

Put `wayfire.ini` and any of the other configuration files and folders you want into `home` and `.config` respectively. Assuming you're familiar with Linux, the files and folders are named in such a way as to indicate where they should end up. If it's not obvious, open an [issue](https://github.com/gnmearacaun/rpios-wayfirewm/issues). 

- Now you can move around using Super+{a,s,f,w,b,h,j,k,l,<Tab>} and make tiles with <Alt>+{h,j,k,l}

- Note: When one edits wayfire.ini, one is automatically logged out.

- Customize lxterminal & taskbar, darken theme.

## Install Debian package-list 

Some personal selections

```
sudo apt-get install dselect --yes
sudo dpkg --set-selections < "packages.txt"
sudo apt-get dselect-upgrade -y
```
To show if any didn't get installed
```
cut -f1 -d' ' packages.txt | xargs dpkg -l
```
## A Minimal Vim Configuration 

- Because `vim` makes files shine 

- The package vim-gtk3 has better clipboard support than plain old Vim. Wayland users should install `wl-clipboard` (done previously). This vim config is based on https://github.com/nvim-zh/minimal_vim by the incomparable [jdhao](https://github.com/jdhao)

To avoid default conf interfering with this conf, do this:
```
mv ~/.vimrc ~/.vimrc.bak
```
and move the contents of the `home.vim` folder to `~/.vim/`

## Install Zsh and [Zap](https://www.zapzsh.com/) 

To set zsh as your default shell, execute the following.
```
sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)
```
- Or change shell with: `sudo chsh -s $(which zsh) $USER`

Install [zap](https://github.com/zap-zsh/zap) zsh plugin manager
```
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
```

Ensure .zshenv contains
```
export ZDOTDIR=$HOME/.config/zsh
```
Reopen the shell, `zap update` will automatically install the plugins before your eyes. 

## Get Nerdfonts
https://github.com/getnf/getnf
```
curl -fsSL https://raw.githubusercontent.com/ronniedroid/getnf/master/install.sh | bash
```
Run `getnf` in the terminal and follow the prompts.

## Build interception-tools 

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
You may notice a lag typing `s` or `space` with an sdcard, but not really with an SSD. For convenience, there's a version of the file without s2arrows

## Build Neovim 

To take advantage of recent developments in the plugins infrastructure you may want a newer version of Neovim than Bookworm repositories are offering in `stable`. 

- Note `CMAKE_BUILD_TYPE=RelWithDebInfo` would make a build with Debug info. `Release` runs a bit lighter.

- My neovim config is based on https://github.com/ChristianChiarulli/nvim. 

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
If you have previously built the image and want to switch branches, do this first
```
cd neovim && sudo cmake --build build/ --target uninstall
```

Alternatively, just delete the CMAKE_INSTALL_PREFIX artifacts:
```
sudo rm /usr/local/bin/nvim
sudo rm -r /usr/local/share/nvim/
```

Later when you want to upgrade, go back into the neovim directory (wherever it's stashed). Assuming you're on the branch you want, this will rebuild from scratch and replace the current build.

```
git pull
sudo make distclean && make CMAKE_BUILD_TYPE=Release
cd build && sudo cpack -G DEB && sudo dpkg -i nvim-linux64.deb
nvim -V1 -v
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
## Troubleshooting

Mason was not showing up in neovim and throwing some errors
I had to run 
```
:Lazy reload mason.nvim
```
