#!/usr/bin/env bash
# install.sh — adds `claude-init` command to your shell
# Works on: Arch, Ubuntu, PopOS, macOS, Windows WSL
# Usage: curl -fsSL https://raw.githubusercontent.com/jhaksh-24/claude-init/main/install.sh | bash

set -euo pipefail

REPO="https://raw.githubusercontent.com/jhaksh-24/claude-init/main"
INSTALL_DIR="$HOME/.claude-init"
BIN_DIR="$HOME/.local/bin"

# ── colors ────────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

info()    { echo -e "${CYAN}→${RESET} $1"; }
success() { echo -e "${GREEN}✓${RESET} $1"; }
bold()    { echo -e "${BOLD}$1${RESET}"; }

echo ""
bold "Installing claude-init..."
echo ""

# ── create dirs ───────────────────────────────────────────────────────────────
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"

# ── download init.sh ──────────────────────────────────────────────────────────
info "Downloading init.sh..."
curl -fsSL "$REPO/init.sh" -o "$INSTALL_DIR/init.sh"
chmod +x "$INSTALL_DIR/init.sh"
success "Downloaded init.sh"

# ── create claude-init command ────────────────────────────────────────────────
cat > "$BIN_DIR/claude-init" << 'EOF'
#!/usr/bin/env bash
exec "$HOME/.claude-init/init.sh" "$@"
EOF
chmod +x "$BIN_DIR/claude-init"
success "Created claude-init command"

# ── detect shell and add to PATH ──────────────────────────────────────────────
SHELL_NAME=$(basename "$SHELL")
RC_FILE=""

case "$SHELL_NAME" in
  bash)
    RC_FILE="$HOME/.bashrc"
    ;;
  zsh)
    RC_FILE="$HOME/.zshrc"
    ;;
  fish)
    RC_FILE="$HOME/.config/fish/config.fish"
    ;;
  *)
    RC_FILE="$HOME/.bashrc"
    ;;
esac

PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'

if [ "$SHELL_NAME" = "fish" ]; then
  PATH_LINE='fish_add_path $HOME/.local/bin'
fi

if ! grep -q ".local/bin" "$RC_FILE" 2>/dev/null; then
  echo "" >> "$RC_FILE"
  echo "# claude-init" >> "$RC_FILE"
  echo "$PATH_LINE" >> "$RC_FILE"
  success "Added to PATH in $RC_FILE"
else
  success "PATH already configured"
fi

# ── done ──────────────────────────────────────────────────────────────────────
echo ""
bold "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
success "claude-init installed"
bold "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "  Reload your shell:"
echo -e "  ${BOLD}source $RC_FILE${RESET}"
echo ""
echo -e "  Then in any project:"
echo -e "  ${BOLD}claude-init${RESET}"
echo ""
echo -e "  ${DIM}Remember to create prompt.md first${RESET}"
echo ""
