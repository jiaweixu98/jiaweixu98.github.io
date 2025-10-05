#!/usr/bin/env bash
set -euo pipefail

# Prefer Homebrew Ruby 3.3 if available
if [ -d "/opt/homebrew/opt/ruby@3.3/bin" ]; then
  export PATH="/opt/homebrew/opt/ruby@3.3/bin:$PATH"
fi

# Ensure Bundler 2.6.2 is installed
if ! command -v bundle >/dev/null 2>&1 || ! bundle -v | grep -q "2.6.2"; then
  gem install bundler:2.6.2 --no-document
fi

# Install gems locally
bundle config set --local path 'vendor/bundle'
bundle install --jobs 4

# Find an available port starting at $PORT or 4000
port_is_free() {
  local port="$1"
  if command -v lsof >/dev/null 2>&1; then
    if lsof -iTCP:"$port" -sTCP:LISTEN -Pn -t >/dev/null 2>&1; then
      return 1
    else
      return 0
    fi
  elif command -v nc >/dev/null 2>&1; then
    if nc -z 127.0.0.1 "$port" >/dev/null 2>&1; then
      return 1
    else
      return 0
    fi
  else
    ruby -e "require 'socket'; s=TCPServer.new('127.0.0.1', ARGV[0].to_i); s.close" "$port" >/dev/null 2>&1
    return $?
  fi
}

start_port="${PORT:-4000}"
end_port=$((start_port + 20))
chosen_port=""

for ((p=start_port; p<=end_port; p++)); do
  if port_is_free "$p"; then
    chosen_port="$p"
    break
  fi
done

if [ -z "$chosen_port" ]; then
  echo "No free port found in range ${start_port}-${end_port}." >&2
  echo "Hint: free port 4000 with: lsof -ti:4000 | xargs kill -9" >&2
  exit 1
fi

if [ "$chosen_port" != "$start_port" ]; then
  echo "Port $start_port is busy; using $chosen_port instead." >&2
  echo "To free $start_port: lsof -ti:$start_port | xargs kill -9" >&2
fi

# Run local server on the chosen port
exec bundle exec jekyll serve --incremental --host 127.0.0.1 --port "$chosen_port"