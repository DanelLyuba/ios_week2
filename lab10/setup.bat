@echo off
REM One-time setup: generates android/ios/web folders around the existing code.
call flutter create . --project-name novasteel_explorer --org kz.novasteel --platforms=android,ios,web
call flutter pub get
echo.
echo Done. Start an emulator or connect a phone, then run:  flutter run
