#!/usr/bin/env bash
# hephaiste.sh – native wrapper for local development

# ---- Standard Colors and Messages ----
GREEN="$(tput setaf 2)"
RED="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
RESET="$(tput sgr0)"

info()  { echo "${GREEN}[Info]${RESET} $*"; }
warn()  { echo "${YELLOW}[Warn]${RESET} $*"; }
fail()  { echo "${RED}[Fail]${RESET} $*"; }

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# -------------------------------------------------------------
# 1. If the global binary exists, use it
# -------------------------------------------------------------
if command -v hephaiste >/dev/null 2>&1; then
    info "Using globally linked hephaiste."
    exec hephaiste "$@"
fi

warn "Global hephaiste command not found."

# -------------------------------------------------------------
# 2. Try to create the link (npm link)
# -------------------------------------------------------------
info "Attempting: npm link (to expose global 'hephaiste')…"

if (cd "$SCRIPT_DIR" && npm link >/dev/null 2>&1); then
    info "npm link succeeded. Using globally linked hephaiste."
    exec hephaiste "$@"
else
    warn "npm link failed. Falling back to local index.js."
fi

# -------------------------------------------------------------
# 3. Fallback local execution (development mode)
# -------------------------------------------------------------
info "Using local node runner: $SCRIPT_DIR/index.js"
exec node "$SCRIPT_DIR/index.js" "$@"
