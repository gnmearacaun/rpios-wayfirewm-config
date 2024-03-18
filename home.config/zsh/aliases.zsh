#!/bin/sh
alias j='z'
alias f='zi'
alias g='lazygit'
alias zup="find "$ZDOTDIR/plugins" -type d -exec test -e '{}/.git' ';' -print0 | xargs -I {} -0 git -C {} pull -q"
alias ni='nvim ~/.config/nvim/'
alias i="lsparu"
alias p="sudo pacman -S"
alias lvim="env TERM=wezterm lvim"

# alias lvim='nvim -u ~/.local/share/lunarvim/lvim/init.lua --cmd "set runtimepath+=~/.local/share/lunarvim/lvim"'

# get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Remarkable
# alias remarkable_ssh='ssh root@10.11.99.1'
# alias restream='restream -p'

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# easier to read disk
alias df='df -h'     # human-readable sizes
alias free='free -m' # show sizes in MB

# get top process eating memory
alias psmem='ps auxf | sort -nr -k 4 | head -5'

# get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3 | head -5'

# gpg encryption
# verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
# receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"

# For when keys break
alias archlinx-fix-keys="sudo pacman-key --init && sudo pacman-key --populate archlinux && sudo pacman-key --refresh-keys"

# systemd
alias mlist_systemctl="systemctl list-unit-files --state=enabled"

alias mach_java_mode="export SDKMAN_DIR="$HOME/.sdkman" && [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh""

alias m="git checkout master"
alias s="git checkout stable"

if [[ $TERM == "xterm-kitty" ]]; then
  alias ssh="kitty +kitten ssh"
fi

alias ls='ls --color=auto'

# bod
alias q="exit"
alias f="fzf"
alias v='fd --type f --hidden --exclude .git | fzf --reverse | xargs lvim'
# alias gc="git clone"
alias cc="git clone"
alias rs="cd ~/scripts/digitalneanderthal/ && hugo server -D &"
alias gc="cd $HOME/.config && ranger"
alias ge="cd /etc"
alias gd="cd $HOME/downloads"
# alias gh="cd $HOME"
alias gL="cd $HOME/.local/share/lunarvim/lvim && ranger"
alias gl="cd $HOME/.config/lvim/lua/user && ranger"
alias gn="cd $HOME/.config/nvim/lua/user/ && ranger"
alias gm="cd /run/media/briain && ranger"
alias gg="cd $HOME/.local/repos && ranger"
alias lp="cd $HOME/.local/share/lunarvim/site/pack/packer && ranger"
alias np="cd $HOME/.local/share/nvim/site/pack/packer && ranger"
alias gi="cd $HOME/.config/nvim && ranger"
alias cl="cd $HOME/.config/lvim/lua/user"
alias gp="cd $HOME/.local/share/nvim/site/pack/packer && ranger"
alias gr="cd $HOME/.config/ranger && ranger"
alias gs="cd $HOME/scripts/stow && ranger"
alias gv='cd /var'
alias gw='cd ~/.config/hypr && ranger'
alias gz="cd $HOME/.config/zsh && ranger"
alias gZ="cd $HOME/.local/share/zap/plugins && ranger"
alias scripts='cd ~/scripts'
#alias nvim='lvim'
alias l='lvim'
alias li='lvim ~/.config/lvim/utils'
alias lk='lvim ~/.config/lvim/lua/keymappings.lua'
alias n='nvim'
alias na="nvim ~/.alias"
alias nc='nvim ~/.config/nvim/lua/user/cmp.lua'
alias nh='nvim ~/.config/hypr/hyprland.conf'
alias nk='nvim ~/.config/nvim/lua/user/keymaps.lua'
alias nn='nvim ~/.config/ncmpcpp/config'
alias nr='nvim ~/.config/ranger/rc.conf'
alias nu='nvim ~/.config/newsboat/urls'
alias nw='nvim ~/.config/nvim/lua/user/whichkey.lua'
alias nW='nvim ~/.w3m/config'
alias nz='nvim ~/.zshrc'
alias syn="syncthing &"
alias sn='sudo nvim'
#alias sn='sudo nvim -u ~/.config/nvim/init.lua'
#alias rf='. ~/.zshrc'
alias sr="sudo ranger"
alias rh="~/scripts/digitalneanderthal/themes/after-dark/bin/help"
alias ks="kill $(ps aux | awk '/[h]ugo.*1313/ {print $2}')"
alias kh="kill $(ps aux | awk '/[h]ugo.*1414/ {print $2}')"
alias kp="kcolorchooser &"
#alias ff="/opt/firefox67/firefox -new-window file:///home/briain/black_screen.html &"
alias ff="/opt/firefox67/firefox &"
alias nb='newsboat'
alias lynx='rdrview -B /usr/bin/lynx'
alias rl='rdrview -B /usr/bin/lynx'
alias w='rdrview -B /usr/bin/w3m'
#alias w3m='rdrview -B /usr/bin/w3m'
alias cat='batcat'
alias b='batcat'
alias c='clear'
alias po='sudo swapoff -a && pass open --timer=3h && sudo swapon -a'
alias pc='sudo swapoff -a && pass close && sudo swapon -a'
alias ri='redshift-gtk &'
alias d='dmenu_run'
alias p='python3'
alias k='kill -9'
alias fa="fortune art"
alias fc="fortune -a | cowsay"
alias fe="fortune bofh-excuses"
alias fdis="fortune disclaimer"
alias fl="fortune literature"
alias fo="fortune off"
alias fh="fortune platitudes"
alias fp="fortune paradoxum"
alias fs="fortune startrek"
alias ft="fortune tao"
alias fw="fortune wisdom"
alias fy="fortune work"
alias fz="fortune zippy"
alias fgt="echo 'ft aliases figlet-toilet' && figlet-toilet"
alias mybad="echo 'fortune bofh-excuses' && fortune bofh-excuses"
alias oops="echo 'fortune bofh-excuses' && fortune bofh-excuses"
alias shit="fuck && fortune bofh-excuses"
alias sp='aspell -a'
#alias d='dict -d gcide'
alias dw='dict -d wn'
alias da='dict'
alias t='dict -d moby-thesaurus'
alias c-c='xclip -sel clip'
alias c-v='xclip -o -sel clip'
if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi
#alias vim='nvim .'
alias s='sudo'
alias sduo='sudo'
alias apt='sudo aptitude'
alias install='sudo apt-get install'
alias search='sudo apt-cache search'
alias purge='sudo apt-get purge'
alias update='sudo apt-get update'
alias c7='sudo chmod -R 777'
alias ll='ls -l'
alias www='cd /var/www'
alias r="ranger"
# alias briss="/usr/bin/java -jar /home/briain/scripts/software/briss-0.9/briss-0.9.jar"
alias ..='cd ..'
alias lsl='ls -l | less'
alias la='ls -a'
alias lc='ls -CF'
alias cl="clear; ls -CF"
alias m="less"
alias lynx="lynx www.google.ie"
alias pi="ps aux | grep"
alias zz="systemctl suspend"
alias dir='ls -ba'
alias tree='tree -C'
# alias config='/usr/bin/git --git-dir=/home/briain/.cfgsgit/ --work-tree=/home/briain'
alias gpg="gpg2"
alias mdf='for i in *.html ; do echo $i && rdrview --template=title,sitename,byline,body -H $i | html2markdown --no-skip-internal-links --no-automatic-links --no-wrap-links --ignore-images --unicode-snob --mark-code --body-width=0 --single-line-break --decode-errors=ignore > $i.md ; done'
