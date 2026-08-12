#!/usr/bin/env python3

import sys
import subprocess
import webbrowser
from email import policy
from email.parser import BytesParser


def copy_to_clipboard(text: str):
    subprocess.run(
        ["wl-copy"],
        input=text,
        text=True,
        check=True,
    )


def main():
    if len(sys.argv) != 2 or sys.argv[1] not in {"open", "copy"}:
        print(f"Usage: {sys.argv[0]} <open|copy>", file=sys.stderr)
        sys.exit(2)

    mode = sys.argv[1]

    # Read raw email from stdin (bytes!)
    raw = sys.stdin.buffer.read()

    # Parse email
    msg = BytesParser(policy=policy.default).parsebytes(raw)

    # Extract Message-Id
    message_id = msg.get("Message-Id")
    if not message_id:
        print("No Message-Id header found", file=sys.stderr)
        sys.exit(1)

    # Normalize Message-Id
    message_id = message_id.strip()
    if message_id.startswith("<") and message_id.endswith(">"):
        message_id = message_id[1:-1]

    url = f"https://lore.proxmox.com/all/{message_id}/T/#u"

    if mode == "open":
        webbrowser.open(url)
    elif mode == "copy":
        try:
            copy_to_clipboard(url)
        except FileNotFoundError:
            print("wl-copy not found (install wl-clipboard)", file=sys.stderr)
            sys.exit(1)


if __name__ == "__main__":
    main()
