package com.example.flutter_experiments

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.provider.Settings


class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "com.example.flutter_experiments/dev_mode"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "getDevMode") {
//                var args = call.arguments as Map<String, Any>
                result.success(Settings.Secure.getInt(this.getContentResolver(), Settings.Secure.ADB_ENABLED, 0) == 1)
            } else {
                result.notImplemented()
            }
        }

    }
}
