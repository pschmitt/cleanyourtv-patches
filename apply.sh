#!/usr/bin/env bash
# Apply these patches to a checkout of Clean Your TV (https://github.com/Gathin23/cleanyourtv).
#   ./apply.sh /path/to/cleanyourtv [patch-number ...]     e.g. ./apply.sh ~/cleanyourtv 0001
# With no numbers, all patches are applied. The patches were made against the commit in UPSTREAM; on a newer
# upstream they usually still apply (git am --3way); if one does not, git tells you which hunk.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="${1:?usage: apply.sh /path/to/cleanyourtv [patch-number ...]}"
shift
cd "$REPO"
[ -d .git ] && [ -d launcher ] || { echo "not a Clean Your TV checkout: $REPO" >&2; exit 1; }
[ -z "$(git status --porcelain)" ] || { echo "the checkout has uncommitted changes; commit or stash them first" >&2; exit 1; }
if [ "$#" -eq 0 ]; then
  PATCHES=("$HERE"/patches/*.patch)
else
  PATCHES=()
  for n in "$@"; do PATCHES+=("$HERE"/patches/"$n"-*.patch); done
fi
git am --3way "${PATCHES[@]}"
echo "Applied ${#PATCHES[@]} patch(es). Build the launcher as usual (see the upstream README), then adb install -r the APK."
