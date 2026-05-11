import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: const Center(
        child: Text('Konten Utama', style: TextStyle(fontSize: 18)),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Ikon 1 — coba ganti Icons.home dengan ikon lain
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.home, size: 32, color: Colors.red),     // ← merah
                Text('Home', style: TextStyle(fontSize: 12)),
              ],
            ),
            // Ikon 2
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.receipt_long, size: 32, color: Colors.green), // ← hijau
                Text('Order', style: TextStyle(fontSize: 12)),
              ],
            ),
            // Ikon 3
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person, size: 32, color: Colors.purple),  // ← ungu
                Text('Profil', style: TextStyle(fontSize: 12)),
              ],
            ),
            // Ikon 4
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.settings, size: 48),  // ← coba size berbeda
                Text('Seting', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    ),
  ));
}