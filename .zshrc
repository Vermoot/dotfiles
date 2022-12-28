# ------------------ Options ----------------------- {{{

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export HOMEBREW_NO_AUTO_UPDATE=1

eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship

export VISUAL=nvim
export EDITOR=nvim

export PATH="${HOME}/.local/bin:${PATH}"

export MOZ_USE_XINPUT2=1
export RANGER_DEVICONS_SEPARATOR="  "

# -------------------------------------------------- }}}

# ------------------ Aliases ----------------------- {{{

alias zshrc="nvim ~/.zshrc"
alias yabairc="nvim ~/.config/yabai/yabairc"
alias skhdrc="nvim ~/.config/skhd/skhdrc"
alias nvimrc="ranger ~/.config/nvim"
alias cxmonad="nvim ~/.config/xmonad/xmonad.hs"
alias cpicom="nvim ~/.config/picom/picom.conf"
alias cawesome="cd ~/.config/awesome && nvim ~/.config/awesome/rc.lua"

alias scrotsel="scrot -s -b ~/scrot.png && xclip -selection clipboard -t image/png ~/scrot.png && rm ~/scrot.png"
alias scrotwin="scrot -u -b ~/scrot.png && xclip -selection clipboard -t image/png ~/scrot.png && rm ~/scrot.png"
alias scrotscreen="scrot -u ~/scrot.png && xclip -selection clipboard -t image/png ~/scrot.png && rm ~/scrot.png"

alias audiowine="WINEPREFIX='/home/vermoot/.audiowine/prefix1'"

# -------------------------------------------------- }}}

export PATH=$PATH:/home/vermoot/.spicetify

__git_files () { 
    _wanted files expl 'local files' _files     
}

eval $(thefuck --alias)
