import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Page & Widget Gallery',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const ProfilePage(),
    );
  }
}

// ==========================================
// MODEL DATA PROFIL
// ==========================================
class ProfileData {
  String name;
  String bio;
  String education;
  String location;
  String contact;
  List<String> skills;
  Uint8List? imageBytes; // Ganti avatarPath -> imageBytes
  List<Experience> experiences;

  ProfileData({
    this.name = 'Yoan Pelalana',
    this.bio = 'GGMU.',
    this.education = 'Universitas Pasundan Semester 5\nIPK: 4.0',
    this.location = 'Bandung, Jawa Barat',
    this.contact = 'yoanpelalana13@gmail.com\n+62 822-1822-2209',
    List<String>? skills,
    this.imageBytes,
    List<Experience>? experiences,
  })  : skills = skills ?? ['Flutter', 'Dart', 'Firebase', 'Git', 'UI Design'],
        experiences = experiences ?? [];
}

class Experience {
  String title;
  String description;
  Uint8List? imageBytes; // Ganti imagePath -> imageBytes

  Experience({
    required this.title,
    required this.description,
    this.imageBytes,
  });
}

// Global state
final profileNotifier = ValueNotifier<ProfileData>(ProfileData());

// ==========================================
// PROFILE PAGE
// ==========================================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ProfileData>(
      valueListenable: profileNotifier,
      builder: (context, profile, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profil Saya'),
            backgroundColor: Colors.blue.shade100,
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text(
                    'Menu Utama',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Beranda'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.widgets),
                  title: const Text('Widget Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GalleryHome()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.upload_file),
                  title: const Text('Upload Pengalaman'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UploadExperiencePage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Pengaturan'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Pengaturan'),
                        content:
                        const Text('Halaman pengaturan akan segera hadir.'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK')),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // HEADER PROFIL
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue,
                        backgroundImage: profile.imageBytes != null
                            ? MemoryImage(profile.imageBytes!) as ImageProvider
                            : const NetworkImage(
                            'https://avatars.githubusercontent.com/u/145577127?s=400&u=de666534d517c3c06e19e42a5dff93a64edf37d8&v=4'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        profile.name,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mahasiswa Teknik Informatika',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // BARIS STATISTIK
                const Row(
                  children: [
                    Expanded(child: StatBox(label: 'Post', value: '13')),
                    Expanded(child: StatBox(label: 'Teman', value: '666')),
                    Expanded(child: StatBox(label: 'Like', value: '6.66M')),
                  ],
                ),
                const SizedBox(height: 24),

                // SECTION CARDS
                SectionCard(
                  icon: Icons.info_outline,
                  title: 'Tentang Saya',
                  content: profile.bio,
                ),
                SectionCard(
                  icon: Icons.school,
                  title: 'Pendidikan',
                  content: profile.education,
                ),
                SectionCard(
                  icon: Icons.location_on,
                  title: 'Lokasi',
                  content: profile.location,
                ),
                // SKILLS
                Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.star, color: Colors.blue),
                            SizedBox(width: 16),
                            Text('Skills',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: profile.skills
                              .map((s) => Chip(label: Text(s)))
                              .toList(),
                        )
                      ],
                    ),
                  ),
                ),
                SectionCard(
                  icon: Icons.email,
                  title: 'Kontak',
                  content: profile.contact,
                ),

                // SECTION PENGALAMAN
                if (profile.experiences.isNotEmpty) ...[
                  Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.work, color: Colors.blue),
                                  SizedBox(width: 16),
                                  Text('Pengalaman',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${profile.experiences.length}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...profile.experiences.map(
                                (exp) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: exp.imageBytes != null
                                        ? Image.memory(
                                      exp.imageBytes!,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    )
                                        : Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.image,
                                          color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(exp.title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 2),
                                        Text(exp.description,
                                            style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 80),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditProfilePage()),
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profil'),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: 1,
            onDestinationSelected: (int index) {},
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(
                  icon: Icon(Icons.person), label: 'Profil'),
              NavigationDestination(
                  icon: Icon(Icons.message), label: 'Pesan'),
              NavigationDestination(
                  icon: Icon(Icons.settings), label: 'Setting'),
            ],
          ),
        );
      },
    );
  }
}

