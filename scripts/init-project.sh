#!/usr/bin/env sh
set -eu

usage() {
  cat <<'EOF'
Usage: ./scripts/init-project.sh [PROJECT_PATH] [options]

Bootstrap a project with OpenSpec and Hermes Spec Harness rules.

Options:
  --default-schema NAME     Default OpenSpec schema (default: hsh-fix)
  --overwrite-agents        Replace existing AGENTS.md
  --force                   Replace existing schema dirs and schema config line
  --git-required true|false Require target to be a git repo (default: true)
  --openspec-bin CMD        OpenSpec command (default: npx --yes @fission-ai/openspec@latest)
  --allow-external-write    Allow target outside current working directory
  --dry-run, -n             Print the plan without writing
  --verbose, -v             Print extra log lines
  --help, -h                Show this help
EOF
}

log_info() { printf '[info] %s\n' "$*"; }
log_plan() { printf '[plan] %s\n' "$*"; }
log_warn() { printf '[warn] %s\n' "$*"; }
log_done() { printf '[done] %s\n' "$*"; }
log_error() { printf '[error] %s\n' "$*" >&2; }
verbose() { if [ "$VERBOSE" = "true" ]; then log_info "$*"; fi; }

DEFAULT_SCHEMA=hsh-fix
OVERWRITE_AGENTS=false
FORCE=false
GIT_REQUIRED=true
OPENSPEC_BIN='npx --yes @fission-ai/openspec@latest'
ALLOW_EXTERNAL_WRITE=false
DRY_RUN=false
VERBOSE=false
PROJECT_PATH=.
PROJECT_SET=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --default-schema)
      [ "$#" -gt 1 ] || { log_error "--default-schema requires NAME"; exit 2; }
      DEFAULT_SCHEMA=$2
      shift 2
      ;;
    --overwrite-agents)
      OVERWRITE_AGENTS=true
      shift
      ;;
    --force)
      FORCE=true
      shift
      ;;
    --git-required)
      [ "$#" -gt 1 ] || { log_error "--git-required requires true or false"; exit 2; }
      case "$2" in true|false) GIT_REQUIRED=$2 ;; *) log_error "--git-required must be true or false"; exit 2 ;; esac
      shift 2
      ;;
    --openspec-bin)
      [ "$#" -gt 1 ] || { log_error "--openspec-bin requires CMD"; exit 2; }
      OPENSPEC_BIN=$2
      shift 2
      ;;
    --allow-external-write)
      ALLOW_EXTERNAL_WRITE=true
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
    --*)
      log_error "Unknown option: $1"
      usage >&2
      exit 2
      ;;
    *)
      if [ "$PROJECT_SET" = "true" ]; then
        log_error "Only one PROJECT_PATH positional argument is supported"
        exit 2
      fi
      PROJECT_PATH=$1
      PROJECT_SET=true
      shift
      ;;
  esac
done

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)

if [ ! -d "$PROJECT_PATH" ]; then
  log_error "Target project path must already exist: $PROJECT_PATH"
  exit 1
fi

TARGET=$(CDPATH= cd -- "$PROJECT_PATH" && pwd)
CALLER_CWD=$(pwd)

