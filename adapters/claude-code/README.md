# Claude Code & Optimus Integration Guide

To enable the **Vibe Coding Playbook** in your Claude Code or Optimus workflow, choose one of the following approaches:

---

## Method 1: Global Agent Skill (Recommended for all projects)
Install the playbook as a globally available Agent Skill so that any Claude Code / Optimus session can load it automatically:

```bash
# 1. Create your user-level skills directory
mkdir -p ~/.agents/skills/vibe-coding-playbook

# 2. Copy SKILL.md into the skill directory
cp /path/to/vibe-coding-playbook/SKILL.md ~/.agents/skills/vibe-coding-playbook/
```

Once installed, Claude Code or Optimus will automatically recognize the skill whenever you start a coding task, or you can trigger it directly in any prompt:
`"Follow the vibe-coding-playbook rules for this task."`

---

## Method 2: Project-Level Symlink
If you want a specific project repository to enforce the playbook for all contributors:

```bash
# In your target project root:
mkdir -p .claude/skills
ln -s /path/to/vibe-coding-playbook/SKILL.md .claude/skills/vibe-coding-playbook.md

# Or symlink CLAUDE.md to AGENTS.md
ln -s /path/to/vibe-coding-playbook/AGENTS.md CLAUDE.md
```

---

## Method 3: Direct CLAUDE.md Embedding
Copy `adapters/claude-code/CLAUDE.md` directly into the root of your target project. It contains verb-fronted context pointers to guide the agent through every phase of engineering.
