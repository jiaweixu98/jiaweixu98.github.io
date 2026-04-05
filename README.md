<h1 align="center">Jiawei Xu — Personal Homepage</h1>

<p align="center">Built with Jekyll and the <code>github-pages</code> gem.</p>

## Prerequisites

- **Homebrew** on macOS
- **Ruby 3.3** (installed via Homebrew)
- **Bundler 2.6.2**

Quick install on macOS:

```bash
brew install ruby@3.3
echo 'export PATH="/opt/homebrew/opt/ruby@3.3/bin:$PATH"' >> ~/.zshrc
export PATH="/opt/homebrew/opt/ruby@3.3/bin:$PATH"
gem install bundler:2.6.2 --no-document
```

## Setup

Install Ruby gems locally into <code>vendor/bundle</code>:

```bash
bundle config set --local path 'vendor/bundle'
bundle install
```

## Run Locally

```bash
bash run_server.sh
```

Open http://127.0.0.1:4000

## Project Structure

- <code>_pages/</code>: main content (edit <code>about.md</code>)
- <code>_includes/</code>, <code>_layouts/</code>, <code>_sass/</code>: theme templates and styles
- <code>assets/</code>: site CSS/JS and fonts
- <code>images/</code>: site images and icons
- <code>cv-temp/</code>: local staging area for multiple CV PDF versions
- <code>cv/</code>: published CV path; the site only links to <code>cv/JIAWEI_CV.pdf</code>
- <code>scripts/build_cv.sh</code>: generate a PDF from <code>_pages/cv_tex.tex</code> into <code>cv-temp/</code> using <code>latexmk</code>, <code>pdflatex</code>, or <code>tectonic</code>
- <code>scripts/push_site.sh</code>: one-command stage, commit, and push helper for site updates
- <code>google_scholar_crawler/</code>: script for citation stats

## CV Workflow

Generate a new PDF into the staging folder:

```bash
bash scripts/build_cv.sh
```

Or provide your own output stem:

```bash
bash scripts/build_cv.sh JIAWEI_CV-academic
```

After reviewing a version in <code>cv-temp/</code>, publish it by copying it to the fixed public path:

```bash
cp "cv-temp/JIAWEI_CV-academic.pdf" "cv/JIAWEI_CV.pdf"
```

This lets you keep multiple versions locally while the site always serves the same public URL.

The script auto-detects <code>latexmk</code>, then <code>pdflatex</code>, then <code>tectonic</code>.

## Deployment

This repository is intended to be published by GitHub Pages.

1. Push changes to the default branch.
2. Ensure the repository is configured as a GitHub Pages site (Settings → Pages).

Quick push helper:

```bash
bash scripts/push_site.sh "update homepage and cv"
```

Preview what it would stage without committing:

```bash
bash scripts/push_site.sh --dry-run
```

## Notes

- The site uses the <code>github-pages</code> gem, which pins compatible versions of Jekyll and plugins.
- Local development uses Bundler to ensure versions match GitHub Pages.

## License

See <code>LICENSE</code>.
