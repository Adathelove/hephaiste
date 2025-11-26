#!/usr/bin/env bash

# ---- Standard Colors and Messages ----
GREEN="$(tput setaf 2)"
RED="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
RESET="$(tput sgr0)"

info()  { echo "${GREEN}[Info]${RESET} $*"; }
warn()  { echo "${YELLOW}[Warn]${RESET} $*"; }
fail()  { echo "${RED}[Fail]${RESET} $*"; }
abort() { echo "${RED}[Abort]${RESET} $*"; }

# -------------------------------------------------------------
# The script assumes it is sourced from INSIDE the repo directory.
# -------------------------------------------------------------

HEPHAISTE_ROOT="$(pwd)"

info "Activating Hephaiste development environment in: $HEPHAISTE_ROOT"

# Tool paths (relative to repo)
NATIVE="$HEPHAISTE_ROOT/hephaiste.sh"
DOCKER="$HEPHAISTE_ROOT/hephaiste_docker.sh"
COMP_DIR="$HEPHAISTE_ROOT/completions"

# -------------------------------------------------------------
# Ensure docker wrapper exists
# -------------------------------------------------------------
if [[ ! -f "$DOCKER" ]]; then
    warn "Docker wrapper not found: $DOCKER"
else
    info "Found docker wrapper."
fi

# -------------------------------------------------------------
# Create native wrapper if missing
# -------------------------------------------------------------
if [[ ! -f "$NATIVE" ]]; then
    warn "Native wrapper missing; creating hephaiste.sh…"

    cat > "$NATIVE" <<'EOF'
#!/usr/bin/env bash
# hephaiste.sh – native wrapper for local development

if command -v hephaiste >/dev/null 2>&1; then
    hephaiste "$@"
else
    SCRIPT_DIR="$(dirname "$0")"
    node "$SCRIPT_DIR/index.js" "$@"
fi
EOF

    chmod +x "$NATIVE"
    info "Created native wrapper: hephaiste.sh"
else
    info "Native wrapper already present."
fi

# -------------------------------------------------------------
# Add repo root to PATH (only if missing)
# -------------------------------------------------------------
case ":$PATH:" in
    *":$HEPHAISTE_ROOT:"*)
        info "PATH already contains repo root."
        ;;
    *)
        export PATH="$HEPHAISTE_ROOT:$PATH"
        info "Added repo root to PATH."
        ;;
esac

# -------------------------------------------------------------
# Load completions
# -------------------------------------------------------------
if [[ -f "$COMP_DIR/hephaiste-completion.bash" ]]; then
    source "$COMP_DIR/hephaiste-completion.bash"
    info "Loaded: hephaiste-completion.bash"
else
    warn "Missing: hephaiste-completion.bash"
fi

if [[ -f "$COMP_DIR/hephaiste-docker-completion.bash" ]]; then
    source "$COMP_DIR/hephaiste-docker-completion.bash"
    info "Loaded: hephaiste-docker-completion.bash"
else
    warn "Missing: hephaiste-docker-completion.bash"
fi

info "Hephaiste environment active."

