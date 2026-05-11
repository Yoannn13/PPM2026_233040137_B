import 'package:flutter/material.dart';

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
// LANGKAH 2 & 4: PROFILE PAGE
// ==========================================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.blue.shade100,
        actions: [
          IconButton(
            icon: const Icon(Icons.search), // Eksperimen Langkah 2
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
            // LANGKAH 5.1: Navigasi ke Gallery
            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GalleryHome()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                // TUGAS MANDIRI 5: Alert Dialog Placeholder
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pengaturan'),
                    content: const Text('Halaman pengaturan akan segera hadir.'),
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
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    // TUGAS MANDIRI 1: Menggunakan NetworkImage
                    backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/145577127?s=400&u=de666534d517c3c06e19e42a5dff93a64edf37d8&v=4'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Yoan Pelalana',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mahasiswa Teknik Informatika',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
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
            const SectionCard(
              icon: Icons.info_outline,
              title: 'Tentang Saya',
              content: 'GGMU.',
            ),
            const SectionCard(
              icon: Icons.school,
              title: 'Pendidikan',
              content: 'Universitas Pasundan Semester 5\nIPK: 4.0',
            ),
            // TUGAS MANDIRI 3: Section Skills dengan Wrap & Chip
            const Card(
              margin: EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.blue),
                        SizedBox(width: 16),
                        Text('Skills', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        Chip(label: Text('Flutter')),
                        Chip(label: Text('Dart')),
                        Chip(label: Text('Firebase')),
                        Chip(label: Text('Git')),
                        Chip(label: Text('UI Design')),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SectionCard(
              icon: Icons.email,
              title: 'Kontak',
              content: 'yoanpelalana13@gmail.com\n+62 822-1822-2209',
            ),
            const SizedBox(height: 80), // Ruang agar tidak tertutup FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TUGAS MANDIRI 4: SnackBar pada FAB
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Edit profil belum tersedia')),
          );
        },
        child: const Icon(Icons.edit),
      ),
      // TUGAS MANDIRI 6: NavigationBar (Material 3)
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (int index) {},
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
          NavigationDestination(icon: Icon(Icons.message), label: 'Pesan'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    );
  }
}

// HELPER WIDGETS (Langkah 4)
class StatBox extends StatelessWidget {
  final String label;
  final String value;
  const StatBox({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
  const SectionCard({super.key, required this.icon, required this.title, required this.content});

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
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
// LANGKAH 5: WIDGET GALLERY
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
                MaterialPageRoute(builder: (context) => CategoryPage(name: name)),
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
      case 'Display': body = const DisplayDemo(); break;
      case 'Input': body = const InputDemo(); break;
      case 'Button': body = const ButtonDemo(); break;
      case 'Feedback': body = const FeedbackDemo(); break;
      case 'Layout': body = const LayoutDemo(); break;
      default: body = const Center(child: Text('?'));
    }

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: body),
    );
  }
}

// DEMO PER KATEGORI
class DisplayDemo extends StatelessWidget {
  const DisplayDemo({super.key});
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Card & ListTile', style: TextStyle(fontWeight: FontWeight.bold)),
        Card(child: ListTile(leading: Icon(Icons.album), title: Text('Judul Item'))),
        SizedBox(height: 16),
        Text('Chips', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(spacing: 8, children: [Chip(label: Text('Flutter')), Chip(label: Text('Dart'))]),
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
        const TextField(decoration: InputDecoration(labelText: 'Nama', border: OutlineInputBorder())),
        CheckboxListTile(
          title: const Text('Setuju Syarat'),
          value: _checked,
          onChanged: (v) => setState(() => _checked = v ?? false),
        ),
        Slider(value: _slider, onChanged: (v) => setState(() => _slider = v)),
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
        FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('Filled Icon')),
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
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Halo!'))),
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
              const Positioned(bottom: 10, right: 10, child: Icon(Icons.star, size: 40)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          children: List.generate(5, (i) => Chip(label: Text('Item ${i + 1}'))),
        ),
      ],
    );
  }
}