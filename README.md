# ujira-docs
UJIRA integration docs, API reference and MCP guide.

## Invisible characters

Literal bidirectional controls and invisible characters can make text read differently from what it is, and they do not show in review. To check the tree:

```sh
scripts/check-invisible-characters.py
```

It reads every tracked file as bytes, skips binary content (any NUL byte) whatever its extension, and requires the rest to be valid UTF-8. It fails on every character in the Unicode categories Cf, Zl and Zp, such as the byte order mark, zero width characters, the bidirectional controls U+202A to U+202E and U+2066 to U+2069, and U+2028 and U+2029, naming the file, line, column and code point. Categories come from Python's `unicodedata` tables, and the script uses the standard library only. It also fails on the no break space (U+00A0), narrow no break space (U+202F) and minus sign (U+2212), except in files listed in `scripts/invisible-characters-allowlist.txt`. Write any of these as an HTML entity such as `&nbsp;` or `&#x2212;`, or as an escape inside code. `scripts/test-check-invisible-characters.sh` tests the check itself.
