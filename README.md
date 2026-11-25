# Flutter Engineering Skills

An installable Agent Skill for planning, building and reviewing Flutter applications with Codex or Claude Code. It gives coding agents a profile selection workflow, practical feature recipes, and engineering rules supported by reference evidence and runnable examples.

| Area | Supported guidance |
| --- | --- |
| Architecture | Feature-first layers, explicit ownership and typed API boundaries |
| State | GetX reactive controllers and route bindings, or Cubit with Flutter Navigator and provider ownership |
| Dependency injection | GetIt service/repository composition and Cubit factories |
| Engineering standards | API contracts and Dio, persistence, UI composition, localization and RTL, platform services, testing and release quality |

Check the [compatibility matrix](flutter-mobile-engineering/compatibility/COMPATIBILITY_MATRIX.md) before combining profiles.

## Install and start

Download the [installable ZIP](https://github.com/AhmadMriwed/flutter-engineering-skills/releases/download/v0.2.0/flutter-mobile-engineering-v0.2.0.zip) from the [v0.2.0 pre-release](https://github.com/AhmadMriwed/flutter-engineering-skills/releases/tag/v0.2.0), or clone the [GitHub repository](https://github.com/AhmadMriwed/flutter-engineering-skills). Install the complete `flutter-mobile-engineering` folder. Choose project scope to share the skill with a team, or user scope to use it across projects. Follow the platform-specific commands in the [Codex guide](docs/CODEX_INTEGRATION.md) or the [Claude Code guide](docs/CLAUDE_CODE_INTEGRATION.md).

1. Open your Flutter project or a new project directory in your agent.
2. Use `$flutter-mobile-engineering` in Codex or `/flutter-mobile-engineering` in Claude Code.
3. Describe what you want to build. For a new app, review the proposed profiles and explicitly choose a compatible combination. The agent records the decision in `PROJECT_PROFILE.md` before scaffolding.
4. For an existing app, ask the agent to discover the current architecture, dependencies and state ownership. Use that profile to add or change features. Approve any migration separately.

Try “Design a Flutter inventory app with searchable lists, pagination and editing. Compare GetX and Cubit, recommend a compatible stack and wait for my choice.” See [copyable prompts](docs/EXAMPLE_PROMPTS.md) and [project integration](docs/PROJECT_INTEGRATION.md).

## Repository structure

- [flutter-mobile-engineering](flutter-mobile-engineering/SKILL.md) is the installable skill. Its [task index](flutter-mobile-engineering/SKILL_INDEX.md) routes to profiles, shared standards, workflows and templates. The package includes the neutral [Items fixture](flutter-mobile-engineering/validation/PORTABILITY_TEST.md).
- [docs](docs/GETTING_STARTED.md) contains installation, contribution and release guidance.
- [scripts](scripts/validate_skills.py) contains maintainer validators. GitHub Actions runs the same checks and the Flutter fixture.

## Validate and contribute

Run `python3 scripts/validate_skills.py` and `python3 scripts/validate_links.py` with Python 3.9 or newer. For code checks, follow the [portable fixture instructions](flutter-mobile-engineering/validation/PORTABILITY_TEST.md). Source history and fixtures are independent of the reference project checkouts.

The supported combinations have targeted fixture evidence. Real backends, native permissions, performance and platform-specific behavior need validation in the consuming app. See the [release checklist](docs/RELEASE_CHECKLIST.md) for publication gates.

Follow [CONTRIBUTING](CONTRIBUTING.md) to propose a change or import new evidence. See the [roadmap](ROADMAP.md), [versioning policy](docs/VERSIONING_POLICY.md), [version](VERSION) and [changelog](CHANGELOG.md).

## License

[MIT](LICENSE). Copyright (c) 2026 Ahmad Mohammed Mriyoud.
