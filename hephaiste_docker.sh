#!/usr/bin/env bash
# hephaiste_docker.sh – docker-mode wrapper for Hephaiste CLI

# ---- Standard Colors and Messages ----
GREEN="$(tput setaf 2)"
RED="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
RESET="$(tput sgr0)"

info()  { echo "${GREEN}[Info]${RESET} $*"; }
warn()  { echo "${YELLOW}[Warn]${RESET} $*"; }
fail()  { echo "${RED}[Fail]${RESET} $*"; }

IMAGE="hephaiste-cli"
CONTAINER_MOUNT="/workspace"

# -------------------------------------------------------------
# 1. Extract top-level command (first non-option argument)
# -------------------------------------------------------------
CMD=""
for arg in "$@"; do
    if [[ "$arg" == -* ]]; then
        continue
    fi
    CMD="$arg"
    break
done

# Commands that REQUIRE a persona directory
REQUIRES_DIR=("inspect" "list" "persona" "persona-debug")

needs_persona="no"
for c in "${REQUIRES_DIR[@]}"; do
    if [[ "$CMD" == "$c" ]]; then
        needs_persona="yes"
        break
    fi
done

# -------------------------------------------------------------
# 2. Parse arguments and extract --persona-dir only if present
# -------------------------------------------------------------
HOST_PATH=""
ARGS=()
expect_path="no"

for arg in "$@"; do
    if [[ "$expect_path" == "yes" ]]; then
        HOST_PATH="$arg"
        expect_path="no"
        continue
    fi

    if [[ "$arg" == "--persona-dir" ]]; then
        expect_path="yes"
        continue
    fi

    ARGS+=("$arg")
done

# -------------------------------------------------------------
# 3. If command requires persona-dir → enforce it
# -------------------------------------------------------------
if [[ "$needs_persona" == "yes" ]]; then
    if [[ -z "$HOST_PATH" ]]; then
        fail "Command '$CMD' requires --persona-dir <path>."
        exit 1
    fi
else
    # Command does NOT require persona-dir → run normally
    if [[ -z "$HOST_PATH" ]]; then
        exec docker run --rm "$IMAGE" "$@"
    fi
fi

# -------------------------------------------------------------
# 4. Normalize path if provided
# -------------------------------------------------------------
HOST_PATH_ABS="$(cd "$(dirname "$HOST_PATH")" && pwd)/$(basename "$HOST_PATH")"

if [[ ! -d "$HOST_PATH_ABS" ]]; then
    fail "Persona directory does not exist: $HOST_PATH_ABS"
    exit 1
fi

info "Persona directory (host): $HOST_PATH_ABS"

# -------------------------------------------------------------
# 5. Ensure Docker daemon is running (unchanged)
# -------------------------------------------------------------
docker info >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    warn "Docker daemon is not running."
    read -r -p "Start Docker? [y/N]: " reply
    reply="${reply,,}"

    if [[ "$reply" == "y" || "$reply" == "yes" ]]; then
        info "Starting Docker Desktop…"
        open -a Docker
        info "Waiting for Docker…"
        tries=0
        until docker info >/dev/null 2>&1; do
            sleep 1
            ((tries++))
            if (( tries > 40 )); then
                fail "Docker did not start in time."
                exit 1
            fi
        done
        info "Docker is ready."
    else
        fail "Docker is required for this command."
        exit 1
    fi
fi

# -------------------------------------------------------------
# 6. Run tool with mapping if persona-dir was provided
# -------------------------------------------------------------
exec docker run --rm \
    -v "$HOST_PATH_ABS:$CONTAINER_MOUNT" \
    "$IMAGE" \
    "${ARGS[@]}" \
    --persona-dir "$CONTAINER_MOUNT"
