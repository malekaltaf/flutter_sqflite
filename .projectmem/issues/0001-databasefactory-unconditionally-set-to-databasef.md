# #0001 databaseFactory unconditionally set to databaseFactoryFfiWeb crashes desktop and tests

- 2026-10-29T03:00:21Z `issue`: databaseFactory unconditionally set to databaseFactoryFfiWeb crashes desktop and tests [lib/main.dart:9]
- 2026-10-29T03:04:41Z `fix`: Use platform-aware initDatabaseFactory via kIsWeb and defaultTargetPlatform [lib/main.dart:8]
