import 'package:flutter/material.dart';
import 'api_client.dart'; // Import repositori REST API Pertemuan 5

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa Cloud',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/form') {
          return MaterialPageRoute(
            builder: (_) => CatatanFormPage(initial: settings.arguments as Catatan?),
          );
        }
        if (settings.name == '/detail') {
          return MaterialPageRoute(
            builder: (_) => CatatanDetailPage(catatan: settings.arguments as Catatan),
          );
        }
        return null;
      },
    );
  }
}

// === MODEL DATA CATATAN ===
class Catatan {
  final int? id;
  final String judul;
  final String isi;
  final String kategori;
  final DateTime dibuatPada;

  Catatan({
    this.id,
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.dibuatPada,
  });

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'judul': judul,
    'isi': isi,
    'kategori': kategori,
    'dibuat_pada': dibuatPada.toUtc().toIso8601String(),
  };

  static Catatan fromJson(Map<String, dynamic> m) => Catatan(
    id: m['id'] as int?,
    judul: m['judul'] as String,
    isi: m['isi'] as String,
    kategori: m['kategori'] as String,
    dibuatPada: DateTime.parse(m['dibuat_pada'] as String).toLocal(),
  );

  Catatan copyWith({String? judul, String? isi, String? kategori}) => Catatan(
    id: id,
    judul: judul ?? this.judul,
    isi: isi ?? this.isi,
    kategori: kategori ?? this.kategori,
    dibuatPada: dibuatPada,
  );
}

// === HALAMAN UTAMA (HOME) ===
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Catatan>> _futureCatatan;

  String _kategoriTerpilih = 'Semua';
  final List<String> _daftarFilter = ['Semua', 'Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    _muatUlang();
  }

  void _muatUlang() {
    setState(() {
      _futureCatatan = ApiClient.instance.getAll();
    });
  }

  Future<void> _konfirmasiHapus(Catatan c) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.delete_forever, color: Colors.red, size: 40), // Ikon Grafis Asli
        title: const Text('Hapus Catatan Cloud?'),
        content: Text('Apakah Anda yakin ingin menghapus "${c.judul}" secara permanen dari server?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin == true) {
      try {
        await ApiClient.instance.delete(c.id!);
        _muatUlang();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${c.judul}" berhasil dihapus.')),
        );
      } on ApiException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Cloud Mahasiswa'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // IKON REFRESH ASLI
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
            onPressed: _muatUlang,
          ),
        ],
      ),
      body: Column(
        children: [
          // DROPDOWN FILTER DENGAN IKON PANAH BAWAH ASLI
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButtonFormField<String>(
              value: _kategoriTerpilih,
              icon: const Icon(Icons.arrow_drop_down), // Ikon Panah Bawah Asli
              decoration: const InputDecoration(
                labelText: 'Filter Berdasarkan Kategori',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.filter_list), // Ikon Filter Asli
              ),
              items: _daftarFilter.map((kat) {
                return DropdownMenuItem<String>(
                  value: kat,
                  child: Text(kat),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _kategoriTerpilih = value;
                  });
                }
              },
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: FutureBuilder<List<Catatan>>(
              future: _futureCatatan,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  final e = snapshot.error;
                  final pesan = e is ApiException ? e.message : 'Terjadi kesalahan: $e';
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(pesan, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _muatUlang,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                List<Catatan> data = snapshot.data ?? [];

                if (_kategoriTerpilih != 'Semua') {
                  data = data.where((c) => c.kategori.toLowerCase() == _kategoriTerpilih.toLowerCase()).toList();
                }

                if (data.isEmpty) {
                  return Center(
                    child: Text(
                      _kategoriTerpilih == 'Semua'
                          ? 'Belum ada data di server.\nKlik tombol + di bawah untuk menambahkan.'
                          : 'Tidak ada catatan dengan kategori "$_kategoriTerpilih".',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  itemCount: data.length,
                  itemBuilder: (_, i) {
                    final c = data[i];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: Text(c.kategori.isNotEmpty ? c.kategori[0] : '?'),
                        ),
                        title: Text(c.judul, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(c.isi, maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // IKON EDIT ASLI
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.indigo, size: 20),
                              tooltip: 'Edit Catatan',
                              onPressed: () async {
                                await Navigator.pushNamed(context, '/form', arguments: c);
                                _muatUlang();
                              },
                            ),
                            // IKON HAPUS ASLI
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                              tooltip: 'Hapus Catatan',
                              onPressed: () => _konfirmasiHapus(c),
                            ),
                          ],
                        ),
                        onTap: () async {
                          await Navigator.pushNamed(context, '/detail', arguments: c);
                          _muatUlang();
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // IKON FLOATING ACTION BUTTON ASLI (Icons.add)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, '/form');
          _muatUlang();
        },
        label: const Text('Tambah Catatan'),
        icon: const Icon(Icons.add), // Ikon Tambah Asli
      ),
    );
  }
}

