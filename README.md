# get-ai-news

毎日のAI関連ニュースを自動取得し、Markdownファイルとして保存・Slackに通知するツール。

[Claude Code](https://docs.anthropic.com/en/docs/claude-code)のスキル機能とWebSearch機能を活用して、日英両言語のソースからAIニュースを収集・整形する。

## 機能

- AI関連ニュースを毎日10件取得（日本語・英語ソース）
- 過去7日分との重複チェックによる新鮮なニュースの選定
- Markdownファイルとして月別フォルダに自動保存
- Slack通知による日次配信
- Windowsタスクスケジューラによる毎日08:00の自動実行

## プロジェクト構成

```
get-ai-news/
├── .claude/
│   └── skills/get-ai-news/
│       └── SKILL.md             # Claude Codeスキル定義
├── config/
│   └── secrets.env              # Slack認証情報（git管理外）
├── logs/
│   └── scheduler.log            # 自動実行ログ（git管理外）
├── news/                        # 取得したニュースファイル
│   └── YYYY-MM/
│       └── YYYY-MM-DD-ai-news.md
├── scripts/
│   ├── run_get_ai_news.bat      # タスクスケジューラ用バッチ
│   └── send_slack.py            # Slack送信スクリプト
├── CLAUDE.md                    # Claude Code用プロジェクト設定
└── README.md
```

## 必要な環境

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)（CLI）
- Python 3（標準ライブラリのみ使用）
- Windows（タスクスケジューラによる自動実行を利用する場合）

## セットアップ

### 1. Slack Appの作成

1. [Slack API](https://api.slack.com/apps) でAppを作成
2. OAuth & Permissions で `chat:write` スコープを追加
3. Appをワークスペースにインストール
4. Bot User OAuth Token（`xoxb-...`）を取得
5. 通知先チャンネルにBotを招待

### 2. 認証情報の設定

`config/secrets.env` を作成し、以下を記載:

```env
SLACK_BOT_TOKEN=xoxb-your-bot-token
SLACK_CHANNEL_ID=C0123456789
```

### 3. 自動実行の設定（任意）

Windowsタスクスケジューラで以下を設定:

| 項目 | 値 |
|------|------|
| プログラム | `scripts\run_get_ai_news.bat` |
| トリガー | 毎日 08:00 |
| 開始ディレクトリ | プロジェクトルートの絶対パス |

## 使い方

### 手動実行

Claude Codeで以下のスキルコマンドを実行:

```
/get-ai-news
```

## ニュースファイルのフォーマット

取得したニュースは `news/YYYY-MM/YYYY-MM-DD-ai-news.md` に以下の形式で保存される:

```markdown
# AIニュース - YYYY-MM-DD

## 1. [ニュースタイトル]
- **概要**: 200〜250字程度の詳しい説明
- **企業/組織**: 関連する企業名
- **ソース**: [リンクテキスト](URL)

## 2. [ニュースタイトル]
...（計10件）

---
*取得日時: YYYY-MM-DD*
*検索クエリ: 使用したクエリ一覧*
```

## 技術スタック

| 技術 | 用途 |
|------|------|
| Claude Code | ニュース検索（WebSearch）・整形・ファイル保存 |
| Slack API (`chat.postMessage`) | ニュース通知の送信 |
| Python | Slack送信スクリプト（標準ライブラリのみ） |
| Windows タスクスケジューラ | 定期実行 |

## 仕組み

1. Claude CodeのWebSearch機能で日英5種類の検索クエリを並列実行
2. 検索結果から当日のAIニュースを10件抽出（過去情報は除外）
3. 過去7日分のニュースファイルを読み込み、重複トピックを排除
4. Markdownファイルとして月別フォルダに保存
5. `scripts/send_slack.py` 経由でSlackチャンネルに通知
