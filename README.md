# TikTok Auto Scroller 📱

TikTok, Instagram, YouTube ve diğer sosyal medya uygulamalarında otomatik kaydırma yapan Android uygulaması.

## 🎯 Özellikler

- ✅ **Otomatik Kaydırma**: Aşağı, yukarı veya her iki yönde otomatik kaydırma
- ⏱️ **Özelleştirilebilir**: Kaydırma hızı ve sayısı ayarlanabilir (2-10 saniye, 5-10000 kaydırma)
- 🎮 **Kolay Kontrol**: Başlat, durdur, duraklat butonları
- 🔒 **Gizlilik**: Hiçbir veri toplanmaz, tamamen offline çalışır
- 🎨 **Modern UI**: Dark theme, gradient renkler
- 📊 **İlerleme Takibi**: Gerçek zamanlı kaydırma sayacı

## 📱 Desteklenen Uygulamalar

- TikTok
- Instagram
- YouTube
- Facebook
- Twitter (X)
- Reddit
- Ve diğer tüm kaydırılabilir uygulamalar!

## 🚀 Kurulum

### Gereksinimler
- Flutter SDK (3.0.0 veya üzeri)
- Android SDK (API 24 veya üzeri)
- Kotlin 1.9.0

### Adımlar

1. **Bağımlılıkları yükle:**
```bash
flutter pub get
```

2. **Uygulamayı çalıştır:**
```bash
flutter run
```

3. **APK oluştur:**
```bash
flutter build apk --release
```

## ⚙️ Kullanım

1. **İzinleri Ver:**
   - Overlay izni (ekran üstünde gösterim için)
   - Erişilebilirlik servisi (otomatik kaydırma için)

2. **Ayarları Yapılandır:**
   - Kaydırma yönünü seç (👇 Aşağı, ☝️ Yukarı, 🔄 İkisi)
   - Bekleme süresini ayarla (2-10 saniye)
   - Kaydırma sayısını belirle (5-10000)

3. **Başlat & Kontrol:**
   - ▶️ Başlat: Otomatik kaydırmayı başlat
   - ⏸️ Duraklat: Geçici olarak durdur
   - ⏹️ Durdur: Tamamen durdur

## 🔧 Teknik Detaylar

- **Flutter**: UI framework
- **Kotlin**: Native Android kodu
- **AccessibilityService**: Otomatik kaydırma için
- **MethodChannel**: Flutter-Android iletişimi

## 🛡️ Güvenlik & Gizlilik

- ✅ Hiçbir veri toplanmaz
- ✅ İnternet bağlantısı gerektirmez
- ✅ Açık kaynak kodlu
- ✅ Sadece sizin belirlediğiniz zamanlarda çalışır

---

**Versiyon:** 1.0.0
