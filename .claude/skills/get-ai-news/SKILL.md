---
name: get-ai-news
description: AI関連ニュース（特に新モデルリリース）をWebSearchで取得し、news/ディレクトリに保存する
allowed-tools: WebSearch, Write, Read, Glob
user-invocable: true
disable-model-invocation: true
---

# AI ニュース取得スキル

X(Twitter)やWeb上で話題のAI関連ニュース（特に新しいAIモデルリリース）を検索・取得し、Markdownファイルとして保存する。

## 手順

1. 今日の日付を確認する（YYYY-MM-DD形式）

2. WebSearchで以下のクエリを並列実行して、最新のAIニュースを取得する:
   - `"AI model release" OR "new AI model" site:x.com` — Xで話題のAIモデル情報
   - `AI model launch OR release 2026` — 一般的なAIモデルニュース
   - `AI 新モデル リリース 2026` — 日本語のAIニュース

3. 検索結果を分析し、以下の情報を抽出する:
   - ニュースのタイトル
   - 概要（2-3文）
   - ソースURL
   - 関連する企業/組織名

4. 既存のニュースファイルを確認する:
   - `news/` ディレクトリ内のファイルをGlobで確認
   - 今日の日付のファイルが既に存在する場合は、内容を読んで重複を避ける

5. 取得結果を整理し、`news/YYYY-MM-DD-ai-news.md` として保存する。フォーマット:

```markdown
# AIニュース - YYYY-MM-DD

## 1. [ニュースタイトル]
- **概要**: ニュースの概要
- **企業/組織**: 関連する企業名
- **ソース**: [リンクテキスト](URL)

## 2. [ニュースタイトル]
...

---
*取得日時: YYYY-MM-DD*
*検索クエリ: 使用したクエリ一覧*
```

6. 保存完了後、取得したニュースの概要をユーザーに報告する。

## 注意事項
- 検索結果にはソースURLを必ず含める（WebSearchの要件）
- 重複するニュースは統合する
- 信頼性の低い情報源からの情報には注記を付ける
- 日本語と英語の両方のソースを含める
