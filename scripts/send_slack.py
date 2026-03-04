"""Slack にメッセージを送信するスクリプト.

Usage: python scripts/send_slack.py "メッセージテキスト"
"""

import json
import os
import sys
import urllib.request

def load_secrets():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    env_path = os.path.join(script_dir, "..", "config", "secrets.env")
    with open(env_path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                key, value = line.split("=", 1)
                os.environ[key.strip()] = value.strip()

def send_slack(message: str) -> None:
    token = os.environ.get("SLACK_BOT_TOKEN", "")
    channel = os.environ.get("SLACK_CHANNEL_ID", "")
    if not token or not channel:
        print("ERROR: SLACK_BOT_TOKEN or SLACK_CHANNEL_ID is not set")
        sys.exit(1)

    payload = json.dumps({"channel": channel, "text": message}).encode("utf-8")
    req = urllib.request.Request(
        "https://slack.com/api/chat.postMessage",
        data=payload,
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json; charset=utf-8",
        },
    )
    with urllib.request.urlopen(req) as resp:
        result = json.loads(resp.read().decode("utf-8"))

    if result.get("ok"):
        print("Slack送信成功")
    else:
        print(f"Slack送信失敗: {result.get('error')}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("ERROR: No message provided")
        sys.exit(1)
    load_secrets()
    send_slack(sys.argv[1])
