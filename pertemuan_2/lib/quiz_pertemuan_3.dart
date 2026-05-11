import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Tugas Mandiri 2: Theme Soft Color
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6750A4),
      ),
      home: const ProfilePage(),
    );
  }
}

// Model data sederhana untuk profil
class UserProfile {
  String name, bio, education, location, email;
  Uint8List? imageBytes;
  UserProfile({
    this.name = 'Yoan Pelalana',
    this.bio = 'Mahasiswa Teknik Informatika',
    this.education = 'Universitas Pasundan - Semester 5',
    this.location = 'Bandung, Jawa Barat',
    this.email = 'yoanpelalana13@gmail.com',
    this.imageBytes,
  });
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile myProfile = UserProfile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF6750A4)),
              child: Text('Menu Utama', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profil'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage(profile: myProfile)),
                );
                if (result != null) setState(() => myProfile = result);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              // Tugas Mandiri 5: AlertDialog Placeholder
              onTap: () => _showDialog(context),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Profil
            CircleAvatar(
              radius: 50,
              backgroundImage: myProfile.imageBytes != null
                  ? MemoryImage(myProfile.imageBytes!) as ImageProvider
                  : const NetworkImage('https://github.com/identicons/app.png'), // Tugas Mandiri 1
            ),
            const SizedBox(height: 12),
            Text(myProfile.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(myProfile.bio, style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 24),

            // Section Cards
            SectionCard(icon: Icons.school, title: 'Pendidikan', content: myProfile.education),
            SectionCard(icon: Icons.location_on, title: 'Lokasi', content: myProfile.location),
            SectionCard(icon: Icons.email, title: 'Kontak', content: myProfile.email),

            // Tugas Mandiri 3: Skills dengan Wrap & Chip
            const SectionCard(
              icon: Icons.star,
              title: 'Skills',
              content: '',
              child: Wrap(
                spacing: 8,
                children: [
                  Chip(label: Text('Flutter')),
                  Chip(label: Text('Dart')),
                  Chip(label: Text('UI/UX')),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      // Tugas Mandiri 4: FAB SnackBar
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Edit profil belum tersedia di tombol ini'))),
        label: const Text('Edit Profil'),
        icon: const Icon(Icons.edit),
      ),
      // Tugas Mandiri 6: NavigationBar Material 3
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pengaturan'),
        content: const Text('Fitur ini akan segera hadir.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))],
      ),
    );
  }
}

// ==========================================
// QUIZ: HALAMAN EDIT PROFIL
// ==========================================
class EditProfilePage extends StatefulWidget {
  final UserProfile profile;
  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  Uint8List? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _selectedImage = widget.profile.imageBytes;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() => _selectedImage = bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _selectedImage != null ? MemoryImage(_selectedImage!) : null,
                child: _selectedImage == null ? const Icon(Icons.camera_alt) : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                widget.profile.name = _nameController.text;
                widget.profile.imageBytes = _selectedImage;
                Navigator.pop(context, widget.profile);
              },
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Pendukung
class SectionCard extends StatelessWidget {
  final IconData icon;
  final String title, content;
  final Widget? child;
  const SectionCard({super.key, required this.icon, required this.title, required this.content, this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: child ?? Text(content),
      ),
    );
  }
}