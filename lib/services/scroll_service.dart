import 'package:flutter/services.dart';
import '../models/scroll_config.dart';

class ScrollService {
  static const platform = MethodChannel('com.example.tiktok_auto_scroller/scroll');
  
  // Singleton pattern
  static final ScrollService _instance = ScrollService._internal();
  factory ScrollService() => _instance;
  ScrollService._internal();
  
  // İzin kontrolü
  Future<Map<String, bool>> checkPermissions() async {
    try {
      final Map<dynamic, dynamic> result = await platform.invokeMethod('checkPermissions');
      return {
        'overlay': result['overlay'] ?? false,
        'accessibility': result['accessibility'] ?? false,
      };
    } catch (e) {
      print('İzin kontrolü hatası: $e');
      return {'overlay': false, 'accessibility': false};
    }
  }
  
  // Overlay izni iste
  Future<bool> requestOverlayPermission() async {
    try {
      await platform.invokeMethod('requestOverlayPermission');
      return true;
    } catch (e) {
      print('Overlay izni hatası: $e');
      return false;
    }
  }
  
  // Accessibility ayarlarını aç
  Future<bool> openAccessibilitySettings() async {
    try {
      await platform.invokeMethod('openAccessibilitySettings');
      return true;
    } catch (e) {
      print('Accessibility ayarları hatası: $e');
      return false;
    }
  }
  
  // Kaydırmayı başlat
  Future<bool> startScrolling(ScrollConfig config) async {
    try {
      await platform.invokeMethod('startScrolling', config.toMap());
      return true;
    } catch (e) {
      print('Başlatma hatası: $e');
      rethrow;
    }
  }
  
  // Kaydırmayı durdur
  Future<bool> stopScrolling() async {
    try {
      await platform.invokeMethod('stopScrolling');
      return true;
    } catch (e) {
      print('Durdurma hatası: $e');
      return false;
    }
  }
  
  // Duraklat
  Future<bool> pauseScrolling() async {
    try {
      await platform.invokeMethod('pauseScrolling');
      return true;
    } catch (e) {
      print('Duraklatma hatası: $e');
      return false;
    }
  }
  
  // Devam et
  Future<bool> resumeScrolling() async {
    try {
      await platform.invokeMethod('resumeScrolling');
      return true;
    } catch (e) {
      print('Devam ettirme hatası: $e');
      return false;
    }
  }
  
  // Durum bilgisi al
  Future<ScrollStatus> getStatus() async {
    try {
      final Map<dynamic, dynamic> status = await platform.invokeMethod('getStatus');
      return ScrollStatus.fromMap(status);
    } catch (e) {
      print('Durum güncelleme hatası: $e');
      return ScrollStatus.initial();
    }
  }
}