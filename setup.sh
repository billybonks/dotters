#!/bin/bash
set -e

# ============================================
# Omarchy Setup Script (Arch Linux + Hyprland)
# ============================================

# Resolve target user's home dir even if script is run with sudo
if [[ -n "${SUDO_USER:-}" ]]; then
  TARGET_USER="$SUDO_USER"
else
  TARGET_USER="$USER"
fi
TARGET_HOME="$(eval echo "~$TARGET_USER")"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

GHOSTTY_CONFIG="$TARGET_HOME/.config/ghostty/config"
HYPR_INPUT_CONFIG="$TARGET_HOME/.config/hypr/input.conf"
HYPR_MONITORS_CONFIG="$TARGET_HOME/.config/hypr/monitors.conf"
XDG_TERMINALS_LIST="$TARGET_HOME/.config/xdg-terminals.list"
REPO_GITCONFIG="$SCRIPT_DIR/gitconfig"
TARGET_GITCONFIG="$TARGET_HOME/.gitconfig"
REPO_BASHRC_SNIPPET="$SCRIPT_DIR/bashrc"
TARGET_BASHRC="$TARGET_HOME/.bashrc"

# --- Terminal: Ghostty as default, remove Alacritty ---
if pacman -Q ghostty &>/dev/null; then
  echo "✓ Ghostty already installed"
else
  echo "Installing Ghostty..."
  sudo pacman -S --noconfirm ghostty
fi

if pacman -Q alacritty &>/dev/null; then
  echo "Removing Alacritty..."
  sudo pacman -Rns --noconfirm alacritty
else
  echo "✓ Alacritty already removed"
fi

# --- Gaming: Install Lutris ---
if pacman -Q lutris &>/dev/null; then
  echo "✓ Lutris already installed"
else
  echo "Installing Lutris..."
  sudo pacman -S --noconfirm lutris
fi

# --- Apps: Install Zed and flyctl ---
if pacman -Q zed &>/dev/null; then
  echo "✓ Zed already installed"
else
  echo "Installing Zed..."
  if sudo pacman -S --noconfirm zed; then
    echo "✓ Zed installed"
  else
    echo "⚠ Could not install package 'zed' via pacman"
  fi
fi

if command -v fly >/dev/null 2>&1; then
  echo "✓ flyctl already installed"
else
  echo "Installing flyctl..."
  if curl -L https://fly.io/install.sh | sh; then
    echo "✓ flyctl installed"
  else
    echo "⚠ Could not install flyctl via install script"
  fi
fi

# --- Ghostty: Set mouse scroll multiplier ---
if [[ -f "$GHOSTTY_CONFIG" ]]; then
  if grep -q "mouse-scroll-multiplier" "$GHOSTTY_CONFIG"; then
    sed -i 's/mouse-scroll-multiplier = .*/mouse-scroll-multiplier = 1.9/' "$GHOSTTY_CONFIG"
  else
    echo "mouse-scroll-multiplier = 1.9" >> "$GHOSTTY_CONFIG"
  fi
  echo "✓ Ghostty mouse scroll multiplier set to 1.9"
fi

# --- Keyboard: Set desired kb_options ---
DESIRED_KB_OPTIONS="kb_options = compose:caps, altwin:swap_alt_win"
if [[ -f "$HYPR_INPUT_CONFIG" ]]; then
  if grep -Eq '^[[:space:]]*kb_options[[:space:]]*=[[:space:]]*compose:caps,[[:space:]]*altwin:swap_alt_win[[:space:]]*$' "$HYPR_INPUT_CONFIG"; then
    echo "✓ kb_options already set"
  else
    echo "Setting kb_options..."
    if grep -Eq '^[[:space:]]*kb_options[[:space:]]*=' "$HYPR_INPUT_CONFIG"; then
      sed -i -E "s|^[[:space:]]*kb_options[[:space:]]*=.*$|$DESIRED_KB_OPTIONS|" "$HYPR_INPUT_CONFIG"
    else
      echo "$DESIRED_KB_OPTIONS" >> "$HYPR_INPUT_CONFIG"
    fi
    echo "✓ kb_options set to: compose:caps, altwin:swap_alt_win"
  fi
