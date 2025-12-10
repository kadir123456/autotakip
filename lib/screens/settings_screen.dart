import 'package:flutter/material.dart';

/// Ayarlar ekranı (ileride kullanılabilir)
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection(
            title: '🎯 Genel Ayarlar',
            children: [
              _buildSwitchTile(
                title: 'Bildirimler',
                subtitle: 'Kaydırma tamamlandığında bildir',
                value: true,
                onChanged: (value) {},
              ),
              _buildSwitchTile(
                title: 'Titreflim',
                subtitle: 'Her kaydırmada titreflet',
                value: false,
                onChanged: (value) {},
              ),
              _buildSwitchTile(
                title: 'Ses',
                subtitle: 'İşlemler için ses efektleri',
                value: false,
                onChanged: (value) {},
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          _buildSection(
            title: '📱 Uygulama Ayarları',
            children: [
              ListTile(
                leading: const Icon(Icons.apps, color: Colors.purple),
                title: const Text('Desteklenen Uygulamalar'),
                subtitle: const Text('TikTok, Instagram, YouTube, vb.'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showSupportedApps();
                },
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          _buildSection(
            title: 'ℹ️ Hakkında',
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.blue),
                title: const Text('Versiyon'),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.code, color: Colors.green),
                title: const Text('Gizlilik'),
                subtitle: const Text('Hiçbir veri toplanmaz'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2d2d44),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
  
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.purple,
    );
  }
  
  void _showSupportedApps() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2d2d44),
        title: const Text('Desteklenen Uygulamalar'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('✅ TikTok'),
            Text('✅ Instagram'),
            Text('✅ YouTube'),
            Text('✅ Facebook'),
            Text('✅ Twitter (X)'),
            Text('✅ Reddit'),
            SizedBox(height: 10),
            Text(
              'Ve diğer tüm kaydırılabilir uygulamalar!',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
}