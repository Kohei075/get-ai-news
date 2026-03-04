# get-ai-news

毎日のAI関連ニュースを自動取得し、Markdownファイルとして保存・Slackに通知するツール。

## プロジェクト構成

```
get-ai-news/
├── .claude/skills/get-ai-news/  # Claude Codeスキル定義
│   └── SKILL.md
├── config/
│   └── secrets.env              # Slack認証情報（git管理外）
├── logs/
│   └── scheduler.log            # 自動実行ログ（git管理外）
├── news/                        # 取得したニュースファイル
│   └── YYYY-MM-DD-ai-news.md
├── scripts/
│   ├── run_get_ai_news.bat      # タスクスケジューラ用バッチ
│   ├── send_slack.py            # Slack送信スクリプト
│   └── send_slack.sh            # Slack送信スクリプト（非推奨・文字化け問題あり）
└── CLAUDE.md
```

## 使い方

### 手動実行

Claude Code上で `/get-ai-news` を実行する。

### 自動実行

Windowsタスクスケジューラで `scripts/run_get_ai_news.bat` を毎日08:00に実行。

## セットアップ

### Slack設定

`config/secrets.env` に以下を設定:

```
SLACK_BOT_TOKEN=xoxb-...
SLACK_CHANNEL_ID=C...
```

Bot には `chat:write` スコープが必要。通知先チャンネルにBotを招待すること。

### タスクスケジューラ

- プログラム: `scripts\run_get_ai_news.bat`
- トリガー: 毎日 08:00
- 開始ディレクトリ: プロジェクトルート

## 技術スタック

- **Claude Code**: ニュース検索・整形・ファイル保存
- **Slack API** (`chat.postMessage`): 通知送信
- **Python**: Slack送信スクリプト（標準ライブラリのみ）
- **Windows タスクスケジューラ**: 定期実行