else
  echo "⚠ Hypr config not found at $HYPR_INPUT_CONFIG, skipping kb_options"
fi

# --- Monitor: Set DP-3 to 4K @ 120Hz ---
# NOTE: This is a workaround for an AMD DC resume bug (black screen/no signal after suspend).
# You can solve it either by:
# 1) Kernel option: amdgpu.dcdebugmask=0x12
# 2) Resume workaround script: on resume, temporarily switch 120Hz -> 144Hz via hyprctl keyword monitor.
DESIRED_MONITOR="monitor=DP-3,3840x2160@120,0x0,1.5"
if [[ -f "$HYPR_MONITORS_CONFIG" ]]; then
  if grep -Eq '^[[:space:]]*monitor[[:space:]]*=[[:space:]]*DP-3,[[:space:]]*3840x2160@120,[[:space:]]*0x0,[[:space:]]*1\.5[[:space:]]*$' "$HYPR_MONITORS_CONFIG"; then
    echo "✓ Monitor already set to 120Hz"
  else
    echo "Setting monitor refresh rate to 120Hz..."
    if grep -Eq '^[[:space:]]*monitor[[:space:]]*=' "$HYPR_MONITORS_CONFIG"; then
      sed -i -E "s|^[[:space:]]*monitor[[:space:]]*=.*$|$DESIRED_MONITOR|" "$HYPR_MONITORS_CONFIG"
    else
      echo "$DESIRED_MONITOR" >> "$HYPR_MONITORS_CONFIG"
    fi
    echo "✓ Monitor line set to: DP-3 3840x2160@120 0x0 scale 1.5"
  fi
else
  echo "⚠ Hypr monitor config not found at $HYPR_MONITORS_CONFIG, skipping monitor setup"
fi

# Ensure Ghostty is set as default terminal via xdg-terminal-exec
mkdir -p "$TARGET_HOME/.config"
if [[ -f "$XDG_TERMINALS_LIST" ]]; then
  if grep -q "com.mitchellh.ghostty.desktop" "$XDG_TERMINALS_LIST"; then
    echo "✓ Ghostty already set as default terminal"
  else
    echo "Setting Ghostty as default terminal..."
    sed -i '1i com.mitchellh.ghostty.desktop' "$XDG_TERMINALS_LIST"
  fi
else
  echo "Setting Ghostty as default terminal..."
  echo "com.mitchellh.ghostty.desktop" > "$XDG_TERMINALS_LIST"
fi

# Ensure repo gitconfig is the machine gitconfig
if [[ -f "$REPO_GITCONFIG" ]]; then
  if [[ -L "$TARGET_GITCONFIG" ]] && [[ "$(readlink -f "$TARGET_GITCONFIG")" == "$REPO_GITCONFIG" ]]; then
    echo "✓ Repo gitconfig already active"
  else
    if [[ -e "$TARGET_GITCONFIG" || -L "$TARGET_GITCONFIG" ]]; then
      BACKUP_GITCONFIG="$TARGET_HOME/.gitconfig.backup.$(date +%Y%m%d%H%M%S)"
      mv "$TARGET_GITCONFIG" "$BACKUP_GITCONFIG"
      echo "Backed up existing gitconfig to $BACKUP_GITCONFIG"
    fi
    ln -s "$REPO_GITCONFIG" "$TARGET_GITCONFIG"
    if [[ "$(id -u)" -eq 0 ]]; then
      chown -h "$TARGET_USER:$TARGET_USER" "$TARGET_GITCONFIG"
    fi
    echo "✓ Linked repo gitconfig to $TARGET_GITCONFIG"
  fi
