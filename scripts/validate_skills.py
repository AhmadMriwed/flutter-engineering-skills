"""Check the knowledge base's structure and version metadata."""
from collections import Counter
import re

from validate_links import ROOT, local_links, markdown_body, markdown_files

SKILLS = ROOT / "مهارات تصميم الموبايل"
RULE = r"(?!REF-)[A-Z]+-\d{3}"
CLASSIFICATION = (
    "MANDATORY|DEFAULT|CONDITIONAL|OPTIONAL|PROJECT-SPECIFIC|INCONSISTENT|"
    "NOT IMPLEMENTED|RECOMMENDED"
)
SEMVER = r"(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)"
STATUS = r"(?:Pending|Experimental|Validated|Stable|Deprecated)"
CATALOG = {
    "ARCH-FEATURE": "architecture/profiles/feature-first/PROFILE.md",
    "STATE-GETX": "state-management/getx/PROFILE.md",
    "DI-GETIT": "dependency-injection/get_it/GET_IT.md",
    "STATE-CUBIT": "state-management/cubit/README.md",
}
REQUIRED = (
    "README.md", "AGENTS.md", "CHANGELOG.md", "CONTRIBUTING.md", "ROADMAP.md",
    "VERSION", ".gitignore", "docs/GETTING_STARTED.md", "docs/GOVERNANCE.md",
    "docs/CODEX_INTEGRATION.md", "docs/CLAUDE_CODE_INTEGRATION.md",
    "docs/PROJECT_INTEGRATION.md", "docs/SKILL_MAINTENANCE.md",
    "docs/VERSIONING_POLICY.md", "scripts/validate_links.py",
    "scripts/validate_skills.py", ".github/workflows/validate-skills.yml",
    ".github/pull_request_template.md", ".github/ISSUE_TEMPLATE/skill-proposal.md",
)
REQUIRED_SKILLS = (
    "README.md", "AGENTS.md", "SKILL.md", "SKILL_INDEX.md",
    "architecture/ARCHITECTURE_INDEX.md", "state-management/STATE_MANAGEMENT_INDEX.md",
    "dependency-injection/DI_INDEX.md", "compatibility/COMPATIBILITY_MATRIX.md",
    "state-management/cubit/PENDING_EXTRACTION.md",
    "knowledge-management/SOURCE_REGISTRY.md", "knowledge-management/EVIDENCE_REGISTRY.md",
)


def main():
    errors = []

    def check(condition, message):
        if not condition:
            errors.append(message)

    for path in [*(ROOT / name for name in REQUIRED),
                 *(SKILLS / name for name in (*REQUIRED_SKILLS, *CATALOG.values()))]:
        check(path.is_file() and bool(path.read_text(encoding="utf-8").strip()),
              f"Missing or empty file: {path.relative_to(ROOT)}")
    if errors:
        raise SystemExit("\n".join(errors))

    # The skill intentionally uses the two-field YAML plain-scalar subset.
    skill = (SKILLS / "SKILL.md").read_text(encoding="utf-8")
    header = re.match(
        r"\A---\nname: ([a-z0-9]+(?:-[a-z0-9]+)*)\n"
        r"description: ([A-Za-z][A-Za-z0-9 ,./()'-]*)\n---\n\s*\S",
        skill,
    )
    check(header and len(header[1]) <= 64 and len(header[2]) <= 1024,
          "Invalid SKILL.md frontmatter or missing skill body")
    version = (ROOT / "VERSION").read_text(encoding="utf-8").strip()
    check(re.fullmatch(SEMVER, version), "VERSION must use MAJOR.MINOR.PATCH")
    check(f"## {version}" in (ROOT / "CHANGELOG.md").read_text().splitlines(),
          "CHANGELOG.md is missing the VERSION heading")

    definitions = Counter()
    references = set()
    snippets = 0
    for path in markdown_files():
        raw = path.read_text(encoding="utf-8")
        check(bool(raw.strip()), f"Empty Markdown file: {path.relative_to(ROOT)}")
        check(not re.search(r"(?<![\w/])(?:/Users/|/home/|file://|[A-Za-z]:\\\\Users\\\\)", raw),
              f"Machine-specific path in {path.relative_to(ROOT)}")
        body = markdown_body(path)
        definitions.update(re.findall(rf"\*\*({RULE}) (?:{CLASSIFICATION})\*\*", body))
        references.update(re.findall(rf"\b{RULE}\b", body))
        for prefix, start, end in re.findall(r"\b([A-Z]+)-(\d{3})[–-](\d{3})\b", body):
            if prefix != "REF":
                references.update(f"{prefix}-{number:03}" for number in range(int(start), int(end) + 1))
        snippets += len(re.findall(r"^```dart\s*$", raw, re.M))
    check(bool(definitions), "No classified rule definitions found")
    for rule, count in definitions.items():
        check(count == 1, f"Duplicate definition for {rule}")
    for rule in sorted(references - definitions.keys()):
        check(False, f"Undefined rule: {rule}")

    index = SKILLS / "SKILL_INDEX.md"
    links = list(local_links(index))
    check(bool(links) and all(path.is_file() for _, path, _ in links),
          "SKILL_INDEX.md has missing or no targets")
    for profile, relative in CATALOG.items():
        path = SKILLS / relative
        content = path.read_text()
        check(profile in content, f"Profile ID absent from {relative}")
        if profile == "STATE-CUBIT":
            check("**Pending**" in content, "Cubit intake must be Pending before extraction")
        else:
            check(re.search(rf"\| Status \| {STATUS}\b", content),
                  f"Invalid profile status in {relative}")

    matrix = (SKILLS / "compatibility/COMPATIBILITY_MATRIX.md").read_text()
    profile_ids = set(re.findall(r"\b(?:ARCH|STATE|DI|NET|STORE|NAV)-[A-Z][A-Z0-9-]+\b", matrix))
    check(profile_ids <= CATALOG.keys(), f"Unregistered profiles: {sorted(profile_ids - CATALOG.keys())}")
    if errors:
        raise SystemExit("\n".join(errors))
    print(f"Structure valid: version {version}, {len(definitions)} rule definitions, {snippets} Dart blocks")


if __name__ == "__main__":
    main()
