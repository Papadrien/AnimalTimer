// android/app/src/main/kotlin/com/animaltimer/MainActivity.kt

package com.animaltimer

import com.pravera.flutter_foreground_task.FlutterForegroundTaskPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Enregistrement du foreground task plugin pour le timer en background
        FlutterForegroundTaskPlugin.registerWith(flutterEngine)
    }
}