// ==========================================
// EDIT PROFILE PAGE
// ==========================================
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _bioCtrl;
  late TextEditingController _educationCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _contactCtrl;
  late TextEditingController _skillsCtrl;

  Uint8List? _newImageBytes;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final p = profileNotifier.value;
    _nameCtrl = TextEditingController(text: p.name);
    _bioCtrl = TextEditingController(text: p.bio);
    _educationCtrl = TextEditingController(text: p.education);
    _locationCtrl = TextEditingController(text: p.location);
    _contactCtrl = TextEditingController(text: p.contact);
    _skillsCtrl = TextEditingController(text: p.skills.join(', '));
    _newImageBytes = p.imageBytes;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _educationCtrl.dispose();
    _locationCtrl.dispose();
    _contactCtrl.dispose();
    _skillsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() => _newImageBytes = bytes);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final skillsList = _skillsCtrl.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final updated = ProfileData(
      name: _nameCtrl.text.trim(),
      bio: _bioCtrl.text.trim(),
      education: _educationCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      contact: _contactCtrl.text.trim(),
      skills: skillsList,
      imageBytes: _newImageBytes,
      experiences: profileNotifier.value.experiences,
    );

    profileNotifier.value = updated;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil berhasil disimpan!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        actions: [
          TextButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Simpan'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // FOTO PROFIL
              Center(
                child: Column(
                  children: [
                    const Text('Foto Profil',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blue.shade100,
                          backgroundImage: _newImageBytes != null
                              ? MemoryImage(_newImageBytes!) as ImageProvider
                              : const NetworkImage(
                              'https://avatars.githubusercontent.com/u/145577127?s=400&u=de666534d517c3c06e19e42a5dff93a64edf37d8&v=4'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.blue,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.camera_alt,
                                  size: 16, color: Colors.white),
                              onPressed: _pickImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo_library, size: 16),
                      label: const Text('Ganti Foto dari Galeri'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 32),

              const Text(
                'Informasi Profil',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap *',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _bioCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Bio / Tentang',
                  prefixIcon: Icon(Icons.info_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _educationCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Pendidikan',
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _locationCtrl,
                decoration: const InputDecoration(
                  labelText: 'Lokasi',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _contactCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Kontak',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _skillsCtrl,
                decoration: const InputDecoration(
                  labelText: 'Skills (pisahkan dengan koma)',
                  prefixIcon: Icon(Icons.star),
                  border: OutlineInputBorder(),
                  hintText: 'Flutter, Dart, Firebase',
                ),
              ),
              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Perubahan'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// UPLOAD EXPERIENCE PAGE
// ==========================================
class UploadExperiencePage extends StatefulWidget {
  const UploadExperiencePage({super.key});

  @override
  State<UploadExperiencePage> createState() => _UploadExperiencePageState();
}

class _UploadExperiencePageState extends State<UploadExperiencePage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  Uint8List? _imageBytes;
  final _picker = ImagePicker();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() => _imageBytes = bytes);
    }
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul pengalaman wajib diisi!')),
      );
      return;
    }

    final newExp = Experience(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      imageBytes: _imageBytes,
    );

    final current = profileNotifier.value;
    profileNotifier.value = ProfileData(
      name: current.name,
      bio: current.bio,
      education: current.education,
      location: current.location,
      contact: current.contact,
      skills: current.skills,
      imageBytes: current.imageBytes,
      experiences: [...current.experiences, newExp],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pengalaman berhasil disimpan!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Pengalaman'),
        actions: [
          TextButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Simpan'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // AREA PILIH GAMBAR
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: _imageBytes != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(
                    _imageBytes!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate,
                        size: 48, color: Colors.blue.shade300),
                    const SizedBox(height: 8),
                    Text(
                      'Ketuk untuk pilih gambar',
                      style: TextStyle(color: Colors.blue.shade400),
                    ),
                    Text(
                      'dari galeri perangkat kamu',
                      style: TextStyle(
                          color: Colors.blue.shade300, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Informasi Pengalaman',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul *',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _descCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Pengalaman'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// HELPER WIDGETS
// ==========================================
class StatBox extends StatelessWidget {
  final String label;
  final String value;
  const StatBox({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

class SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  const SectionCard(
      {super.key,
        required this.icon,
        required this.title,
        required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blue, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(content, style: const TextStyle(height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// WIDGET GALLERY
// ==========================================
class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      ('Display', Icons.image, Colors.blue),
      ('Input', Icons.edit, Colors.green),
      ('Button', Icons.smart_button, Colors.orange),
      ('Feedback', Icons.notifications, Colors.purple),
      ('Layout', Icons.dashboard, Colors.teal),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Widget Gallery')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (context, i) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final (name, icon, color) = categories[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: Colors.white),
              ),
              title: Text(name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CategoryPage(name: name)),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String name;
  const CategoryPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (name) {
      case 'Display':
        body = const DisplayDemo();
        break;
      case 'Input':
        body = const InputDemo();
        break;
      case 'Button':
        body = const ButtonDemo();
        break;
      case 'Feedback':
        body = const FeedbackDemo();
        break;
      case 'Layout':
        body = const LayoutDemo();
        break;
      default:
        body = const Center(child: Text('?'));
    }

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16), child: body),
    );
  }
}

class DisplayDemo extends StatelessWidget {
  const DisplayDemo({super.key});
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Card & ListTile',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Card(
            child: ListTile(
                leading: Icon(Icons.album), title: Text('Judul Item'))),
        SizedBox(height: 16),
        Text('Chips', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(spacing: 8, children: [
          Chip(label: Text('Flutter')),
          Chip(label: Text('Dart'))
        ]),
        Divider(thickness: 2),
        CircleAvatar(child: Text('A')),
      ],
    );
  }
}

class InputDemo extends StatefulWidget {
  const InputDemo({super.key});
  @override
  State<InputDemo> createState() => _InputDemoState();
}

class _InputDemoState extends State<InputDemo> {
  bool _checked = false;
  double _slider = 0.5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextField(
            decoration: InputDecoration(
                labelText: 'Nama', border: OutlineInputBorder())),
        CheckboxListTile(
          title: const Text('Setuju Syarat'),
          value: _checked,
          onChanged: (v) => setState(() => _checked = v ?? false),
        ),
        Slider(
            value: _slider,
            onChanged: (v) => setState(() => _slider = v)),
      ],
    );
  }
}

class ButtonDemo extends StatelessWidget {
  const ButtonDemo({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
        OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
        FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Filled Icon')),
      ],
    );
  }
}

class FeedbackDemo extends StatelessWidget {
  const FeedbackDemo({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Halo!'))),
          child: const Text('Show SnackBar'),
        ),
        const LinearProgressIndicator(value: 0.7),
        const SizedBox(height: 20),
        const CircularProgressIndicator(),
      ],
    );
  }
}

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: Stack(
            children: [
              Container(color: Colors.blue.shade100),
              const Positioned(
                  bottom: 10,
                  right: 10,
                  child: Icon(Icons.star, size: 40)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          children:
          List.generate(5, (i) => Chip(label: Text('Item ${i + 1}'))),
        ),
      ],
    );
  }
}