#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_tex="${repo_root}/_pages/cv_tex.tex"
build_dir="${repo_root}/tmp/cv-build"
staging_dir="${repo_root}/cv-temp"
one_page=false
if [[ "${1:-}" == "--one-page" ]]; then
  one_page=true
  source_tex="${repo_root}/_pages/resume_onepage.tex"
  staging_dir="${repo_root}/output/pdf"
  shift
fi

if [[ ! -f "${source_tex}" ]]; then
  echo "CV source not found: ${source_tex}" >&2
  exit 1
fi

mkdir -p "${build_dir}" "${staging_dir}"

timestamp="$(date +%Y%m%d-%H%M%S)"
if [[ "${one_page}" == true ]]; then
  output_stem="${1:-Jiawei_Xu_Resume}"
else
  output_stem="${1:-JIAWEI_CV-${timestamp}}"
fi
output_pdf="${staging_dir}/${output_stem}.pdf"
engine=""
build_pdf="${build_dir}/${output_stem}.pdf"

if grep -q "fontspec" "${source_tex}"; then
  if command -v tectonic >/dev/null 2>&1; then
    engine="tectonic"
    temp_source="${build_dir}/${output_stem}.tex"
    cp "${source_tex}" "${temp_source}"
    tectonic -c minimal --keep-logs -o "${build_dir}" "${temp_source}" >/dev/null
  elif command -v xelatex >/dev/null 2>&1; then
    engine="xelatex"
    for pass in 1 2; do
      xelatex -interaction=nonstopmode -halt-on-error -output-directory="${build_dir}" -jobname="${output_stem}" "${source_tex}" >/dev/null
    done
  else
    echo "This CV uses fontspec; install tectonic or XeLaTeX." >&2
    exit 1
  fi
elif command -v latexmk >/dev/null 2>&1; then
  engine="latexmk"
  latexmk -pdf -interaction=nonstopmode -halt-on-error \
    -output-directory="${build_dir}" \
    -jobname="${output_stem}" \
    "${source_tex}"
elif command -v pdflatex >/dev/null 2>&1; then
  engine="pdflatex"
  pdflatex -interaction=nonstopmode -halt-on-error \
    -output-directory="${build_dir}" \
    -jobname="${output_stem}" \
    "${source_tex}" >/dev/null
  pdflatex -interaction=nonstopmode -halt-on-error \
    -output-directory="${build_dir}" \
    -jobname="${output_stem}" \
    "${source_tex}" >/dev/null
elif command -v tectonic >/dev/null 2>&1; then
  engine="tectonic"
  temp_source="${build_dir}/${output_stem}.tex"
  cp "${source_tex}" "${temp_source}"
  tectonic -c minimal --keep-logs -o "${build_dir}" "${temp_source}" >/dev/null
else
  echo "None of latexmk, pdflatex, or tectonic is installed." >&2
  echo "Install a LaTeX toolchain, then re-run: bash scripts/build_cv.sh" >&2
  exit 1
fi

cp "${build_pdf}" "${output_pdf}"

echo "Generated CV: ${output_pdf}"
echo "Engine used: ${engine}"
if [[ "${one_page}" == false ]]; then
  echo "To publish this version, run:"
  echo "  cp \"${output_pdf}\" \"${repo_root}/cv/JIAWEI_CV.pdf\""
fi
