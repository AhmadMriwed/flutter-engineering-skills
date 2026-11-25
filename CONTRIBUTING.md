# Contributing

1. Find the owning profile or shared standard via the [task index](مهارات%20تصميم%20الموبايل/SKILL_INDEX.md).
2. Collect evidence, compare alternatives and disclose validation limits. Follow [governance](docs/GOVERNANCE.md) before adopting substantive changes.
3. Keep rule IDs stable and update impacted examples, compatibility, and changelog.
4. Run the structural checks using Python 3.

```sh
python3 scripts/validate_skills.py
python3 scripts/validate_links.py
```

Use [maintenance guidance](docs/SKILL_MAINTENANCE.md) to review engineering behavior in addition to structure.
