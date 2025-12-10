# 🚀 TikTok Auto Scroller - Build Rehberi

## 📋 Gereksinimler

### 1. Flutter SDK Kurulumu
```bash
# Flutter SDK'yı indirin (https://flutter.dev/docs/get-started/install)
# Linux/Mac için:
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Kontrol edin:
flutter doctor
```

### 2. Android SDK Kurulumu
- Android Studio'yu indirin ve yükleyin
- SDK Manager'dan gerekli paketleri yükleyin:
  - Android SDK Platform 34
  - Android SDK Build-Tools
  - Android SDK Command-line Tools

### 3. Sistem Gereksinimleri
- Java JDK 11 veya üzeri
- Minimum 8GB RAM
- En az 10GB boş disk alanı

## 🔧 Proje Kurulumu

### Adım 1: Bağımlılıkları Yükle
```bash
cd /app
flutter pub get
```

### Adım 2: Flutter SDK Yolunu Ayarla
`android/local.properties` dosyasını düzenleyin:
```properties
flutter.sdk=/path/to/your/flutter/sdk
sdk.dir=/path/to/your/Android/sdk
```

### Adım 3: Android Build
```bash
# Debug APK oluştur
flutter build apk --debug

# Release APK oluştur (optimize edilmiş)
flutter build apk --release

# Split APK'lar (daha küçük boyut)
flutter build apk --split-per-abi
```

## 📱 APK Konumları

- **Debug APK**: `build/app/outputs/flutter-apk/app-debug.apk`
- **Release APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **Split APK'lar**: 
  - `app-armeabi-v7a-release.apk` (32-bit ARM)
  - `app-arm64-v8a-release.apk` (64-bit ARM)
  - `app-x86_64-release.apk` (64-bit Intel)

## 🔑 İmzalama (Production için)

### 1. Keystore Oluştur
```bash
keytool -genkey -v -keystore ~/tiktok-auto-scroller.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias tiktok-auto-scroller
```

### 2. key.properties Dosyası Oluştur
`android/key.properties` dosyası oluşturun:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=tiktok-auto-scroller
storeFile=/path/to/tiktok-auto-scroller.jks
```

### 3. build.gradle'ı Güncelle
`android/app/build.gradle` içinde:
```gradle
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}

buildTypes {
    release {
        signingConfig signingConfigs.release
        ...
    }
}
```

## 📲 Kurulum ve Test

### Android Cihaza Kurulum
```bash
# USB ile bağlı cihaza kur
adb install build/app/outputs/flutter-apk/app-release.apk

# Birden fazla cihaz varsa:
adb devices  # Cihaz ID'sini al
adb -s DEVICE_ID install app-release.apk
```

### Emulator'de Test
```bash
# Emulator'ü başlat
flutter emulators --launch <emulator_id>

# Uygulamayı çalıştır
flutter run
```

## 🧪 Test Senaryoları

### 1. İzin Testleri
- ✅ Overlay izninin doğru istendiğini kontrol edin
- ✅ Accessibility servisinin aktifleştiğini doğrulayın

### 2. Kaydırma Testleri
- ✅ TikTok uygulamasını açın
- ✅ Auto Scroller'ı başlatın
- ✅ Aşağı kaydırmanın çalıştığını kontrol edin
- ✅ Duraklat/Devam fonksiyonlarını test edin

### 3. Performans Testleri
- ✅ 10 kaydırma ile test edin
- ✅ 100 kaydırma ile test edin
- ✅ 1000+ kaydırma ile uzun süre test edin
- ✅ Batarya tüketimini gözlemleyin

## 🐛 Yaygın Sorunlar ve Çözümler

### Sorun 1: Flutter SDK bulunamıyor
```bash
# Flutter yolunu kontrol edin
which flutter
# Yoksa PATH'e ekleyin
export PATH="$PATH:/path/to/flutter/bin"
```

### Sorun 2: Gradle build hatası
```bash
# Gradle cache'i temizle
cd android
./gradlew clean

# Gradle wrapper'ı yeniden oluştur
gradle wrapper --gradle-version 8.0
```

### Sorun 3: AndroidX hatası
`android/gradle.properties` içinde:
```properties
android.useAndroidX=true
android.enableJetifier=true
```

### Sorun 4: Kotlin versiyonu uyumsuzluğu
`android/build.gradle` içinde Kotlin versiyonunu kontrol edin:
```gradle
ext.kotlin_version = '1.9.0'
```

## 📦 APK Boyutunu Küçültme

### 1. ProGuard/R8 Kullanın
`android/app/build.gradle` içinde:
```gradle
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
    }
}
```

### 2. Split APK Kullanın
```bash
flutter build apk --split-per-abi
```

### 3. App Bundle Oluşturun (Google Play için)
```bash
flutter build appbundle
```

## 🔍 Debug Komutları

### Logları İzleme
```bash
# Tüm loglar
adb logcat

# Sadece uygulama logları
adb logcat | grep TikTokAutoScroller

# Sadece hata logları
adb logcat *:E
```

### APK Bilgilerini Görüntüleme
```bash
# APK içeriğini listele
aapt dump badging app-release.apk

# APK boyutunu analiz et
aapt list -v -a app-release.apk
```

## 🚀 Production Checklist

- [ ] Release mode'da build alındı mı?
- [ ] APK imzalandı mı?
- [ ] Tüm izinler test edildi mi?
- [ ] Ana fonksiyonlar test edildi mi?
- [ ] Performans testi yapıldı mı?
- [ ] Batarya tüketimi kabul edilebilir mi?
- [ ] Uygulama ikonu eklendi mi?
- [ ] README.md güncellendi mi?

## 📞 Destek

Herhangi bir sorun yaşarsanız:
1. `flutter doctor` çalıştırın
2. Hata loglarını kontrol edin (`adb logcat`)
3. GitHub'da issue açın

---

**Son Güncelleme:** 2025
**Flutter Versiyonu:** 3.0.0+
**Minimum Android:** API 24 (Android 7.0)
