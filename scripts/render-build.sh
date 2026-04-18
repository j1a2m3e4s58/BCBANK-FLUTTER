#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-stable}"
FLUTTER_DIR="$PWD/.render/flutter"

if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  rm -rf "$FLUTTER_DIR"
  git clone https://github.com/flutter/flutter.git --depth 1 -b "$FLUTTER_VERSION" "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

flutter --version
flutter config --enable-web
flutter pub get
flutter build web --release
