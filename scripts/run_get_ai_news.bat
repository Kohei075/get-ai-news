@echo off
chcp 65001 >nul
cd /d "%~dp0.."

echo [%date% %time%] get-ai-news start >> logs\scheduler.log
claude -p "/get-ai-news" --allowedTools "WebSearch" "Write" "Read" "Glob" "Bash(python scripts*)" >> logs\scheduler.log 2>&1
echo [%date% %time%] get-ai-news done >> logs\scheduler.log
