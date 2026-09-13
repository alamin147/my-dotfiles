#!/usr/bin/env bash

# ─────────────────────────────────────────────────────────────────────────────
# Tak0-Autodispatch.sh
# ─────────────────────────────────────────────────────────────────────────────
# This script is an "authoritative spawn dispatcher" for Hyprland.
#
# Its purpose is to FORCE all windows belonging to a single application launch
# (main window + helpers + Electron / Steam child processes)
# onto a specific workspace.
#
# It explicitly ignores:
#   • spawn race conditions
#   • delayed window creation
#   • detached helper processes
#   • Electron / Chromium / Steam madness
#
# Typical use cases:
#   • Launch Steam / Discord / browsers without window leakage
#   • Prevent apps from spawning on the currently focused workspace
#   • Control applications that completely ignore static windowrules
#
# Invocation:
#   ./Tak0-Autodispatch.sh <workspace> [rule ...] -- <command>
#
# Important notes:
#   • All window rules are TEMPORARY
#   • No permanent pollution of Hyprland configuration
# ─────────────────────────────────────────────────────────────────────────────
# REQUIREMENTS:
#   - hyprctl   → runtime control of Hyprland
#   - jq        → JSON client parsing
#   - pgrep/ps  → process tree inspection

set -u

LOGFILE="$(dirname "$0")/dispatch.log"
RULE_NAMESPACE="tak0-$$"

lua_quote() {
  jq -Rn --arg value "$1" '$value'
}

disable_capture_rules() {
  local namespace
  namespace=$(lua_quote "$RULE_NAMESPACE")
  hyprctl eval "
    local entry = __tak0_rules and __tak0_rules[$namespace]
    if entry then
      if entry.wide then entry.wide:set_enabled(false) end
      for _, rule in ipairs(entry.specific or {}) do rule:set_enabled(false) end
      __tak0_rules[$namespace] = nil
    end
  " >>"$LOGFILE" 2>&1 || true
}

# ─────────────────────────────────────────────────────────────────────────────
# 0️⃣ ARGUMENT PARSING
# ─────────────────────────────────────────────────────────────────────────────
#   $1            → target workspace
#   Next args     → optional capture rules (windowrulev2 syntax)
#   "--"          → argument separator
#   After "--"    → command to execute (verbatim)

TARGET_WS="$1"
shift || true

CAPTURE_RULES=()
while [[ "${1-}" != "--" && -n "${1-}" ]]; do
  CAPTURE_RULES+=("$1")
  shift || break
done

if [[ "${1-}" == "--" ]]; then
  shift
fi

CMD="$*"

if [[ -z "$TARGET_WS" || -z "$CMD" ]]; then
  echo "Usage: $0 <workspace> [rule rule ...] -- <command>" >>"$LOGFILE"
  exit 1
fi

echo "=== Deploy '$CMD' → WS $TARGET_WS @ $(date) ===" >>"$LOGFILE"

# ─────────────────────────────────────────────────────────────────────────────
# 1️⃣ HYPRLAND READINESS GATE
# ─────────────────────────────────────────────────────────────────────────────
#   Hyprland may not be fully initialized during early autostart.
#   hyprctl silently fails if called too early.

for _ in {1..50}; do
  hyprctl -j monitors >/dev/null 2>&1 && break
  sleep 0.1
done

# ─────────────────────────────────────────────────────────────────────────────
# 2️⃣ CLEANUP GUARANTEE
# ─────────────────────────────────────────────────────────────────────────────
#   Ensures that ALL temporary rules are removed
#   even on crash, SIGTERM, or user interruption.

cleanup() {
  echo "Cleanup: removing temporary capture rules and initialWorkspace at $(date)" >>"$LOGFILE"
  disable_capture_rules
}

trap cleanup EXIT INT TERM ERR

# ─────────────────────────────────────────────────────────────────────────────
# 3️⃣ ULTRA-EARLY GLOBAL CAPTURE (NUCLEAR OPTION)
# ─────────────────────────────────────────────────────────────────────────────
#   Temporarily forces ALL windows (initialClass:.*)
#   onto the target workspace.
#
#   Protects against ultra-fast helpers:
#     • gpu-process
#     • renderer
#     • steamwebhelper

