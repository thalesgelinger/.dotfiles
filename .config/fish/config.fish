function fish_greeting; end

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

set -gx ANDROID_HOME /Users/thalesgelinger/Library/Android/sdk
set -gx ANDROID_NDK_HOME ~/Library/Android/sdk/ndk/23.1.7779620
set -gx ANDROID_SDK_ROOT /Users/thalesgelinger/Library/Android/sdk
set -gx ANDROID_SDK_HOME ~/Library/Android
set -gx GRADLE_USER_HOME ~/.gradle

set -gx PATH $ANDROID_HOME/tools $PATH
set -gx PATH $ANDROID_HOME/emulator $PATH
set -gx PATH $ANDROID_HOME/tools/bin $PATH
set -gx PATH $ANDROID_HOME/platform-tools $PATH


set -gx PATH /usr/bin:/bin:/usr/sbin:/sbin $PATH 
set -gx PATH /Users/thalesgelinger/.local/bin $PATH 

set -gx PATH $HOME/.maestro/bin $PATH
set -gx PATH (gem environment | grep 'EXECUTABLE DIRECTORY' | cut -d: -f2 | string trim) $PATH


fish_add_path /opt/homebrew/opt/llvm/bin

# LLVM flags
set -gx LDFLAGS "-L/opt/homebrew/opt/llvm/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/llvm/include"

# Function to install Ruby versions without LDFLAGS conflicts
function install_ruby
    set -l original_ldflags $LDFLAGS
    set -l original_cppflags $CPPFLAGS
    set -e LDFLAGS
    set -e CPPFLAGS
    mise use -g $argv
    set -gx LDFLAGS $original_ldflags
    set -gx CPPFLAGS $original_cppflags
end

# Ruby path (using Homebrew installation) - prepend to take priority
set -px PATH /opt/homebrew/opt/ruby@3.3/bin

#Nix
set -x PATH /run/current-system/sw/bin $PATH

set -gx C_INCLUDE_PATH /opt/homebrew/Cellar/json-c/0.17/include/json-c $C_INCLUDE_PATH
set -gx LIBRARY_PATH /opt/homebrew/Cellar/json-c/0.17/lib $LIBRARY_PATH

set -gx PATH $HOME/.maestro/bin $PATH

set -gx MLC_LLM_SOURCE_DIR $(pwd)


set GOPATH $HOME/go 

set -gx ALLOWED_DIRECTORY /Users/thalesgelinger/Projects

set XDG_CONFIG_HOME $HOME/.config
set XDG_DATA_HOME $HOME/.local/share
set XDG_CACHE_HOME $HOME/.cache


set -gx EDITOR nvim
set -gx REACT_EDITOR nvim

source ~/.config/fish/api_keys/keys

#set -gx LUA_PATH "$(luarocks path --lr-path)"
#set -gx LUA_CPATH "$(luarocks path --lr-cpath)"


# ALIAS
alias intel "arch -x86_64"

alias ls "eza -la --icons"
alias cat "bat"
alias .. "cd .."
alias vim "nvim"
alias g "git"
alias cd "z"

alias d "docker"
alias ds "docker service"
alias oc "opencode --port"

alias systrace "$ANDROID_HOME/platform-tools/systrace/systrace.py --time=10 -o trace.html sched gfx view -a "

if test -d (brew --prefix)"/share/fish/completions"
    set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/completions
end

if test -d (brew --prefix)"/share/fish/vendor_completions.d"
    set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
end


if test -f "$HOME/.config/fish/secrets.fish"
    source "$HOME/.config/fish/secrets.fish"
end

function load_env --description 'Load environment variables from .env file'
    for line in (cat $argv[1] | grep -v '^#' | grep -v '^$')
        set -gx (echo $line | cut -d= -f1) (echo $line | cut -d= -f2-)
    end
end

function kill_port --description 'Kill port process running'
    lsof -ti:$argv[1] | xargs kill -9
end

function notify_whats --description 'Send a whats app message from cli'
    set msg $argv[1]

    if not set -q TWILIO_ACCOUNT_SID
        echo "TWILIO_ACCOUNT_SID is required"
        return 1
    end

    if not set -q TWILIO_AUTH_TOKEN
        echo "TWILIO_AUTH_TOKEN is required"
        return 1
    end

    if not set -q TWILIO_WHATSAPP_TO
        echo "TWILIO_WHATSAPP_TO is required"
        return 1
    end

    if not set -q TWILIO_WHATSAPP_FROM
        echo "TWILIO_WHATSAPP_FROM is required"
        return 1
    end

    if not set -q TWILIO_CONTENT_SID
        echo "TWILIO_CONTENT_SID is required"
        return 1
    end

    curl "https://api.twilio.com/2010-04-01/Accounts/$TWILIO_ACCOUNT_SID/Messages.json" -X POST \
        --data-urlencode "To=$TWILIO_WHATSAPP_TO" \
        --data-urlencode "From=$TWILIO_WHATSAPP_FROM" \
        --data-urlencode "ContentSid=$TWILIO_CONTENT_SID" \
        --data-urlencode "ContentVariables={\"1\":\"$msg\"}" \
        -u "$TWILIO_ACCOUNT_SID:$TWILIO_AUTH_TOKEN"
end

function get_book --description "Download a web book/site as markdown files for offline use in ~/books"
    if test (count $argv) -lt 1
        echo "Usage: get_book <url>"
        return 1
    end

    set -l url $argv[1]
    # Extract domain for output subdirectory
    set -l domain (string match -r '^https?://([^/]+)' $url)[2]
    if test -z "$domain"
        echo "Invalid URL format."
        return 1
    end

    set -l books_dir "$HOME/books"
    mkdir -p $books_dir/$domain
    cd $books_dir/$domain || return 1

    # Mirror the site offline (recursive, convert links, stay on domain)
    wget --mirror --convert-links --adjust-extension --page-requisites --no-parent --domains=$domain $url
end

#tmux source-file ~/.config/tmux/tmux.conf
# zoxide init fish | source


# opencode
fish_add_path /Users/thalesgelinger/.opencode/bin

zoxide init fish | source

# sst
fish_add_path /Users/thalesgelinger/.sst/bin

/Users/thalesgelinger/.local/bin/mise activate fish | source # added by https://mise.run/fish
eval "$(mise activate fish)"

# Auto-start SSH agent
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c) > /dev/null
    ssh-add --apple-use-keychain ~/.ssh/personal ~/.ssh/strategycx ~/.ssh/herbalife 2>/dev/null
end

# wezterm switch-workspace CLI
set -gx PATH $HOME/.config/wezterm/bin $PATH

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/thalesgelinger/.lmstudio/bin
# End of LM Studio CLI section

# OpenClaw Completion
source "/Users/thalesgelinger/.openclaw/completions/openclaw.fish"
