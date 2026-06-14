#!/usr/bin/env sh
set -eu

usage() {
  cat <<'EOF'
Usage: ./uninstall.sh [options]

Remove the installed Hermes Spec Harness skill directory.

Options:
  --skill-path PATH   Installed skill path (default: ~/.hermes/skills/hermes-spec-harness)
  --dry-run, -n       Print the plan without removing
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
SKILL_PATH="${HOME}/.hermes/skills/hermes-spec-harness"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --skill-path)
      [ "$#" -gt 1 ] || { log_error "--skill-path requires PATH"; exit 2; }
      SKILL_PATH=$2
      shift 2
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

DEST=$SKILL_PATH

case "$DEST" in
  ""|"/"|"/."|"."|".."|"~")
    log_error "Refusing suspicious skill path: $DEST"
    exit 1
    ;;
esac

case "$DEST" in
  */hermes-spec-harness) ;;
  *)
    log_error "Refusing to remove a path that does not end with hermes-spec-harness: $DEST"
    exit 1
    ;;
esac

verbose "Destination: $DEST"

if [ ! -e "$DEST" ]; then
  log_done "Skill is already absent: $DEST"
  exit 0
fi

if [ ! -d "$DEST" ]; then
  log_error "Destination exists but is not a directory: $DEST"
  exit 1
fi

if [ "$DRY_RUN" = "true" ]; then
  log_plan "Remove exact skill directory: $DEST"
  exit 0
fi

rm -rf "$DEST"
log_done "Removed Hermes Spec Harness skill directory: $DEST"
