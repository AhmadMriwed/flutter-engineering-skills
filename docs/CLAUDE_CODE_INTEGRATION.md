# Claude Code integration

Download or clone this repository. Copy the entire `flutter-mobile-engineering` directory into one of the locations below keeping the directory name `flutter-mobile-engineering`. The result must contain `flutter-mobile-engineering/SKILL.md` directly. This is a single portable skill package shared by both agent guides.

| Scope | Install under |
| --- | --- |
| Project | `.claude/skills/` at the consumer project root |
| User | `~/.claude/skills/` in your home directory |

On macOS, Windows or Linux, create missing folders and copy the package using your file manager or shell. On Windows use your user profile for the home directory. For an update, replace the complete installed package with the desired release rather than overlaying files from multiple releases.

Open your Flutter project and invoke `/flutter-mobile-engineering`. Check that the agent reads the installed SKILL.md and can follow its task index. Restart or reload the agent if needed. Choose a profile explicitly for a new app and preserve the approved choice for an existing one. [Official Claude Code discovery guidance](https://code.claude.com/docs/en/skills#choose-where-skills-load).

The package uses standard YAML name and description fields. The installed folder matches the name. Its task index lazily routes into relative references. Example assets and scripts are optional resources; maintainers use the checkout's separate validators. [Agent Skills specification](https://agentskills.io/specification).

## Copy commands

Run from the consumer project directory. Replace the example checkout path. Set the scope line for user-wide installation if desired. The commands refuse to replace an existing copy.

macOS or Linux (POSIX shell):

```sh
src=/path/to/checkout/flutter-mobile-engineering
base=".claude/skills"
# For user scope: base="$HOME/.claude/skills"
dest="$base/flutter-mobile-engineering"
if [ -f "$src/SKILL.md" ] && [ ! -e "$dest" ] && [ ! -L "$dest" ]; then
  mkdir -p "$base" && cp -R "$src" "$dest"
else
  printf '%s\n' 'Missing source skill or destination already exists.' >&2
fi
```

Windows (PowerShell):

```powershell
$src = 'C:\path\to\checkout\flutter-mobile-engineering'
$base = '.claude/skills'
# For user scope: $base = Join-Path $HOME '.claude/skills'
$dest = Join-Path $base 'flutter-mobile-engineering'
if (!(Test-Path -LiteralPath (Join-Path $src 'SKILL.md') -PathType Leaf) -or
    (Test-Path -LiteralPath $dest)) {
    throw 'Missing source skill or destination already exists.'
}
New-Item -ItemType Directory -Path $base -Force | Out-Null
Copy-Item -LiteralPath $src -Destination $dest -Recurse -ErrorAction Stop
```
