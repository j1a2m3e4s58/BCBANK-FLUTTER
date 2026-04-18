#!/usr/bin/env bash
set -euo pipefail
set -x

FLUTTER_VERSION="${FLUTTER_VERSION:-stable}"
FLUTTER_DIR="$PWD/.render/flutter"

if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  rm -rf "$FLUTTER_DIR"
  git clone https://github.com/flutter/flutter.git --depth 1 -b "$FLUTTER_VERSION" "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

echo "==> Flutter SDK"
flutter --version
echo "==> Enable web"
flutter config --enable-web
echo "==> Fetch packages"
flutter pub get
echo "==> Build web"
flutter build web --release --verbose
