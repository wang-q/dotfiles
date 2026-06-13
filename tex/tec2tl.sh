#!/usr/bin/env bash
set -e

TEX_FILE="$1"
if [ -z "$TEX_FILE" ]; then
  echo "Usage: $0 your.tex"
  exit 1
fi

echo "====> Tectonic to TeX Live <===="

BASE_NAME=$(basename "$TEX_FILE" .tex)
LATEX_LOG="${BASE_NAME}.log"

rm -f tectonic.log tex_files.txt tlmgr_packages.txt

echo "==> Compile and capture log"
tectonic --keep-logs --verbose "$TEX_FILE" > tectonic.log 2>&1

echo "==> Extract dependency files from LaTeX log"
# LaTeX .log always lists loaded files in parentheses, regardless of tectonic cache
grep -oE '\([^)]+\.(sty|cls|def|fd|map|bib|bst|otf|ttf|pfb)\)' "$LATEX_LOG" |
    sed -E 's/^\((.*)\)$/\1/' |
    sed -E 's/.*(texmf-dist|texmf)\/(.*)$/\2/' |
    sort -u > tex_files.txt

echo "==> Convert to tlmgr package names"
readarray -t files < tex_files.txt
for file in "${files[@]}"; do
    tlmgr search --file "$file" | head -1 | sed 's/:$//'
done | sort -u > tlmgr_packages.txt

echo "====> Done <===="
echo "Dependency files: tex_files.txt"
echo "tlmgr packages:   tlmgr_packages.txt"
echo "Install command:  tlmgr install \$(cat tlmgr_packages.txt)"
