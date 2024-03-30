## Rpios-wayfirewm

- A keyboard-centric configuration for Raspberry Pi 4 & 5. 
 
The current Raspberry Pi OS is based on Debian Bookworm. On the surface, it looks similar to the previous Bullseye release, however RPiOS is now underpinned by Wayland and WayfireWM. Wayland is the modern replacement for X11 (the default windowing system on Linux for decades). 

I originally set up Hyprland (window manager) on the pi5. To compile it, I had to change the software sources from `stable` to `testing`, an action that is not officially supported. I found out why; eventually my pi would not boot up anymore. However by adding some plugins and options, I can get the same _ease of use_ with WayfireWM. The Raspberry Pi Foundation has modernized the networking and architecture, and now uses pipewire for handling media sources (music and video) for example. The result is a smooth DE, extremely light on system resources, typically requiring <2Gb ram. 

This repo provides a customized [~/.config/wayfire.ini](https://github.com/gnmearacaun/rpios-wayfirewm-config/blob/main/wayfire.ini) that has [incorporated and expanded](https://github.com/gnmearacaun/rpios-wayfirewm-config/blob/main/howto-pi5wfwm.md) the RPiOS config. 

The following binaries make it easier to adhere to a keyboard-only workflow
- [space2meta](https://gitlab.com/interception/linux/plugins/space2meta): _turn your space key into the meta key when chorded to another key (on key release only)_
- [caps2esc](https://gitlab.com/interception/linux/plugins/caps2esc): _transforming the most useless key ever into the most useful one_ 

<!-- - This repo has an accompanying video [TBA](https://example.com)  -->

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
sudo apt-get install aptitude vim-gtk3 wl-clipboard zsh ranger ripgrep fd-find fzf swaybg slurp alacritty zoxide lsd bat cmake ninja-build interception-caps2esc interception-tools interception-tools-compat wf-recorder timeshift obs-studio redshift wofi mako-notifier clipman kanshi 
```
### Obtain _this_ repo
```
git clone https://github.com/gnmearacaun/rpios-wayfirewm-config.git
```
These configs contain customized aliases and keybindings. Run commands one line at a time.  

```
cd rpios-wayfirewm-config
mv ~/.config/wayfire.ini wayfire.ini-original
mv -i wayfire.ini ~/.config 
mv -r zsh ~/.config 
```
Log out and back in.

- Now you can move around the windows and 9 workspaces using `super`+`{a,s,f,w,b,h,j,k,l,Tab}` and create tiles out of windows and back to tiles with `Alt`+`{h,j,k,l}`

### RPiOS checklist

- Customize lxterminal. Right click the taskbar and desktop to set up the system font and theme.

- Xdg default desktop folders can be changed in `~/.config/usr-dirs.dirs`

- Copy some nicer wallpapers (`sudo mv`) into `/usr/share/rpd-wallpaper` to set background via _Desktop Configuration Menu_. 

- Note: When you edit wayfire.ini, you are automatically logged out when you change workspaces. You can use `Ctrl-Alt-Backspace` to logout/login manually. 

- If your desktop freezes, log into another `tty` with `Ctrl+Alt+F3` and `reboot` 

#### A minimal Vim configuration 

- The package `vim-gtk3` has better clipboard support than `vim` proper. Wayland users need `wl-clipboard` to copy and paste (both were installed with the previous `apt-get` command). 

I use a simple config (no plugins) authored by [jdhao](https://github.com/jdhao) before neovim is built. It can also be useful to make it available for editing files as `sudo`.

```
mv ~/.vimrc ~/.vimrc.bak
mkdir -p ~/.vim && cd ~/.vim
git clone https://github.com/jdhao/minimal_vim.git .
cd && sudo cp -r .vim /root
```
- Tip: add the following line to your `init.vim` to yank to `wl-clipboard`. So you would visually highlight the text with `v` or `shift+v` and the motion keys `h,j,k,l` and press `<leader>` (it's mapped to the `<spacebar>`) and then `y` to copy. Most terminals have `Ctrl+Shift+v` as the paste command. 
```
xnoremap <silent> <leader>y y:call system("wl-copy --trim-newline", @*)<cr>:call system("wl-copy -p --trim-newline", @*)<cr>
```

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

The fonts you select will be available system-wide.

### Build interception-tools 

_Caps2esc_

- `<Caps_lock>` is `esc` when tapped and `ctrl` when held down with another key. We installed it with `apt-get` above. 

_Space2meta_

- `<Space_key>` is `space` when tapped and `super` when held down in combination with other keys. To build:

```
git clone https://gitlab.com/interception/linux/plugins/space2meta.git
cd space2meta
cmake -Bbuild
cmake --build build
sudo mv build/space2meta /usr/local/bin  
cd .. && rm -r space2meta
```

Copy over the config from this repo, enable and start the service (you may have to logout/login to get the effect). 

```
sudo mv interception-tools/udevmon.yaml /etc/interception/udevmon.d/
sudo systemctl enable --now udevmon.service
```

The following command increases the priority. 

```
sudo nice -n -20 udevmon -c udevmon.yaml >udevmon.log 2>udevmon.err &
```

### Build Neovim 

Neovim is improving rapidly. To take advantage of recent developments in the plugins infrastructure we need a newer version of Neovim than Bookworm offers. Neovim plays nicely with the system clipboard for copy and pasting, commenting lines easily (`gcc`) and searching for files with `telescope` and so much more.  

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

If you don't have an `nvim` config ,feel free to use mine (based on that of the [BDFL](https://github.com/ChristianChiarulli) of LunarVim).

```
 
git clone https://github.com/gnmearacaun/nvim-launch.git ~/.config/nvim
```
- Note: if Mason errors are thrown on start up, run this command:

```
:Lazy reload mason.nvim
```

Now that Neovim is available, make it the default in `~/.config/zsh/exports.zsh`

```
export EDITOR="nvim"
```

### Install nodejs 

Utilizing [nodesource](https://github.com/nodesource/distributions), run as root:

```
sudo su
curl -fsSL https://deb.nodesource.com/setup_21.x | bash - &&\
apt-get install -y nodejs
```

### Additional Info

- The following augmented command is needed to run obs-studio for video recording on the Pi:

```
MESA_GL_VERSION_OVERRIDE=3.3 obs
```

### Upgrading Neovim

Later when you want to upgrade, go back into the neovim directory (wherever it's stashed). Assuming you're on the branch you want, to rebuild from scratch and replace the current build:

```
git pull
sudo make distclean && make CMAKE_BUILD_TYPE=Release
cd build && sudo cpack -G DEB && sudo dpkg -i nvim-linux64.deb
nvim -V1 -v
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

