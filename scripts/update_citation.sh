#!/usr/bin/env bash
# Run after Zenodo has archived a release: bash scripts/update_citation.sh
set -euo pipefail
cd "$(dirname "$0")/.."

# Read the badge's link target, not the GitHub repository ID in its image URL.
record_id=$(sed -nE 's@^\[!\[DOI\]\([^)]+\)\]\(https://doi\.org/10\.5281/zenodo\.([0-9]+)\)[[:space:]]*$@\1@p' README.md)
if ! [[ $record_id =~ ^[0-9]+$ ]]; then
    echo "Expected one Zenodo DOI badge in README.md." >&2
    exit 1
fi

fields=$(curl --fail --silent --show-error --location \
    "https://zenodo.org/api/records/$record_id/versions/latest" |
    jq -er --arg id "$record_id" '
        select(.conceptrecid == $id)
        | [.doi, (.metadata.version | ltrimstr("v")), .metadata.publication_date]
        | select((.[0] | test("^10\\.5281/zenodo\\.[0-9]+$"))
             and (.[1] | test("^[0-9]+([.][0-9]+)*([-+][A-Za-z0-9.+-]+)?$"))
             and (.[2] | test("^[0-9]{4}-[0-9]{2}-[0-9]{2}$")))
        | @tsv
    ') || { echo "Could not read release metadata for the README's Zenodo concept DOI." >&2; exit 1; }
IFS=$'\t' read -r doi version date_released <<< "$fields"

tmp=$(mktemp CITATION.cff.XXXXXX)
trap 'rm -f "$tmp"' EXIT
cp -p CITATION.cff "$tmp"
awk -v doi="$doi" -v version="$version" -v date="$date_released" '
    /^doi:/           { $0 = "doi: \"" doi "\""; dois++ }
    /^version:/       { $0 = "version: \"" version "\""; versions++ }
    /^date-released:/ { $0 = "date-released: \"" date "\""; dates++ }
    { print }
    END { if (dois != 1 || versions != 1 || dates != 1) exit 1 }
' CITATION.cff > "$tmp" || { echo "Expected one top-level doi, version and date-released in CITATION.cff." >&2; exit 1; }

if ! cmp -s "$tmp" CITATION.cff; then
    mv "$tmp" CITATION.cff
fi
printf 'CITATION.cff matches Zenodo v%s (%s), DOI %s\n' "$version" "$date_released" "$doi"