echo "Applying temporary initialWorkspace capture (initialClass:.*)" >>"$LOGFILE"
namespace=$(lua_quote "$RULE_NAMESPACE")
wide_rule_name=$(lua_quote "$RULE_NAMESPACE-wide")
target_rule_workspace=$(lua_quote "$TARGET_WS silent")
hyprctl eval "
  __tak0_rules = __tak0_rules or {}
  __tak0_rules[$namespace] = {
    wide = hl.window_rule({
      name = $wide_rule_name,
      match = { initial_class = \".*\" },
      workspace = $target_rule_workspace,
    }),
    specific = {},
  }
" >>"$LOGFILE" 2>&1 || true

# ─────────────────────────────────────────────────────────────────────────────
# 3️⃣.1 OPTIONAL CLASS-BASED PRE-CAPTURE
# ─────────────────────────────────────────────────────────────────────────────
#   Additional precision rules.
#   Useful for Electron / Steam multi-process hell.

rule_index=0
for RULE in "${CAPTURE_RULES[@]}"; do
  echo "Applying temporary capture rule: $RULE" >>"$LOGFILE"
  rule_index=$((rule_index + 1))
  rule_field=${RULE%%:*}
  rule_pattern=${RULE#*:}

  case "$rule_field" in
    class)        lua_field="class" ;;
    initialClass) lua_field="initial_class" ;;
    title)        lua_field="title" ;;
    initialTitle) lua_field="initial_title" ;;
    *)
      echo "Skipping unsupported capture selector: $RULE" >>"$LOGFILE"
      continue
      ;;
  esac

  rule_name=$(lua_quote "$RULE_NAMESPACE-$rule_index")
  pattern=$(lua_quote "$rule_pattern")
  hyprctl eval "
    local entry = __tak0_rules and __tak0_rules[$namespace]
    if entry then
      table.insert(entry.specific, hl.window_rule({
        name = $rule_name,
        match = { $lua_field = $pattern },
        workspace = $target_rule_workspace,
      }))
    end
  " >>"$LOGFILE" 2>&1 || true
done

# ─────────────────────────────────────────────────────────────────────────────
# 4️⃣ APPLICATION LAUNCH
# ─────────────────────────────────────────────────────────────────────────────
#   bash -c allows aliases, env vars, wrappers.
#   ROOT_PID is the root of process lineage.

bash -c "$CMD" &
ROOT_PID=$!
echo "Root PID: $ROOT_PID" >>"$LOGFILE"

# Resolve canonical process name
APP_NAME=""
for _ in {1..20}; do
  if [[ -r "/proc/$ROOT_PID/comm" ]]; then
    APP_NAME="$(tr -d '\0' </proc/$ROOT_PID/comm 2>/dev/null || true)"
    break
  fi
  sleep 0.05
done

if [[ -z "$APP_NAME" ]]; then
  read -r -a __toks <<<"$CMD"
  APP_NAME="$(basename "${__toks[0]}")"
fi

echo "App gate name: $APP_NAME" >>"$LOGFILE"

sleep 1.5

#!TO-DO: Release the nuclear option ASAP
echo "Releasing ultra-early wide capture" >>"$LOGFILE"
hyprctl eval "
  local entry = __tak0_rules and __tak0_rules[$namespace]
  if entry and entry.wide then
    entry.wide:set_enabled(false)
    entry.wide = nil
  end
" >>"$LOGFILE" 2>&1 || true

# ─────────────────────────────────────────────────────────────────────────────
# 5️⃣ SUPERVISION LOOP (AUTHORITATIVE PHASE)
# ─────────────────────────────────────────────────────────────────────────────
#   This loop:
#     • scans ALL Hyprland clients
#     • matches PID lineage
#     • matches detached helpers
#     • matches class rules

get_descendants() {
  local root="$1"
  local all=("$root")
  local changed=1

  while ((changed)); do
    changed=0
    for p in "${all[@]}"; do
      for c in $(pgrep -P "$p" 2>/dev/null || true); do
        if [[ ! " ${all[*]} " =~ " $c " ]]; then
          all+=("$c")
          changed=1
        fi
      done
    done
  done

  echo "${all[@]}"
}

pid_matches_app() {
  local pid="$1"
  local comm
  comm="$(ps -p "$pid" -o comm= 2>/dev/null)" || return 1
  [[ "$comm" == "$APP_NAME" || "$comm" == "$APP_NAME"* ]]
}

END_TIME=$((SECONDS + 20))
declare -A SEEN

while ((SECONDS < END_TIME)); do
  PIDS="$(get_descendants "$ROOT_PID")"

  while IFS=$'\t' read -r PID ADDR CLASS; do
    MATCH=0

    for TPID in $PIDS; do
      [[ "$PID" == "$TPID" ]] && MATCH=1 && break
    done

    pid_matches_app "$PID" && MATCH=1

    for RULE in "${CAPTURE_RULES[@]}"; do
      if [[ "$RULE" =~ class:\^\((.*)\)\$ ]]; then
        [[ "$CLASS" =~ ${BASH_REMATCH[1]} ]] && MATCH=1
      fi
    done

    if ((MATCH)) && [[ -z "${SEEN[$ADDR]-}" ]]; then
      echo "Placing window $ADDR (pid $PID, class $CLASS) → WS $TARGET_WS" >>"$LOGFILE"
      target_workspace=$(lua_quote "$TARGET_WS")
      target_window=$(lua_quote "address:$ADDR")
      hyprctl eval "hl.dispatch(hl.dsp.window.move({
        workspace = $target_workspace,
        follow = false,
        window = $target_window,
      }))" >>"$LOGFILE" 2>&1 || true
      SEEN[$ADDR]=1
    fi
  done < <(hyprctl clients -j | jq -r '.[] | [.pid, .address, .class] | @tsv')

  sleep 0.01
done

echo "=== Deploy finished: '$CMD' ===" >>"$LOGFILE"
exit 0
