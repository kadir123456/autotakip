import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  runApp(const TikTokAutoScrollerApp());
}

class TikTokAutoScrollerApp extends StatelessWidget {
  const TikTokAutoScrollerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TikTok Auto Scroller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFF1a1a2e),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const platform = MethodChannel('com.example.tiktok_auto_scroller/scroll');
  
  // Durum değişkenleri
  bool hasOverlayPermission = false;
  bool hasAccessibilityPermission = false;
  bool isScrolling = false;
  bool isPaused = false;
  int currentCount = 0;
  int totalCount = 10;
  
  // Ayarlar
  String scrollDirection = 'down';
  double delaySeconds = 2.0;
  int repeatCount = 10;
  
  Timer? statusTimer;

  @override
  void initState() {
    super.initState();
    checkPermissions();
    
    // Durum güncellemesi için timer
    statusTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isScrolling) {
        updateStatus();
      }
    });
  }

  @override
  void dispose() {
    statusTimer?.cancel();
    super.dispose();
  }

  Future<void> checkPermissions() async {
    try {
      final Map<dynamic, dynamic> result = await platform.invokeMethod('checkPermissions');
      setState(() {
        hasOverlayPermission = result['overlay'] ?? false;
        hasAccessibilityPermission = result['accessibility'] ?? false;
      });
    } catch (e) {
      print('İzin kontrolü hatası: $e');
    }
  }

  Future<void> requestOverlayPermission() async {
    try {
      await platform.invokeMethod('requestOverlayPermission');
      Future.delayed(const Duration(seconds: 2), () {
        checkPermissions();
      });
    } catch (e) {
      print('Overlay izni hatası: $e');
    }
  }

  Future<void> openAccessibilitySettings() async {
    try {
      await platform.invokeMethod('openAccessibilitySettings');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2d2d44),
          title: const Text('Erişilebilirlik Servisi'),
          content: const Text(
            '1. "TikTok Auto Scroller" servisini bulun\n'
            '2. Açık konuma getirin\n'
            '3. Geri dönün',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                checkPermissions();
              },
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Accessibility ayarları hatası: $e');
    }
  }

  Future<void> startScrolling() async {
    if (!hasAccessibilityPermission) {
      _showError('Erişilebilirlik izni gerekli!');
      return;
    }

    try {
      await platform.invokeMethod('startScrolling', {
        'direction': scrollDirection,
        'delay': delaySeconds.toInt(),
        'repeat': repeatCount,
      });
      
      setState(() {
        isScrolling = true;
        isPaused = false;
        currentCount = 0;
        totalCount = repeatCount;
      });
      
      _showSuccess('Otomatik kaydırma başlatıldı!');
    } catch (e) {
      _showError('Başlatma hatası: $e');
    }
  }

  Future<void> stopScrolling() async {
    try {
      await platform.invokeMethod('stopScrolling');
      setState(() {
        isScrolling = false;
        isPaused = false;
        currentCount = 0;
      });
      _showSuccess('Kaydırma durduruldu');
    } catch (e) {
      print('Durdurma hatası: $e');
    }
  }

  Future<void> pauseScrolling() async {
    try {
      await platform.invokeMethod('pauseScrolling');
      setState(() {
        isPaused = true;
      });
    } catch (e) {
      print('Duraklatma hatası: $e');
    }
  }

  Future<void> resumeScrolling() async {
    try {
      await platform.invokeMethod('resumeScrolling');
      setState(() {
        isPaused = false;
      });
    } catch (e) {
      print('Devam ettirme hatası: $e');
    }
  }

  Future<void> updateStatus() async {
    try {
      final Map<dynamic, dynamic> status = await platform.invokeMethod('getStatus');
      setState(() {
        isScrolling = status['isScrolling'] ?? false;
        currentCount = status['currentCount'] ?? 0;
        totalCount = status['totalCount'] ?? 10;
        
        if (!isScrolling && currentCount > 0) {
          currentCount = 0;
        }
      });
    } catch (e) {
      print('Durum güncelleme hatası: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TikTok Auto Scroller'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // İzin Durumu Kartı
            _buildPermissionCard(),
            
            const SizedBox(height: 20),
            
            // Durum Kartı
            _buildStatusCard(),
            
            const SizedBox(height: 20),
            
            // Ayarlar Kartı
            _buildSettingsCard(),
            
            const SizedBox(height: 30),
            
            // Kontrol Butonları
            _buildControlButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2d2d44),
            const Color(0xFF1a1a2e),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📋 İzinler',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          
          // Overlay İzni
          _buildPermissionRow(
            '📱 Overlay İzni',
            hasOverlayPermission,
            hasOverlayPermission ? null : requestOverlayPermission,
          ),
          
          const SizedBox(height: 10),
          
          // Accessibility İzni
          _buildPermissionRow(
            '♿ Erişilebilirlik Servisi',
            hasAccessibilityPermission,
            hasAccessibilityPermission ? null : openAccessibilitySettings,
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRow(String title, bool granted, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: granted 
              ? Colors.green.withOpacity(0.1) 
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: granted ? Colors.green : Colors.red,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              granted ? Icons.check_circle : Icons.cancel,
              color: granted ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            if (!granted)
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    double progress = totalCount > 0 ? currentCount / totalCount : 0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade700,
            Colors.pink.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '📊 Durum',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isScrolling 
                      ? (isPaused ? Colors.orange : Colors.green)
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isScrolling 
                      ? (isPaused ? '⏸️ Duraklatıldı' : '▶️ Çalışıyor')
                      : '⏹️ Durduruldu',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '$currentCount',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Kaydırma',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              const Text(
                '/',
                style: TextStyle(fontSize: 24, color: Colors.white54),
              ),
              Column(
                children: [
                  Text(
                    '$totalCount',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Toplam',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 15),
          
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2d2d44),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⚙️ Ayarlar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Yön Seçimi
          const Text('Kaydırma Yönü:', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildDirectionButton('👇 Aşağı', 'down'),
              const SizedBox(width: 10),
              _buildDirectionButton('☝️ Yukarı', 'up'),
              const SizedBox(width: 10),
              _buildDirectionButton('🔄 İkisi', 'both'),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Bekleme Süresi
          Text(
            'Bekleme Süresi: ${delaySeconds.toInt()} saniye',
            style: const TextStyle(color: Colors.white70),
          ),
          Slider(
            value: delaySeconds,
            min: 2,
            max: 10,
            divisions: 8,
            label: '${delaySeconds.toInt()}s',
            onChanged: isScrolling ? null : (value) {
              setState(() {
                delaySeconds = value;
              });
            },
          ),
          
          const SizedBox(height: 10),
          
          // Tekrar Sayısı
          Text(
            'Kaydırma Sayısı: $repeatCount',
            style: const TextStyle(color: Colors.white70),
          ),
          Slider(
            value: repeatCount.toDouble(),
            min: 5,
            max: 100,
            divisions: 19,
            label: '$repeatCount',
            onChanged: isScrolling ? null : (value) {
              setState(() {
                repeatCount = value.toInt();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionButton(String label, String value) {
    bool isSelected = scrollDirection == value;
    return Expanded(
      child: ElevatedButton(
        onPressed: isScrolling ? null : () {
          setState(() {
            scrollDirection = value;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.purple : Colors.grey.shade800,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _buildControlButtons() {
    bool canStart = hasOverlayPermission && hasAccessibilityPermission && !isScrolling;
    
    return Column(
      children: [
        if (!isScrolling)
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: canStart ? startScrolling : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                disabledBackgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'Başlat',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        
        if (isScrolling) ...[
          Row(
            children: [
              if (!isPaused)
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: pauseScrolling,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Icon(Icons.pause, size: 30),
                    ),
                  ),
                )
              else
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: resumeScrolling,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Icon(Icons.play_arrow, size: 30),
                    ),
                  ),
                ),
              
              const SizedBox(width: 15),
              
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: stopScrolling,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Icon(Icons.stop, size: 30),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}