# android/app/proguard-rules.pro

# ── Flutter ──────────────────────────────────────────────────────────────────
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.**

# ── just_audio ───────────────────────────────────────────────────────────────
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**

# ── flutter_foreground_task ───────────────────────────────────────────────────
-keep class com.pravera.flutter_foreground_task.** { *; }

# ── Kotlin ───────────────────────────────────────────────────────────────────
-dontwarn kotlin.**
-keep class kotlin.** { *; }

# ── Général ───────────────────────────────────────────────────────────────────
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
