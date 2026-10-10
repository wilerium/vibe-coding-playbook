# GitHub Copilot Integration Guide

To configure GitHub Copilot Chat, PR summaries, and Copilot Workspace with the **Vibe Coding Playbook**:

```bash
# In your target project:
mkdir -p .github
cp /path/to/vibe-coding-playbook/adapters/copilot/.github/copilot-instructions.md .github/copilot-instructions.md
```

GitHub Copilot will automatically use this file as context for code completions, chat assistance, and PR reviews.