// === HALAMAN DETAIL CATATAN LENGKAP ===
class CatatanDetailPage extends StatelessWidget {
  final Catatan catatan;
  const CatatanDetailPage({super.key, required this.catatan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan Cloud'),
        // TOMBOL BACK ASLI DI APPBAR DETAIL
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Text(
            catatan.judul,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Chip(
                avatar: const Icon(Icons.folder, size: 16),
                label: Text(catatan.kategori),
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Dibuat pada: ${catatan.dibuatPada.day}/${catatan.dibuatPada.month}/${catatan.dibuatPada.year} ${catatan.dibuatPada.hour.toString().padLeft(2, '0')}:${catatan.dibuatPada.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            ],
          ),
          const Divider(height: 30, thickness: 1),
          const Text(
            'Isi Catatan:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              catatan.isi,
              style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 30),
          FilledButton.icon(
            onPressed: () async {
              await Navigator.pushReplacementNamed(context, '/form', arguments: catatan);
            },
            icon: const Icon(Icons.edit),
            label: const Text('EDIT CATATAN INI'),
          ),
        ],
      ),
    );
  }
}

// === HALAMAN FORM UTAMA (TAMBAH & EDIT) ===
class CatatanFormPage extends StatefulWidget {
  final Catatan? initial;
  const CatatanFormPage({super.key, this.initial});

  @override
  State<CatatanFormPage> createState() => _CatatanFormPageState();
}

class _CatatanFormPageState extends State<CatatanFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtrl = TextEditingController();
  final _isiCtrl = TextEditingController();
  String _kategori = 'Kuliah';
  final List<String> _opsiKategori = ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];
  bool _sedangMenyimpan = false;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      _judulCtrl.text = widget.initial!.judul;
      _isiCtrl.text = widget.initial!.isi;
      if (_opsiKategori.contains(widget.initial!.kategori)) {
        _kategori = widget.initial!.kategori;
      }
    }
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.initial != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Catatan Cloud' : 'Tambah Catatan Cloud'),
        // TOMBOL BACK ASLI DI APPBAR FORM
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulCtrl,
              enabled: !_sedangMenyimpan,
              decoration: const InputDecoration(
                labelText: 'Judul Catatan',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Judul tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _kategori,
              icon: const Icon(Icons.arrow_drop_down),
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.folder_open),
              ),
              items: _opsiKategori.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: _sedangMenyimpan ? null : (v) => setState(() => _kategori = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _isiCtrl,
              maxLines: 5,
              enabled: !_sedangMenyimpan,
              decoration: const InputDecoration(
                labelText: 'Isi Catatan Lengkap',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Isi tidak boleh kosong' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: _sedangMenyimpan ? null : () async {
                  if (!_formKey.currentState!.validate()) return;
                  setState(() => _sedangMenyimpan = true);

                  try {
                    if (!isEdit) {
                      await ApiClient.instance.insert(Catatan(
                        judul: _judulCtrl.text.trim(),
                        isi: _isiCtrl.text.trim(),
                        kategori: _kategori,
                        dibuatPada: DateTime.now(),
                      ));
                    } else {
                      await ApiClient.instance.update(widget.initial!.copyWith(
                        judul: _judulCtrl.text.trim(),
                        isi: _isiCtrl.text.trim(),
                        kategori: _kategori,
                      ));
                    }

                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isEdit ? 'Catatan cloud diperbarui!' : 'Catatan berhasil dikirim ke cloud!')),
                    );
                    Navigator.pop(context);
                  } on ApiException catch (e) {
                    if (!mounted) return;
                    setState(() => _sedangMenyimpan = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal menyimpan ke server: ${e.message}')),
                    );
                  }
                },
                icon: _sedangMenyimpan
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Icon(isEdit ? Icons.save : Icons.cloud_upload),
                label: Text(_sedangMenyimpan ? 'MEMPROSES KONEKSI...' : (isEdit ? 'PERBARUI DATA SERVER' : 'KIRIM KE CLOUD SERVER')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}