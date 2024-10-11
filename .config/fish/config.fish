# Themes
set -g theme_nerd_fonts yes
set -g theme_powerline_fonts no
set -g theme_short_path yes

source ~/.config/fish/themes/tokyo

# PATH

set -gx PATH /usr/local/bin  $PATH
set -gx PATH /usr/sbin  $PATH
set -gx PATH /opt/homebrew/bin $PATH
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $HOME/.jenv/bin $PATH

set -gx ANDROID_HOME /Users/tgelin01/Library/Android/sdk
set -gx ANDROID_NDK_HOME ~/Library/Android/sdk/ndk/23.1.7779620
set -gx ANDROID_SDK_ROOT /Users/tgelin01/Library/Android/sdk
set -gx ANDROID_SDK_HOME ~/Library/Android
set -gx GRADLE_USER_HOME ~/.gradle

set -gx PATH $ANDROID_HOME/tools $PATH
set -gx PATH $ANDROID_HOME/emulator $PATH
set -gx PATH $ANDROID_HOME/tools/bin $PATH
set -gx PATH $ANDROID_HOME/platform-tools $PATH


set -gx PATH /usr/bin:/bin:/usr/sbin:/sbin $PATH 
set -gx PATH /Users/tgelin01/.local/bin $PATH 

set -gx PATH /opt/homebrew/opt/llvm/bin $PATH

set -gx PATH $HOME/.maestro/bin $PATH

set -gx C_INCLUDE_PATH /opt/homebrew/Cellar/json-c/0.17/include/json-c $C_INCLUDE_PATH
set -gx LIBRARY_PATH /opt/homebrew/Cellar/json-c/0.17/lib $LIBRARY_PATH

set -gx PATH $HOME/.maestro/bin $PATH

set GOPATH $HOME/go 

set XDG_CONFIG_HOME $HOME/.config
set XDG_DATA_HOME $HOME/.local/share
set XDG_CACHE_HOME $HOME/.cache


set -gx EDITOR nvim
set -gx REACT_EDITOR nvim

# ALIAS
alias intel "arch -x86_64"

alias ls "eza -la --icons"
alias cat "bat"
alias .. "cd .."
alias vim "nvim"

alias systrace "$ANDROID_HOME/platform-tools/systrace/systrace.py --time=10 -o trace.html sched gfx view -a "

if test -d (brew --prefix)"/share/fish/completions"
    set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/completions
end

if test -d (brew --prefix)"/share/fish/vendor_completions.d"
    set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
end


set -gx LDFLAGS "-L/opt/homebrew/opt/llvm/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/llvm/include"

tmux source-file ~/.config/tmux/tmux.conf
# zoxide init fish | source

source /opt/homebrew/opt/asdf/libexec/asdf.fish
