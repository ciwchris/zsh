# Path to your oh-my-zsh configuration.
ZSH=/usr/share/oh-my-zsh/

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="theunraveler"
[[ -f $HOME/.bin/color-mode/current-color-mode ]] && SOLARIZED_THEME=$(<$HOME/.bin/color-mode/current-color-mode)

PATH+=:$HOME/.bin

help-wifi() {
    # https://wiki.archlinux.org/index.php/NetworkManager#nmcli
    # https://fedoraproject.org/wiki/Networking/CLI
    echo "nmcli device wifi list   List available access points(AP) to connect to"
    echo "nmcli device wifi rescan Refresh previous list"
    echo "nmcli device wifi connect <SSID|BSSID> password <password>"
    echo "nmtui                    UI to edit/delete connections"
}
help-fzf() {
    echo "z                    Use z with fzf"
    echo "fe [FUZZY PATTERN]   Open the selected file with the default editor"
    echo "fd                   cd to selected directory"
    echo "fh                   repeat history"
    echo "cdf                  cd into the directory of the selected file"
    echo "fkill                kill process"
    echo "fshow                git commit browser"
}
help-rg() {
    echo "rg -g '^P*.cs' --files    Search file names"
}
help-vim() {
    echo "History"
    echo "Buffers"
    echo "Files"
    echo "Lines"
    echo "BLines"
    echo "GFiles?"
    echo "Help navigation: Ctrl-o and t"
}
help-i3() {
    echo "mod+Shift+l           lock"
    echo "mod+Shift+r           reload"
}
help-fzf

# z: https://github.com/rupa/z
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh


alias disk-usage="sudo du */ -smx | sort -n"
alias n="nvim"
alias vim="nvim"
alias cls="clear"
alias hist="history | tail -n 5 | sort -rn"

alias headphones="$HOME/a2dp.py 04:5D:4B:66:17:36"
alias screencastRecord="$HOME/.bin/video-recording.sh -s"
alias webcamRecord="$HOME/.bin/video-recording.sh -w"
alias youtubeConvert="$HOME/.bin/video-recording.sh -y"
alias webmConvert="$HOME/.bin/video-recording.sh -c"

alias monitor-off="sleep 1; xset dpms force off"
alias restart="shutdown -r now"
alias shutdown="shutdown -P now"

alias monitor-vga="xrandr --output VGA1 --auto --right-of LVDS1"
alias monitor-vga-off="xrandr --output VGA1 --off"
alias monitor-hdmi="xrandr --output HDMI1 --auto --right-of LVDS1"
alias monitor-hdmi-off="xrandr --output HDMI1 --off"

export FIREFOX_BIN=/usr/bin/firefox
export CHROME_BIN=/usr/bin/chromium
export BROWSER=/usr/bin/firefox


github() {
    xdg-open "https://github.$(git config remote.origin.url | cut -f2 -d. | tr ':' /)"
}

[[ -r "/usr/share/fzf/key-bindings.zsh" ]] && source /usr/share/fzf/key-bindings.zsh
[[ -r "/usr/share/fzf/completion.zsh" ]] && source /usr/share/fzf/completion.zsh
# http://owen.cymru/fzf-ripgrep-navigate-with-bash-faster-than-ever-before/
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'

export FZF_DEFAULT_OPTS='--height 60% --reverse --border'

# https://github.com/junegunn/fzf/wiki/Examples
# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fh - repeat history
fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# cdf - cd into the directory of the selected file
cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# fkill - kill process
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# fshow - git commit browser
fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}


# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)

# Other plugins to try (archlinux bundler gem lein mvn npm vi-mode last-working-dir)
plugins=()

source $ZSH/oh-my-zsh.sh
source /usr/share/nvm/init-nvm.sh

# Customize to your needs...
export VISUAL=nvim
export EDITOR=nvim

# Create symbolic links to directory location to jump to the location easily
# http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
export MARKPATH=$HOME/.marks
function jump {
	cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark {
	mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark {
	rm -i "$MARKPATH/$1"
}
function marks {
	ls -l "$MARKPATH" | sed 's/ / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}
function _completemarks {
	reply=($(ls $MARKPATH))
}
compctl -K _completemarks jump
compctl -K _completemarks unmark
# End jumps

function start-ssh {
    eval $(ssh-agent)
    ssh-add ~/.ssh/id_ed25519
}

# https://dev.to/ricardomol/note-taking-from-the-command-line-156 (in comments)
function note {
  if [ ! -z "$1" ]; then
    echo $(date +"%Y%m%d-%H%M%S") $@  >> $HOME/notes/TempNotes.wiki
  else
    echo $(date +"%Y%m%d-%H%M%S") "$(cat)"  >> $HOME/notes/TempNotes.wiki
  fi
}
