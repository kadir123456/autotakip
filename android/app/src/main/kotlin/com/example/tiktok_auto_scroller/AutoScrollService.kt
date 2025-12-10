package com.example.tiktok_auto_scroller

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.GestureDescription
import android.content.Intent
import android.graphics.Path
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import io.flutter.plugin.common.MethodChannel

class AutoScrollService : AccessibilityService() {
    
    companion object {
        private const val TAG = "AutoScrollService"
        var instance: AutoScrollService? = null
        const val CHANNEL_NAME = "com.example.tiktok_auto_scroller/scroll"
    }

    private var isScrolling = false
    private var scrollHandler: Handler? = null
    private var scrollRunnable: Runnable? = null
    
    // Ayarlar
    private var scrollDirection = "down" // "down", "up", "both"
    private var delaySeconds = 2
    private var repeatCount = 10
    private var currentCount = 0
    private var screenHeight = 0
    private var screenWidth = 0

    override fun onServiceConnected() {
        super.onServiceConnected()
        instance = this
        
        // Ekran boyutlarını al
        val metrics = resources.displayMetrics
        screenHeight = metrics.heightPixels
        screenWidth = metrics.widthPixels
        
        Log.d(TAG, "AutoScrollService bağlandı! Ekran: ${screenWidth}x${screenHeight}")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        // Event'leri dinle (gerekirse)
    }

    override fun onInterrupt() {
        Log.d(TAG, "Servis kesildi")
    }

    override fun onUnbind(intent: Intent?): Boolean {
        instance = null
        return super.onUnbind(intent)
    }

    // Flutter'dan çağrılacak metodlar
    fun startScrolling(direction: String, delay: Int, repeat: Int) {
        if (isScrolling) {
            Log.w(TAG, "Zaten kaydırma aktif!")
            return
        }

        this.scrollDirection = direction
        this.delaySeconds = delay
        this.repeatCount = repeat
        this.currentCount = 0
        this.isScrolling = true

        scrollHandler = Handler(Looper.getMainLooper())
        
        scrollRunnable = object : Runnable {
            override fun run() {
                if (!isScrolling || currentCount >= repeatCount) {
                    stopScrolling()
                    return
                }

                performScroll()
                currentCount++
                
                // Bir sonraki kaydırma için zamanlayıcı
                scrollHandler?.postDelayed(this, (delaySeconds * 1000).toLong())
            }
        }

        // İlk kaydırmayı başlat
        scrollHandler?.post(scrollRunnable!!)
        
        Log.d(TAG, "Kaydırma başlatıldı: $direction, $delay sn, $repeat kez")
    }

    fun stopScrolling() {
        isScrolling = false
        scrollRunnable?.let { scrollHandler?.removeCallbacks(it) }
        scrollHandler = null
        scrollRunnable = null
        currentCount = 0
        
        Log.d(TAG, "Kaydırma durduruldu")
    }

    fun pauseScrolling() {
        if (isScrolling) {
            scrollRunnable?.let { scrollHandler?.removeCallbacks(it) }
            Log.d(TAG, "Kaydırma duraklatıldı")
        }
    }

    fun resumeScrolling() {
        if (isScrolling && scrollRunnable != null) {
            scrollHandler?.post(scrollRunnable!!)
            Log.d(TAG, "Kaydırma devam ediyor")
        }
    }

    private fun performScroll() {
        when (scrollDirection) {
            "down" -> scrollDown()
            "up" -> scrollUp()
            "both" -> {
                if (currentCount % 2 == 0) {
                    scrollDown()
                } else {
                    scrollUp()
                }
            }
        }
    }

    private fun scrollDown() {
        // Ekranın ortasından başla, aşağı doğru kaydır
        val startX = screenWidth / 2f
        val startY = screenHeight * 0.8f  // Ekranın %80'inden
        val endY = screenHeight * 0.2f    // Ekranın %20'sine kaydır
        
        performGesture(startX, startY, startX, endY)
        Log.d(TAG, "Aşağı kaydırıldı (${currentCount + 1}/$repeatCount)")
    }

    private fun scrollUp() {
        // Aşağıdan yukarı kaydır
        val startX = screenWidth / 2f
        val startY = screenHeight * 0.2f  // Ekranın %20'sinden
        val endY = screenHeight * 0.8f    // Ekranın %80'ine kaydır
        
        performGesture(startX, startY, startX, endY)
        Log.d(TAG, "Yukarı kaydırıldı (${currentCount + 1}/$repeatCount)")
    }

    private fun performGesture(startX: Float, startY: Float, endX: Float, endY: Float) {
        val path = Path()
        path.moveTo(startX, startY)
        path.lineTo(endX, endY)

        val gestureBuilder = GestureDescription.Builder()
        val strokeDescription = GestureDescription.StrokeDescription(
            path,
            0,  // Başlangıç gecikmesi
            300 // Kaydırma süresi (ms) - doğal görünmesi için 300ms
        )
        
        gestureBuilder.addStroke(strokeDescription)
        
        val gesture = gestureBuilder.build()
        
        val result = dispatchGesture(gesture, object : GestureResultCallback() {
            override fun onCompleted(gestureDescription: GestureDescription?) {
                super.onCompleted(gestureDescription)
                Log.d(TAG, "Gesture tamamlandı")
            }

            override fun onCancelled(gestureDescription: GestureDescription?) {
                super.onCancelled(gestureDescription)
                Log.e(TAG, "Gesture iptal edildi")
            }
        }, null)

        if (!result) {
            Log.e(TAG, "Gesture gönderilemedi!")
        }
    }

    fun getStatus(): Map<String, Any> {
        return mapOf(
            "isScrolling" to isScrolling,
            "currentCount" to currentCount,
            "totalCount" to repeatCount,
            "direction" to scrollDirection
        )
    }
}