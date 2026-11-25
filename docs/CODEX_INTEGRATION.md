# Codex integration

For explicit use, point Codex at the [central SKILL.md](../مهارات%20تصميم%20الموبايل/SKILL.md) and ask it to follow the skill. It needs read access to the checkout.

For discovery, symlink the whole knowledge directory as `flutter-mobile-engineering` under `.agents/skills/` at the consumer repo root, or under `~/.agents/skills/` for personal discovery. Set `FLUTTER_SKILLS_CHECKOUT` to your local checkout before running this from the consumer project.

```sh
test -f "${FLUTTER_SKILLS_CHECKOUT:?Set the checkout path}/مهارات تصميم الموبايل/SKILL.md" &&
  mkdir -p .agents/skills &&
  ln -s "$FLUTTER_SKILLS_CHECKOUT/مهارات تصميم الموبايل" .agents/skills/flutter-mobile-engineering
```

Choose the skill from the selector or use `$flutter-mobile-engineering` where Codex supports skill mentions. Restart the client if a new skill fails to appear. [Official Codex skill guidance](https://learn.chatgpt.com/docs/build-skills#where-codex-loads-local-skills).
