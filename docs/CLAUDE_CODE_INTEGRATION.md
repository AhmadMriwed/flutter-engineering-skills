# Claude Code integration

For explicit use, point Claude Code at the [central SKILL.md](../مهارات%20تصميم%20الموبايل/SKILL.md). For discovery, symlink the whole skill directory under the consumer project's `.claude/skills/` or `~/.claude/skills/` for personal use. Set `FLUTTER_SKILLS_CHECKOUT` to your local checkout before running this from the consumer project.

```sh
test -f "${FLUTTER_SKILLS_CHECKOUT:?Set the checkout path}/مهارات تصميم الموبايل/SKILL.md" &&
  mkdir -p .claude/skills &&
  ln -s "$FLUTTER_SKILLS_CHECKOUT/مهارات تصميم الموبايل" .claude/skills/flutter-mobile-engineering
```

Invoke `/flutter-mobile-engineering` or ask Claude to use it when relevant. The symlink entry name determines the command. Managed customization settings may restrict discovery. [Official Claude Code skill guidance](https://code.claude.com/docs/en/skills#choose-where-skills-load).
