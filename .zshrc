# Path to your oh-my-zsh configuration.
ZSH=/usr/share/oh-my-zsh/

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="theunraveler"
[[ -f $HOME/.bin/color-mode/current-color-mode ]] && SOLARIZED_THEME=$(<$HOME/.bin/color-mode/current-color-mode)

alias disk-usage="sudo du */ -smx | sort -n"
alias n="nvim"

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
export ELM_HOME=/usr/local/lib/node_modules/elm/share

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
