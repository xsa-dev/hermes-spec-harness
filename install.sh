#!/usr/bin/env sh
set -eu

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Install the Hermes Spec Harness skill directory.

Options:
  --skill-path PATH   Destination skill path (default: ~/.hermes/skills/hermes-spec-harness)
  --force             Replace an existing different destination directory
  --dry-run, -n       Print the plan without writing
  --verbose, -v       Print extra log lines
  --help, -h          Show this help
EOF
}

log_info() { printf '[info] %s\n' "$*"; }
log_plan() { printf '[plan] %s\n' "$*"; }
log_warn() { printf '[warn] %s\n' "$*"; }
log_done() { printf '[done] %s\n' "$*"; }
log_error() { printf '[error] %s\n' "$*" >&2; }
verbose() { if [ "$VERBOSE" = "true" ]; then log_info "$*"; fi; }

DRY_RUN=false
VERBOSE=false
FORCE=false
SKILL_PATH="${HOME}/.hermes/skills/hermes-spec-harness"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --skill-path)
      [ "$#" -gt 1 ] || { log_error "--skill-path requires PATH"; exit 2; }
      SKILL_PATH=$2
      shift 2
      ;;
    --force)
      FORCE=true
      shift
      ;;
    --dry-run|-n)
      DRY_RUN=true
      shift
      ;;
    --verbose|-v)
      VERBOSE=true
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      log_error "Unknown option: $1"
      usage >&2
      exit 2
      ;;
  esac
done

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SRC="$SCRIPT_DIR/skills/hermes-spec-harness"
DEST=$SKILL_PATH

[ -d "$SRC" ] || { log_error "Source skill directory not found: $SRC"; exit 1; }
[ -n "$DEST" ] || { log_error "Destination skill path is empty"; exit 1; }

verbose "Source: $SRC"
verbose "Destination: $DEST"

if [ -d "$DEST" ]; then
  if diff -qr "$SRC" "$DEST" >/dev/null 2>&1; then
    log_done "Skill already installed with identical content: $DEST"
    exit 0
  fi
  if [ "$FORCE" != "true" ]; then
    log_error "Destination exists and differs: $DEST"
    log_error "Use --force to replace only this exact skill directory."
    exit 1
  fi
  log_warn "Destination exists and will be replaced: $DEST"
fi

if [ "$DRY_RUN" = "true" ]; then
  log_plan "Install skill from $SRC to $DEST"
  if [ -d "$DEST" ] && [ "$FORCE" = "true" ]; then
    log_plan "Replace existing destination directory"
  fi
  exit 0
fi

DEST_PARENT=$(dirname -- "$DEST")
DEST_BASE=$(basename -- "$DEST")
TMP_DEST="$DEST_PARENT/.${DEST_BASE}.tmp.$$"

mkdir -p "$DEST_PARENT"
rm -rf "$TMP_DEST"
mkdir -p "$TMP_DEST"
cp -R "$SRC/." "$TMP_DEST/"

if [ -d "$DEST" ]; then
  rm -rf "$DEST"
fi

mv "$TMP_DEST" "$DEST"
log_done "Installed Hermes Spec Harness skill to $DEST"
