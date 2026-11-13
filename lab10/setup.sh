#!/usr/bin/env bash
# One-time setup: generates android/ios/web folders around the existing code.
set -e
flutter create . --project-name novasteel_explorer --org kz.novasteel --platforms=android,ios,web
flutter pub get
echo
echo "Done. Start an emulator or connect a phone, then run:  flutter run"
