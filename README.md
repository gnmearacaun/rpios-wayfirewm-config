# Rpios-wayfirewm

- A keyboard-centric configuration for Raspberry Pi 4 & 5. 
 
Raspberry Pi OS is based on Debian (Bookworm release).  It looks no different, but don't be fooled, this release is underpinned by Wayland and WayfireWM . Wayland is the modern replacement for X11 (the default windowing system on Linux for decades). 

I originally set up HyprlandWM on the Pi5. To get it to build, I had to change the software repository from `stable` to `testing`, a manoeuver that is not officially supported. Eventually it would not boot up anymore. However, I get the same basic functionality with WayfireWM. The Raspberry Pi Foundation has done the heavy lifting to provide a deceptively simple desktop. The result is a smooth DE, extremely light on system resources typically requiring <2Gb ram. 

RPiOS comes with little configuration ootb. To unlock the inherent potential power of the plugins and commands, one must customize `~/.config/wayfire.ini`. Actually most of the plugins are already included with the official OS. Some need configuration, others just need to be included in the list of plugins. The following binaries make it that much easier to navigate the desktop:
- [space2meta](https://gitlab.com/interception/linux/plugins/space2meta): _turn your space key into the meta key when chorded to another key (on key release only)_
- [caps2esc](https://gitlab.com/interception/linux/plugins/caps2esc): _transforming the most useless key ever in the most useful one_ 

- This repo has an accompanying video [TBA](https://example.com) 

### _Prepare the ground_ 

- Reset SSD to factory settings if it's not new. Ignore if using an sdcard.
```
sudo nvme format -s1 -lb=0 /dev/nvme0n1
```
- Change `BOOT_ORDER` line in order to boot from an SSD. BOOT_ORDER options read from right to left, with 6 representing the nvme drive, 1 is sdcard and 4 is USB boot) 

```
sudo rpi-eeprom-config --edit
BOOT_ORDER=0xf416
```
- Flash Raspberry Pi OS onto your SSD/sdcard with `rpi-imager`

- Reboot and follow the setup wizard.

- Install some initial packages 
 
```
sudo apt-get update
sudo apt-get install aptitude ranger zsh ripgrep fd-find fzf vim-gtk3 wl-clipboard swaybg slurp alacritty zoxide lsd bat cmake ninja-build interception-caps2esc interception-tools interception-tools-compat wf-recorder timeshift obs-studio redshift wofi mako-notifier clipman kanshi 
```
### Grab _this_ repo
```
git clone https://github.com/gnmearacaun/rpios-wayfirewm-config.git
```
The configs contain some customized aliases and keybindings. To make use of them:

```
mv -i wayfire.ini zsh ~/.config 
sudo mv interception-tools/udevmon.yaml /etc/interception/udevmon.d/
```
Log out and back in.

- Now you can move around the windows and workspaces using Super+{a,s,f,w,b,h,j,k,l,<Tab>} and create tiles out of windows with <Alt>+{h,j,k,l}

### RPiOS checklist

- Customize lxterminal & taskbar, darken theme.

- Xdg default desktop folders can be changed in `~/.config/usr-dirs.dirs`

- Copy images (as sudo) into /usr/share/rdp-wallpapers if you want to set background via right-clicking the Desktop

- The following augmented command is needed to run obs-studio (video recording software):
```
MESA_GL_VERSION_OVERRIDE=3.3 obs
```

### A minimal Vim configuration 

- The package vim-gtk3 has better clipboard support than plain old Vim itself. Wayland users need `wl-clipboard` (installed above). 

I install the following config by [jdhao](https://github.com/jdhao) just for setting up the desktop, until neovim is built. We can make it available to `root` also.

```
mv ~/.vimrc ~/.vimrc.bak
mkdir -p ~/.vim && cd ~/.vim
git clone https://github.com/jdhao/minimal_vim.git .
cd && sudo cp -r .vim /root
```
- Add the following line to your `init.vim` to yank to `wl-clipboard`. `<leader>` is set to the `<spacebar>`

```
xnoremap <silent> <leader>y y:call system("wl-copy --trim-newline", @*)<cr>:call system("wl-copy -p --trim-newline", @*)<cr>
```

- Note: When you edit wayfire.ini, you are automatically logged out. If not, you can use `Ctrl-Alt-Backspace` to logout/login and test your edits. If for whatever reason your desktop freezes, log into another `tty` with `Ctrl+Alt+F2` and `reboot` 

### Install zsh and [zap](https://www.zapzsh.com/) 

To set zsh as your default shell, execute the following.
```
sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)
```
Log out and back in. You're prompt will be basic. Install [zap](https://github.com/zap-zsh/zap) zsh plugin manager (replaces the need for `oh-my-zsh`)
```
echo $SHELL
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
```
Create ~/.zshenv containing: 
```
export ZDOTDIR=$HOME/.config/zsh
```
Reopen the shell, `zap` automajically installs the plugins. 

### Get nerdfonts
https://github.com/getnf/getnf
```
curl -fsSL https://raw.githubusercontent.com/ronniedroid/getnf/master/install.sh | bash
```
Run `getnf` in the terminal and follow the prompts.

### Build interception-tools 

[Interception-tools](https://gitlab.com/interception/linux/tools) `caps2esc` (caps_lock is esc when tapped or ctrl when held down), `space2meta` (space key acts as meta when held down in combination with other keys)

We installed some `interception` tools with apt-get above. As for `space2meta` and `s2arrows` we will need to build it ourselves. 

```
git clone https://gitlab.com/interception/linux/plugins/space2meta.git
cd space2meta
cmake -Bbuild
cmake --build build
sudo cp build/space2meta /usr/local/bin  
```
[s2arrows](https://github.com/kbairak/s2arrows) emulates the arrow keys when s+{j,k,h,l} are combined.

```
git clone https://github.com/kbairak/s2arrows.git
cd s2arrows
mkdir build
cd build
cmake ..
make
sudo make install
```
Enable and start the service 

```bash
sudo systemctl enable --now udevmon.service
```

You may have to log out and back in to get the effect. The following command increases udevmon priority. 

```
sudo nice -n -20 udevmon -c udevmon.yaml >udevmon.log 2>udevmon.err &
```
You may notice a lag typing `s` or `space` with an sdcard. For convenience, there's a version of the udevmon.yaml without s2arrows if you prefer.

### Build Neovim 

Neovim is improving rapidly. To take advantage of recent developments in the plugins infrastructure we need a newer version of Neovim than Bookworm repositories are offering.  

- Note `CMAKE_BUILD_TYPE=RelWithDebInfo` would make a build with Debug info. `Release` runs a bit lighter.

- Use `git checkout nightly` if you need the very latest.

```
sudo apt-get install ninja-build gettext cmake unzip curl build-essential
git clone https://github.com/neovim/neovim.git
git checkout stable 
make CMAKE_BUILD_TYPE=Release
cd build && sudo cpack -G DEB && sudo dpkg -i nvim-linux64.deb
nvim -V1 -v
```

If you don't already have an `nvim` config set up to put into `~/.config`, feel free to use mine. My neovim config is based on https://github.com/ChristianChiarulli/nvim BDFL of LunarVim.

```
https://github.com/gnmearacaun/nvim-launch.git
```
- Note: if Mason errors are being thrown, do this from the nvim commandline:

```
:Lazy reload mason.nvim
```
### Install nodejs 

I'm using [nodesource](https://github.com/nodesource/distributions). Run as root:
```
sudo su
curl -fsSL https://deb.nodesource.com/setup_21.x | bash - &&\
apt-get install -y nodejs
```
## Extras
### Debian packages

- A curated list of optional programs
```
sudo apt-get install dselect --yes
sudo dpkg --set-selections < "packages.txt"
/usr/lib/dpkg/methods/apt/update /var/lib/dpkg/
sudo apt-get dselect-upgrade -y
```

### Rebuilding Neovim

In case you have previously built the image and want to switch branches:
```
cd neovim && sudo cmake --build build/ --target uninstall
```

Alternatively, just delete the CMAKE_INSTALL_PREFIX artifacts:
```
sudo rm /usr/local/bin/nvim
sudo rm -r /usr/local/share/nvim/
```

### Upgrading Neovim

Later when you want to upgrade, go back into the neovim directory (wherever it's stashed). Assuming you're on the branch you want, to rebuild from scratch and replace the current build:

```
git pull
sudo make distclean && make CMAKE_BUILD_TYPE=Release
cd build && sudo cpack -G DEB && sudo dpkg -i nvim-linux64.deb
nvim -V1 -v
```
