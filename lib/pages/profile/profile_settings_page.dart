import 'package:flutter/material.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({
    super.key,
    required this.username,
    required this.isDarkMode,
    required this.onSave,
    required this.onThemeChanged,
  });

  final String username;
  final bool isDarkMode;
  final Future<void> Function(String) onSave;
  final Future<void> Function(bool) onThemeChanged;

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.username);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama tidak boleh kosong')));
      return;
    }

    await widget.onSave(name);
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Nama berhasil disimpan')));
  }

  @override
  Widget build(BuildContext context) {
    final greeting = widget.username.isEmpty
        ? 'Selamat Datang!'
        : 'Halo, ${widget.username}!';

    return Scaffold(
      appBar: AppBar(title: const Text('Profil & Pengaturan')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: ListView(
          children: [
            Text(
              greeting,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Atur nama dan preferensi tampilan aplikasi.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text(
              'Informasi akun',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline_rounded),
                labelText: 'Nama Pengguna',
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _saveName,
                icon: const Icon(Icons.save_outlined, size: 18),
                label: const Text('Simpan Nama'),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Preferensi tampilan',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Card(
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                title: const Text(
                  'Mode Gelap',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  widget.isDarkMode
                      ? 'Tema Gelap (Hitam)'
                      : 'Tema Terang (Putih)',
                ),
                secondary: Icon(
                  widget.isDarkMode
                      ? Icons.nightlight_round
                      : Icons.wb_sunny_outlined,
                ),
                value: widget.isDarkMode,
                onChanged: widget.onThemeChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
