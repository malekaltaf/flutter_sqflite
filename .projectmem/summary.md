# projectmem - flutter_sqflite

_Last updated: 2026-10-29_

## Project purpose
Replace this placeholder with a concise description of what this project does, who it serves, and the main technologies or runtime assumptions.

## Recent issues
- [DONE] #0001 databaseFactory unconditionally set to databaseFactoryFfiWeb crashes desktop and tests [lib/main.dart:9] -> Use platform-aware initDatabaseFactory via kIsWeb and defaultTargetPlatform [lib/main.dart:8] (fixed)

## Decisions
- Adopt typed UserItem model, Material 3 theming with dark mode, and search filtering [lib/]

## Notes
- main commit 01
- changes
- Update README.md
- Update README.md
- New feature: feat: initialize Flutter project with SQFlite integration and local project memory [lib/main.dart]
- Documented Material 3 architecture and attached screenshots screen1.jpg, screen2.jpg, and screen3.jpg [README.md]

## Key files
- `.gitignore`
- `.metadata`
- `README.md`
- `analysis_options.yaml`
- `android/.gitignore`
- `android/app/build.gradle`
- `android/app/src/debug/AndroidManifest.xml`
- `android/app/src/main/AndroidManifest.xml`
- `android/app/src/main/kotlin/com/example/taskmanager/MainActivity.kt`
- `android/app/src/main/res/drawable-v21/launch_background.xml`
- `android/app/src/main/res/drawable/launch_background.xml`
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png`
- `android/app/src/main/res/values-night/styles.xml`
- `android/app/src/main/res/values/styles.xml`
- `android/app/src/profile/AndroidManifest.xml`
- `android/build.gradle`

## Open questions
- None logged yet.
