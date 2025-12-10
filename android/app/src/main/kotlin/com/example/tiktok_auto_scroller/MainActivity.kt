package com.example.tiktok_auto_scroller

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    
    private val CHANNEL = "com.example.tiktok_auto_scroller/scroll"
    private val OVERLAY_PERMISSION_REQUEST_CODE = 1234

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            
            when (call.method) {
                // İzin kontrolü
                "checkPermissions" -> {
                    val hasOverlay = checkOverlayPermission()
                    val hasAccessibility = checkAccessibilityPermission()
                    
                    result.success(mapOf(
                        "overlay" to hasOverlay,
                        "accessibility" to hasAccessibility
                    ))
                }
                
                // Overlay izni iste
                "requestOverlayPermission" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        if (!Settings.canDrawOverlays(this)) {
                            val intent = Intent(
                                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                                Uri.parse("package:$packageName")
                            )
                            startActivityForResult(intent, OVERLAY_PERMISSION_REQUEST_CODE)
                            result.success(true)
                        } else {
                            result.success(false)
                        }
                    } else {
                        result.success(false)
                    }
                }
                
                // Accessibility ayarlarını aç
                "openAccessibilitySettings" -> {
                    val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
                    startActivity(intent)
                    result.success(true)
                }
                
                // Kaydırmayı başlat
                "startScrolling" -> {
                    val direction = call.argument<String>("direction") ?: "down"
                    val delay = call.argument<Int>("delay") ?: 2
                    val repeat = call.argument<Int>("repeat") ?: 10
                    
                    val service = AutoScrollService.instance
                    if (service != null) {
                        service.startScrolling(direction, delay, repeat)
                        result.success(true)
                    } else {
                        result.error("NO_SERVICE", "Accessibility servisi aktif değil", null)
                    }
                }
                
                // Kaydırmayı durdur
                "stopScrolling" -> {
                    AutoScrollService.instance?.stopScrolling()
                    result.success(true)
                }
                
                // Duraklat
                "pauseScrolling" -> {
                    AutoScrollService.instance?.pauseScrolling()
                    result.success(true)
                }
                
                // Devam et
                "resumeScrolling" -> {
                    AutoScrollService.instance?.resumeScrolling()
                    result.success(true)
                }
                
                // Durum bilgisi al
                "getStatus" -> {
                    val service = AutoScrollService.instance
                    if (service != null) {
                        result.success(service.getStatus())
                    } else {
                        result.success(mapOf(
                            "isScrolling" to false,
                            "currentCount" to 0,
                            "totalCount" to 0,
                            "direction" to "down"
                        ))
                    }
                }
                
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun checkOverlayPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Settings.canDrawOverlays(this)
        } else {
            true
        }
    }

    private fun checkAccessibilityPermission(): Boolean {
        return AutoScrollService.instance != null
    }
}