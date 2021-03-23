#!/bin/bash
tmate -S /tmp/tmate.sock new-session -d               # Launch tmate in a headless mode
tmate -S /tmp/tmate.sock wait tmate-ready             # Blocks until the SSH connection is established
tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}'    # Prints the SSH connection string
tmate -S /tmp/tmate.sock display -p '#{tmate_ssh_ro}' # Prints the read-only SSH connection string
tmate -S /tmp/tmate.sock display -p '#{tmate_web}'    # Prints the web connection string
tmate -S /tmp/tmate.sock display -p '#{tmate_web_ro}' # Prints the read-only web connection string
