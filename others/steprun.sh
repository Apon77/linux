#!/usr/bin/env bash
[[ -z "$1" ]] && echo "Usage: $0 <script>" && exit 1

# Safely buffer the target script into memory array up front
mapfile -t lines < "$1"

first=1 buf=""
for line in "${lines[@]}"; do
  [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

  buf+="${buf:+$'\n'}$line"

  # Native bash engine syntax validation check
  # Keeps buffering if the syntax is incomplete (handles functions, loops, if blocks)
  ! bash -n <<< "$buf" 2>/dev/null && continue

  [[ $first -eq 1 ]] && first=0 || echo ""
  echo -e "\033[1;34m$buf\033[0m"
  read -p "[Y/n/q]: " -r reply < /dev/tty
  
  case "${reply//$'\r'/}" in
    [qQ]) echo "Aborted"; exit 0 ;;
    [nN]) echo "Skipped" ;;
    *)    eval "$buf" ;;
  esac
  buf=""
done