else
  echo "⚠ Repo gitconfig not found at $REPO_GITCONFIG, skipping git config setup"
fi

# Append repo bashrc snippet to user's ~/.bashrc
if [[ -f "$REPO_BASHRC_SNIPPET" ]]; then
  touch "$TARGET_BASHRC"
  if grep -q "# >>> dotters bashrc snippet >>>" "$TARGET_BASHRC"; then
    echo "✓ Repo bashrc snippet already present in $TARGET_BASHRC"
  else
    {
      echo ""
      echo "# >>> dotters bashrc snippet >>>"
      cat "$REPO_BASHRC_SNIPPET"
      echo "# <<< dotters bashrc snippet <<<"
    } >> "$TARGET_BASHRC"

    if [[ "$(id -u)" -eq 0 ]]; then
      chown "$TARGET_USER:$TARGET_USER" "$TARGET_BASHRC"
    fi
    echo "✓ Appended repo bashrc snippet to $TARGET_BASHRC"
  fi
else
  echo "⚠ Repo bashrc snippet not found at $REPO_BASHRC_SNIPPET, skipping ~/.bashrc update"
fi

# Convert this repo remote from HTTPS to SSH after gitconfig is in place
if [[ -d "$SCRIPT_DIR/.git" ]]; then
  if [[ "$(id -u)" -eq 0 ]]; then
    ORIGIN_URL="$(sudo -u "$TARGET_USER" git -C "$SCRIPT_DIR" remote get-url origin 2>/dev/null || true)"
  else
    ORIGIN_URL="$(git -C "$SCRIPT_DIR" remote get-url origin 2>/dev/null || true)"
  fi

  if [[ -n "$ORIGIN_URL" ]]; then
    if [[ "$ORIGIN_URL" =~ ^https://github\.com/(.+)$ ]]; then
      SSH_PATH="${BASH_REMATCH[1]}"
      SSH_URL="git@github.com:${SSH_PATH}"
      if [[ "$SSH_URL" != *.git ]]; then
        SSH_URL="${SSH_URL}.git"
      fi

      if [[ "$(id -u)" -eq 0 ]]; then
        sudo -u "$TARGET_USER" git -C "$SCRIPT_DIR" remote set-url origin "$SSH_URL"
      else
        git -C "$SCRIPT_DIR" remote set-url origin "$SSH_URL"
      fi
      echo "✓ Converted origin remote to SSH: $SSH_URL"
    elif [[ "$ORIGIN_URL" =~ ^git@github\.com: ]]; then
      echo "✓ Origin remote already uses SSH"
    else
      echo "⚠ Origin remote is not a GitHub HTTPS URL, leaving unchanged: $ORIGIN_URL"
    fi
  else
    echo "⚠ No origin remote found in $SCRIPT_DIR, skipping HTTPS->SSH conversion"
  fi
else
  echo "⚠ $SCRIPT_DIR is not a git repository, skipping HTTPS->SSH conversion"
fi

# Reload Hyprland so keyboard changes apply immediately
if command -v hyprctl >/dev/null 2>&1; then
  echo "Reloading Hyprland..."
  if [[ "$USER" == "$TARGET_USER" ]]; then
    if hyprctl reload >/dev/null 2>&1; then
      echo "✓ Hyprland reloaded"
    else
      echo "⚠ Could not auto-reload Hyprland. Run: hyprctl reload"
    fi
  else
    TARGET_UID="$(id -u "$TARGET_USER")"
    if sudo -u "$TARGET_USER" XDG_RUNTIME_DIR="/run/user/$TARGET_UID" hyprctl reload >/dev/null 2>&1; then
      echo "✓ Hyprland reloaded"
    else
      echo "⚠ Could not auto-reload Hyprland. Run as $TARGET_USER: hyprctl reload"
    fi
  fi
else
  echo "⚠ hyprctl not found, skipping Hyprland reload"
fi
