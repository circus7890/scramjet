#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

if ! command -v pnpm >/dev/null 2>&1; then
	echo "pnpm is required. Install Node.js and pnpm, then run this script again." >&2
	exit 1
fi

if [[ ! -f packages/core/dist/scramjet.wasm ]]; then
	echo "Scramjet's WebAssembly rewriter is missing; running first-time setup."
	bash ./codespace-basic-setup.sh
elif [[ ! -d node_modules ]]; then
	pnpm install --frozen-lockfile
fi

if [[ ! -f packages/core/dist/scramjet.mjs ]]; then
	pnpm --dir packages/core build
fi

exec pnpm dev