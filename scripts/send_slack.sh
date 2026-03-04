#!/bin/bash
# Usage: ./scripts/send_slack.sh "メッセージテキスト"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$PROJECT_DIR/config/secrets.env"

if [ -z "$SLACK_BOT_TOKEN" ] || [ -z "$SLACK_CHANNEL_ID" ]; then
  echo "ERROR: SLACK_BOT_TOKEN or SLACK_CHANNEL_ID is not set in config/secrets.env"
  exit 1
fi

MESSAGE="$1"
if [ -z "$MESSAGE" ]; then
  echo "ERROR: No message provided"
  exit 1
fi

# JSON-escape the message
MESSAGE_ESCAPED=$(echo "$MESSAGE" | python -c 'import sys,json; print(json.dumps(sys.stdin.read().strip()))')

RESPONSE=$(curl -s -X POST "https://slack.com/api/chat.postMessage" \
  -H "Authorization: Bearer $SLACK_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"channel\": \"$SLACK_CHANNEL_ID\",
    \"text\": $MESSAGE_ESCAPED
  }")

OK=$(echo "$RESPONSE" | python -c 'import sys,json; print(json.loads(sys.stdin.read()).get("ok", False))' 2>/dev/null)

if [ "$OK" = "True" ]; then
  echo "Slack送信成功"
else
  echo "Slack送信失敗: $RESPONSE"
  exit 1
fi
