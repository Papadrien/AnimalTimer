#!/bin/bash
set -e

echo "Building Flutter web app..."
flutter build web --release

echo "Serving on port 5000..."
cd build/web && python3 -m http.server 5000 --bind 0.0.0.0
