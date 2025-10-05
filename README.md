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
- <code>google_scholar_crawler/</code>: script for citation stats

## Deployment

This repository is intended to be published by GitHub Pages.

1. Push changes to the default branch.
2. Ensure the repository is configured as a GitHub Pages site (Settings → Pages).

## Notes

- The site uses the <code>github-pages</code> gem, which pins compatible versions of Jekyll and plugins.
- Local development uses Bundler to ensure versions match GitHub Pages.

## License

See <code>LICENSE</code>.
