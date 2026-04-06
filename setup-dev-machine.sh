#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE_PATH="$ROOT_DIR/Brewfile"
MISE_CONFIG_PATH="$ROOT_DIR/.config/mise/config.toml"

NPM_GLOBAL_PACKAGES=(
  "@anthropic-ai/claude-code"
  "@mariozechner/pi-coding-agent"
  "agent-browser"
  "agent-device"
  "eas-cli"
  "husky"
  "npm"
  "ralphy-cli"
  "yarn"
)

GO_GLOBAL_PACKAGES=(
  "github.com/kpym/gm@latest"
)

CARGO_PACKAGES=(
  "flamegraph"
  "mdbook"
  "rover_cli"
  "rustlings"
  "samply"
  "stylua"
  "wasm-pack"
)

log() {
  printf "\n==> %s\n" "$1"
}

ensure_xcode_cli() {
  if xcode-select -p >/dev/null 2>&1; then
    return
  fi

  log "install xcode command line tools"
  xcode-select --install || true
  printf "xcode cli install triggered. finish install then rerun script.\n"
  exit 1
}

ensure_homebrew() {
  if ! command -v brew >/dev/null 2>&1; then
    log "install homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

install_brew_bundle() {
  if [[ ! -f "$BREWFILE_PATH" ]]; then
    printf "missing Brewfile at %s\n" "$BREWFILE_PATH"
    exit 1
  fi

  log "install brew formulas+casks"
  brew bundle --file "$BREWFILE_PATH"
}

stow_dotfiles() {
  local packages=()

  if ! command -v stow >/dev/null 2>&1; then
    log "install stow"
    brew install stow
  fi

  if [[ -d "$ROOT_DIR/.config" ]]; then
    packages+=(".config")
  fi

  if [[ -d "$ROOT_DIR/.local" ]]; then
    packages+=(".local")
  fi

  log "stow dotfiles into home"
  if [[ "${#packages[@]}" -gt 0 ]]; then
    stow --target "$HOME" --dir "$ROOT_DIR" "${packages[@]}"
  fi

  if [[ -f "$ROOT_DIR/.luarc.json" ]]; then
    ln -snf "$ROOT_DIR/.luarc.json" "$HOME/.luarc.json"
  fi
}

ensure_mise_bin() {
  if command -v mise >/dev/null 2>&1; then
    command -v mise
    return
  fi

  log "install mise"
  brew install mise
  if command -v mise >/dev/null 2>&1; then
    command -v mise
    return
  fi

  if [[ -x "$HOME/.local/bin/mise" ]]; then
    printf "%s\n" "$HOME/.local/bin/mise"
    return
  fi

  printf "mise install failed\n"
  exit 1
}

install_mise_tools() {
  local mise_bin
  mise_bin="$(ensure_mise_bin)"

  if [[ ! -f "$MISE_CONFIG_PATH" ]]; then
    printf "missing mise config at %s\n" "$MISE_CONFIG_PATH"
    exit 1
  fi

  log "trust+install mise tools"
  MISE_CONFIG_FILE="$MISE_CONFIG_PATH" "$mise_bin" trust "$MISE_CONFIG_PATH" || true
  MISE_CONFIG_FILE="$MISE_CONFIG_PATH" "$mise_bin" install
}

install_npm_globals() {
  if ! command -v npm >/dev/null 2>&1; then
    log "skip npm globals (npm missing)"
    return
  fi

  log "install npm globals"
  npm install -g "${NPM_GLOBAL_PACKAGES[@]}"
}

install_go_globals() {
  if ! command -v go >/dev/null 2>&1; then
    log "skip go globals (go missing)"
    return
  fi

  log "install go globals"
  for pkg in "${GO_GLOBAL_PACKAGES[@]}"; do
    go install "$pkg"
  done
}

install_cargo_tools() {
  if ! command -v cargo >/dev/null 2>&1; then
    log "skip cargo tools (cargo missing)"
    return
  fi

  log "install cargo tools"
  for pkg in "${CARGO_PACKAGES[@]}"; do
    cargo install "$pkg" || cargo install --force "$pkg"
  done
}

install_opencode_plugin_deps() {
  if ! command -v npm >/dev/null 2>&1; then
    return
  fi

  if [[ -f "$ROOT_DIR/.config/opencode/package.json" ]]; then
    log "install opencode plugin deps"
    (
      cd "$ROOT_DIR/.config/opencode"
      npm install
    )
  fi
}

configure_macos_defaults() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    return
  fi

  log "apply macos defaults (dock/finder/menubar)"

  # Dock: smallest, right side, hidden
  defaults write com.apple.dock tilesize -int 16
  defaults write com.apple.dock orientation -string "right"
  defaults write com.apple.dock autohide -bool true

  # Menu bar: auto-hide
  defaults write NSGlobalDomain _HIHideMenuBar -bool true

  # Finder: home as default, show path+status bars
  defaults write com.apple.finder NewWindowTarget -string "PfHm"
  defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder ShowStatusBar -bool true
  defaults write com.apple.finder AppleShowAllFiles -bool true
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  killall Dock >/dev/null 2>&1 || true
  killall Finder >/dev/null 2>&1 || true
  killall SystemUIServer >/dev/null 2>&1 || true
}

main() {
  ensure_xcode_cli
  ensure_homebrew
  install_brew_bundle
  stow_dotfiles
  install_mise_tools
  install_npm_globals
  install_go_globals
  install_cargo_tools
  install_opencode_plugin_deps
  configure_macos_defaults

  log "done"
  printf "restart shell, then run: mise doctor\n"
}

main "$@"
