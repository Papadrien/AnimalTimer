-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Play Core / SplitCompat
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# Audioplayers
-keep class xyz.luan.audioplayers.** { *; }
-dontwarn xyz.luan.audioplayers.**

# Flutter Local Notifications
-keep class com.dexterous.** { *; }
-dontwarn com.dexterous.**

# Google Play Billing Library (used by in_app_purchase plugin)
-keep class com.android.billingclient.** { *; }
-keep class com.android.vending.billing.** { *; }
-dontwarn com.android.billingclient.**
-dontwarn com.android.vending.billing.**

# in_app_purchase (Flutter plugin) — keep its Android bridge classes
-keep class io.flutter.plugins.inapppurchase.** { *; }
-dontwarn io.flutter.plugins.inapppurchase.**
