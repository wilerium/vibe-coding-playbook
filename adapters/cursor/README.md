# Cursor IDE Integration Guide

Cursor supports two ways to enforce project rules:

## Option A: Modern Modular Rules (`.cursor/rules/`)
Copy the `.cursor/rules/` directory into your project root:
```bash
cp -r /path/to/vibe-coding-playbook/adapters/cursor/.cursor /path/to/your-project/
```
This enables Cursor's native Rule Engine with `alwaysApply: true`.

## Option B: Classic Single-File (`.cursorrules`)
Copy `.cursorrules` directly into your project root:
```bash
cp /path/to/vibe-coding-playbook/adapters/cursor/.cursorrules /path/to/your-project/.cursorrules
```
Cursor Composer and Chat will automatically load these rules for all prompts.
