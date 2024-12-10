import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<FileSystemEntity> _files = [];
  String? _selectedFileContent;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    try {
      // Meminta izin akses penyimpanan eksternal
      PermissionStatus permissionStatus = await Permission.storage.request();
      if (!permissionStatus.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Izin akses penyimpanan ditolak.")),
        );
        return;
      }

      // Mendapatkan direktori Downloads
      final directory = Directory(
          '/storage/emulated/0/Download'); // path untuk folder Download
      if (await directory.exists()) {
        final files = directory.listSync(); // List all files and directories
        setState(() {
          _files =
              files.where((file) => file is File).toList(); // Filter files only
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Folder Download tidak ditemukan.")),
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

  Future<void> _readFile(File file) async {
    try {
      final content = await file.readAsString();
      setState(() {
        _selectedFileContent = content;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal membaca file: $e")),
      );
    }
  }

  Future<void> _deleteFile(File file) async {
    try {
      await file.delete();
      setState(() {
        _files.remove(file);
        if (_selectedFileContent != null &&
            file.path.contains(_selectedFileContent!)) {
          _selectedFileContent = null;
        }
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
      appBar: AppBar(
        title: const Text("Histori File"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _files.isEmpty
              ? const Center(
                  child: Text(
                    "Tidak ada file yang tersedia.",
                    style: TextStyle(fontSize: 16.0),
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ListView.builder(
                        itemCount: _files.length,
                        itemBuilder: (context, index) {
                          final file = _files[index] as File;
                          return ListTile(
                            title: Text(
                              file.path.split('/').last,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteFile(file),
                            ),
                            onTap: () => _readFile(file),
                          );
                        },
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      flex: 3,
                      child: _selectedFileContent == null
                          ? const Center(
                              child: Text(
                                "Pilih file untuk melihat isi.",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                child: Text(
                                  _selectedFileContent!,
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }
}
