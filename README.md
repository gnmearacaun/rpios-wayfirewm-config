# rpios-wayfirewm
Raspberry Pi OS Bookworm WayfireWM base configuration
## My Steps To Setting Up Raspberry Pi

Raspberry Pi Os Bookworm edition uses the WayfireWM as it's base, though on it's surface you'd hardly know it! By altering the ~/.config/wayfire.ini we can unlock the potential of navigating this exciting new desktop with keyboard shortcuts alone. The repo is related to the accompanying video.

Reset SSD to factory settings if it has wear
```
sudo nvme format -s1 -lb=0 /dev/nvme0n1
```
Flash RPiOS with rpi-imager
Change BOOT_ORDER line to boot from an SSD (I started with an sdcard). BOOT_ORDER options read from right to left, with 6 representing the nvme drive, 1 is sdcard and 4 is USB boot) 

```
sudo rpi-eeprom-config --edit
BOOT_ORDER=0xf416
```
Now reboot into RPiOS
Install some initial packages
```
sudo apt-get update
sudo apt-get install aptitude zoxide lsd zsh ranger ripgrep fd-find fzf vim-gtk3 alacritty kitty cmake ninja-build interception-caps2esc interception-tools interception-compat wf-recorder timeshift wl-clipboard wl-copy obs-studio dselect slurp
```
My process was to reboot with camera and mic plugged in to record session to record the video with the following command:
```
MESA_GL_VERSION_OVERRIDE=3.3 obs
```
Clone the config files from this repository
```

```
Drop wayfire.ini, config.txt and other configs into place. Usually when you make changes to wayfire.ini, RPiOS will log you out, to force you to log back in.
Customize lxterminal & taskbar, darken theme to taste.

## Install Debian package-list 
```
sudo apt-get install dselect --yes
sudo dpkg --set-selections < "packages.txt"
sudo apt-get dselect-upgrade -y
```
To display if any don't get installed
```
cut -f1 -d' ' packages.txt | xargs dpkg -l
```
## Build interception-tools so we can get around easily

[Interception-tools](https://gitlab.com/interception/linux/tools) `caps2esc` (caps_lock is esc when tapped or ctrl when held down), `space2meta` (space key acts as meta when held down in combination with other keys) and `s2arrows`  acts as the arrow keys combining s+j,k,h,l

We installed `interception-caps2esc interception-tools interception-compat` were already in the repo. The others, we build and move the executables into /usr/bin. Additionally, you'll need to, as sudo, put udevmon.yaml into /etc/interception/udevmon.d/ and enable udevmon as a service. 

```
git clone https://gitlab.com/interception/linux/plugins/space2meta.git
cd space2meta
cmake -Bbuild
cmake --build build
```

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

Get Nerdfonts
https://github.com/getnf/getnf
```
curl -fsSL https://raw.githubusercontent.com/ronniedroid/getnf/master/install.sh | bash
```
Run `getnf`

## zsh and zap
To set zsh as your default shell, execute the following.
```
sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)
```
# Or change shell: sudo chsh -s $(which zsh) $USER
https://www.zapzsh.com/
https://github.com/zap-zsh/zap
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
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
