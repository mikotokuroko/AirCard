"""Human-readable CLI output; JSON backend messages remain unchanged.

Set AIRCARD_LANGUAGE=zh-Hans or en to override the terminal locale.
The desktop app translates backend messages at its presentation boundary.
"""
from __future__ import annotations

import builtins
import json
import os
import re
from functools import lru_cache
from pathlib import Path

_SLOT = re.compile(r"\{([A-Za-z_]+)\}")


def language() -> str:
    override = os.environ.get("AIRCARD_LANGUAGE")
    if override in ("en", "zh-Hans"):
        return override
    locale = next((os.environ[key] for key in ("LC_ALL", "LC_MESSAGES", "LANG") if os.environ.get(key)), "en")
    return "zh-Hans" if locale.startswith(("zh_CN", "zh_SG", "zh-Hans")) else "en"


@lru_cache(maxsize=1)
def _catalog() -> tuple[dict[str, str], list[tuple[re.Pattern, list[str], str]]]:
    try:
        translations = json.loads((Path(__file__).parent / "Translations/zh-Hans.json").read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return {}, []
    templates = []
    for source in sorted(translations, key=lambda value: (-len(value), value)):
        slots = list(_SLOT.finditer(source))
        if not slots:
            continue
        fragments, names, start = [], [], 0
        for slot in slots:
            fragments.extend((re.escape(source[start:slot.start()]), "(.*?)"))
            names.append(slot[1])
            start = slot.end()
        fragments.append(re.escape(source[start:]))
        templates.append((re.compile("".join(fragments), re.DOTALL), names, translations[source]))
    return translations, templates


def translate(source: str, selected_language: str | None = None) -> str:
    if (selected_language or language()) != "zh-Hans":
        return source
    translations, templates = _catalog()
    if source in translations:
        return translations[source]
    for pattern, names, target in templates:
        match = pattern.fullmatch(source)
        if match:
            values = dict(zip(names, match.groups()))
            return _SLOT.sub(lambda slot: values[slot[1]], target)
    return source


def _line(source: str) -> str:
    # CLI decorations and step numbers are not part of the shared message keys.
    card_heading = re.fullmatch(r"(\s*--- \[\d+/\d+\] )(.+?)( ---\s*)", source)
    if card_heading:
        return card_heading[1] + translate(card_heading[2]) + card_heading[3]
    prefix = re.match(r"^(\s*(?:(?:[📡👉✨🎴❌✅🎉]|->)\s*)?(?:(?:\[\d+/\d+\]|\d[).])\s*)?)(.*?)(\s*)$", source)
    if not prefix:
        return translate(source)
    return prefix[1] + translate(prefix[2]) + prefix[3]


def print_localized(*values: object, sep: str = " ", end: str = "\n", **kwargs: object) -> None:
    message = sep.join(str(value) for value in values)
    builtins.print("\n".join(_line(line) for line in message.split("\n")), end=end, **kwargs)


def input_localized(prompt: str) -> str:
    return builtins.input(_line(prompt))
