#!/usr/bin/env bash
[[ -z "$1" ]] && echo "Usage: $0 <script>" && exit 1

first=1 buf=""

while IFS= read -r line <&3 || [[ -n "$line" ]]; do
  [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

  buf+="${buf:+$'\n'}$line"

  # Uses a fast built-in parser check instead of regex or heavy subprocesses
  if ! bash -n <(echo "$buf") 2>/dev/null; then
    # If the error is an unfinished block, keep buffering lines
    if bash -n <(echo "$buf") 2>&1 | grep -Eq 'unexpected end of file|unexpected token `fi|syntax error:'; then
      [[ "$buf" =~ (if|for|while|case) && ! "$buf" =~ (fi|done|esac) ]] && continue
    fi
  fi

  [[ $first -eq 1 ]] && first=0 || echo ""
  echo -e "\033[1;34m$buf\033[0m"
  read -p "[Y/n/q]: " -r reply < /dev/tty
  
  case "${reply//$'\r'/}" in
    [qQ]) echo "Aborted"; exit 0 ;;
    [nN]) echo "Skipped" ;;
    *)    eval "$buf" ;;
  esac
  buf=""
done 3< "$1"

