package com.example.flutterosm
import android.os.Bundle
import android.os.PersistableBundle
import androidx.annotation.NonNull
import com.baseflow.permissionhandler.PermissionHandlerPlugin.registerWith
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        flutterEngine.plugins.add(ExclePlugin())
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}
