# Flutter & Plugins
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Isar Database native library & models
-keep class dev.isar.** { *; }
-dontwarn dev.isar.**
-keepclassmembers class * extends io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }

# Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Flutter Play Core (Deferred Components)
-dontwarn com.google.android.play.core.**
