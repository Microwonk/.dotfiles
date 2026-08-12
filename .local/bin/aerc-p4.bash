#!/bin/bash

set -euo pipefail

MESSAGEID=$(rg -i 'Message-Id:\s*<(?P<id>.*)>' -r '$id')
WSNAME=${1:?"please specify a workspace name"}

proxmox-b4 apply "$WSNAME" "notmuch:id:$MESSAGEID"
cd ~/Dev/worktrees/$WSNAME
