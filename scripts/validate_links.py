"""Check repository-local Markdown links, including heading fragments."""
from pathlib import Path
import re
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parents[1]
FENCE = re.compile(r"^ *(`{3,}|~{3,}).*?^ *\1 *$", re.M | re.S)
LINK = re.compile(r"!?\[[^\]\n]*\]\(\s*(?:<([^>]+)>|([^\s)]+))(?:\s+\"[^\"]*\")?\s*\)")


def markdown_files():
    return sorted(
        path for path in ROOT.rglob("*.md")
        if ".git" not in path.relative_to(ROOT).parts
    )


def markdown_body(path):
    return FENCE.sub("", path.read_text(encoding="utf-8"))


def headings(path):
    seen = {}
    result = set()
    for title in re.findall(r"^#{1,6}\s+([^\n]+)", markdown_body(path), re.M):
        slug = re.sub(r"[^\w\- ]", "", title.strip().lower()).replace(" ", "-")
        count = seen.get(slug, 0)
        result.add(f"{slug}-{count}" if count else slug)
        seen[slug] = count + 1
    return result


def local_links(path):
    for match in LINK.finditer(markdown_body(path)):
        value = urlsplit(match[1] or match[2])
        if value.scheme or value.netloc:
            continue
        raw = unquote(value.path)
        yield raw, (path.parent / raw).resolve() if raw else path, unquote(value.fragment)


def main():
    errors = []
    count = 0
    for path in markdown_files():
        for raw, target, fragment in local_links(path):
            count += 1
            reason = None
            if raw.startswith("/") or not target.is_relative_to(ROOT):
                reason = "link leaves the repository"
            elif not target.exists():
                reason = "missing link target"
            elif fragment and target.suffix == ".md" and fragment not in headings(target):
                reason = f"missing heading #{fragment}"
            if reason:
                errors.append(f"{path.relative_to(ROOT)}: {reason}: {raw}")
    if errors:
        raise SystemExit("\n".join(errors))
    print(f"{count} internal links resolved")


if __name__ == "__main__":
    main()
