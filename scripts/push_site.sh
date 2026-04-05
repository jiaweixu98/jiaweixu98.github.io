#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "${repo_root}" ]]; then
  echo "Not inside a git repository." >&2
  exit 1
fi

cd "${repo_root}"

dry_run=0
commit_message=""

while (($# > 0)); do
  case "$1" in
    --dry-run)
      dry_run=1
      ;;
    *)
      if [[ -z "${commit_message}" ]]; then
        commit_message="$1"
      else
        commit_message="${commit_message} $1"
      fi
      ;;
  esac
  shift
done

should_skip() {
  local path="$1"
  case "$path" in
    .jekyll-metadata|cv-temp/*.pdf|_site/*|tmp/*|vendor/bundle/*|.DS_Store)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

tmp_candidates="$(mktemp)"
tmp_stage="$(mktemp)"
tmp_skip="$(mktemp)"
trap 'rm -f "${tmp_candidates}" "${tmp_stage}" "${tmp_skip}"' EXIT

git diff --name-only HEAD -- . > "${tmp_candidates}" || true
git ls-files --others --exclude-standard >> "${tmp_candidates}"

sort -u "${tmp_candidates}" | while IFS= read -r path; do
  [[ -z "${path}" ]] && continue
  if should_skip "${path}"; then
    printf '%s\n' "${path}" >> "${tmp_skip}"
  else
    printf '%s\n' "${path}" >> "${tmp_stage}"
  fi
done

if [[ ! -s "${tmp_stage}" ]]; then
  echo "No deployable changes found."
  if [[ -s "${tmp_skip}" ]]; then
    echo
    echo "Skipped files:"
    sed 's/^/  - /' "${tmp_skip}"
  fi
  exit 0
fi

echo "Files to stage:"
sed 's/^/  - /' "${tmp_stage}"

if [[ -s "${tmp_skip}" ]]; then
  echo
  echo "Skipped files:"
  sed 's/^/  - /' "${tmp_skip}"
fi

if (( dry_run )); then
  echo
  echo "Dry run only. No files staged, committed, or pushed."
  exit 0
fi

while IFS= read -r path; do
  [[ -z "${path}" ]] && continue
  git add -A -- "${path}"
done < "${tmp_stage}"

if git diff --cached --quiet; then
  echo
  echo "Nothing ended up staged after filtering."
  exit 0
fi

if [[ -z "${commit_message}" ]]; then
  read -r -p "Commit message [update site]: " commit_message
  commit_message="${commit_message:-update site}"
fi

echo
echo "Creating commit..."
git commit -m "${commit_message}"

echo
echo "Pushing to origin..."
git push origin HEAD

echo
echo "Done. Current status:"
git status --short