case "$TARGET" in
  "$CALLER_CWD"|"$CALLER_CWD"/*) ;;
  *)
    if [ "$ALLOW_EXTERNAL_WRITE" != "true" ]; then
      log_error "Refusing to modify target outside current working directory: $TARGET"
      log_error "Run from a parent directory or pass --allow-external-write."
      exit 1
    fi
    ;;
esac

verbose "Repo root: $REPO_ROOT"
verbose "Target: $TARGET"
verbose "Default schema: $DEFAULT_SCHEMA"

if [ "$GIT_REQUIRED" = "true" ]; then
  if ! git -C "$TARGET" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    log_error "Target is not a git repository: $TARGET"
    exit 1
  fi
fi

[ -d "$REPO_ROOT/openspec-schemas" ] || { log_error "Missing schema source: $REPO_ROOT/openspec-schemas"; exit 1; }
[ -f "$REPO_ROOT/templates/AGENTS.md" ] || { log_error "Missing AGENTS template"; exit 1; }

if [ -f "$TARGET/.hermes.md" ]; then
  log_warn ".hermes.md exists and may have higher priority than AGENTS.md; review it."
fi
if [ -f "$TARGET/HERMES.md" ]; then
  log_warn "HERMES.md exists and may have higher priority than AGENTS.md; review it."
fi
if [ -f "$TARGET/AGENTS.md" ]; then
  log_warn "AGENTS.md already exists and will be preserved unless overwrite is enabled."
fi
if [ -d "$TARGET/openspec" ]; then
  log_warn "openspec/ already exists; bootstrap will preserve existing config by default."
fi

CONFIG_WAS_MISSING=false
if [ ! -f "$TARGET/openspec/config.yaml" ]; then
  CONFIG_WAS_MISSING=true
fi

if [ ! -d "$TARGET/openspec" ]; then
  if [ "$DRY_RUN" = "true" ]; then
    log_plan "Run OpenSpec init: $OPENSPEC_BIN init \"$TARGET\" --tools none --profile core"
  else
    log_info "Running OpenSpec init with tools=none"
    sh -c "$OPENSPEC_BIN init \"\$1\" --tools none --profile core" sh "$TARGET"
  fi
fi

SCHEMAS_DEST="$TARGET/openspec/schemas"
if [ "$DRY_RUN" = "true" ]; then
  log_plan "Ensure directory exists: $SCHEMAS_DEST"
else
  mkdir -p "$SCHEMAS_DEST"
fi

for src in "$REPO_ROOT"/openspec-schemas/*; do
  [ -d "$src" ] || continue
  name=$(basename -- "$src")
  dest="$SCHEMAS_DEST/$name"
  if [ -d "$dest" ]; then
    if diff -qr "$src" "$dest" >/dev/null 2>&1; then
      verbose "Schema already identical: $name"
      continue
    fi
    if [ "$FORCE" != "true" ]; then
      log_warn "Schema exists and differs; skipping without --force: $dest"
      continue
    fi
    if [ "$DRY_RUN" = "true" ]; then
      log_plan "Replace schema directory: $dest"
    else
      rm -rf "$dest"
      cp -R "$src" "$dest"
      log_done "Replaced schema: $name"
    fi
  else
    if [ "$DRY_RUN" = "true" ]; then
      log_plan "Copy schema $name to $dest"
    else
      cp -R "$src" "$dest"
      log_done "Copied schema: $name"
    fi
  fi
done

CONFIG="$TARGET/openspec/config.yaml"
if [ ! -f "$CONFIG" ]; then
  if [ "$DRY_RUN" = "true" ]; then
    log_plan "Create $CONFIG with schema: $DEFAULT_SCHEMA"
  else
    mkdir -p "$(dirname -- "$CONFIG")"
    printf 'schema: %s\n' "$DEFAULT_SCHEMA" > "$CONFIG"
    log_done "Created OpenSpec config with schema: $DEFAULT_SCHEMA"
  fi
else
  if grep -q '^[[:space:]]*schema:' "$CONFIG"; then
    if [ "$FORCE" = "true" ]; then
      if [ "$DRY_RUN" = "true" ]; then
        log_plan "Replace existing schema line in $CONFIG with $DEFAULT_SCHEMA"
      else
        tmp="$CONFIG.tmp.$$"
        awk -v schema="$DEFAULT_SCHEMA" '
          /^[[:space:]]*schema:/ && done == 0 { print "schema: " schema; done = 1; next }
          { print }
        ' "$CONFIG" > "$tmp"
        mv "$tmp" "$CONFIG"
        log_done "Updated OpenSpec default schema: $DEFAULT_SCHEMA"
      fi
    else
      log_warn "Existing schema line preserved in $CONFIG; use --force to replace it."
    fi
  else
    if [ "$DRY_RUN" = "true" ]; then
      log_plan "Append schema: $DEFAULT_SCHEMA to $CONFIG"
    else
      {
        printf '\n'
        printf 'schema: %s\n' "$DEFAULT_SCHEMA"
      } >> "$CONFIG"
      log_done "Appended OpenSpec default schema: $DEFAULT_SCHEMA"
    fi
  fi
fi

AGENTS="$TARGET/AGENTS.md"
if [ -f "$AGENTS" ]; then
  if [ "$OVERWRITE_AGENTS" = "true" ] || [ "$FORCE" = "true" ]; then
    if [ "$DRY_RUN" = "true" ]; then
      log_plan "Overwrite AGENTS.md from template"
    else
      cp "$REPO_ROOT/templates/AGENTS.md" "$AGENTS"
      log_done "Overwrote AGENTS.md from template"
    fi
  else
    log_warn "Existing AGENTS.md preserved."
  fi
else
  if [ "$DRY_RUN" = "true" ]; then
    log_plan "Create AGENTS.md from template"
  else
    cp "$REPO_ROOT/templates/AGENTS.md" "$AGENTS"
    log_done "Created AGENTS.md from template"
  fi
fi

if [ "$CONFIG_WAS_MISSING" = "true" ]; then
  verbose "OpenSpec config was missing before bootstrap and is now ensured."
fi

log_done "Hermes Spec Harness bootstrap completed for $TARGET"
printf '%s\n' 'Use Hermes Spec Harness. Create an audit-only OpenSpec change baseline-project-audit. Stop after artifacts.'
