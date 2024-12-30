import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hoaks/util/global.color.dart';
import 'package:permission_handler/permission_handler.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<FileSystemEntity> _files = [];
  bool _isLoading = true;
  late Directory _hoaxDirectory;

  @override
  void initState() {
    super.initState();
    _initializeDirectory();
  }

  Future<void> _initializeDirectory() async {
    try {
      // Meminta izin akses penyimpanan
      PermissionStatus permissionStatus = await Permission.storage.request();
      if (!permissionStatus.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Izin akses penyimpanan ditolak.")),
        );
        return;
      }

      // Mengakses atau membuat folder "Deteksi Hoaks" di Downloads
      final downloadDir = Directory('/storage/emulated/0/Download');
      _hoaxDirectory = Directory('${downloadDir.path}/Deteksi Hoaks');

      if (!(await _hoaxDirectory.exists())) {
        await _hoaxDirectory.create(recursive: true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Folder 'Deteksi Hoaks' berhasil dibuat.")),
        );
      }

      // Memuat file di folder
      _loadFiles();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengakses folder: $e")),
      );
    }
  }

  Future<void> _loadFiles() async {
    try {
      if (await _hoaxDirectory.exists()) {
        final files = _hoaxDirectory.listSync();
        setState(() {
          _files = files.where((file) => file is File).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Folder 'Deteksi Hoaks' tidak ditemukan.")),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat file: $e")),
      );
    }
  }

  Future<void> _deleteFile(File file) async {
    try {
      await file.delete();
      setState(() {
        _files.remove(file);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("File berhasil dihapus.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus file: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: GlobalColors.button,
        title: const Text(
          "Histori File",
          style: TextStyle(color: Colors.white),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.refresh),
        //     onPressed: _loadFiles,
        //   ),
        // ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _files.isEmpty
              ? const Center(
                  child: Text(
                    "Tidak ada file di folder 'Deteksi Hoaks'.",
                    style: TextStyle(fontSize: 16.0),
                  ),
                )
              : ListView.builder(
                  itemCount: _files.length,
                  itemBuilder: (context, index) {
                    final file = _files[index] as File;
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        leading:
                            Icon(Icons.description, color: GlobalColors.button),
                        title: Text(
                          file.path.split('/').last,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          file.path,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12.0, color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteFile(file),
                        ),
                        onTap: () async {
                          final content = await file.readAsString();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FileContentPage(content: content),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class FileContentPage extends StatelessWidget {
  final String content;

  FileContentPage({required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Isi File"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontSize: 16.0),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}
