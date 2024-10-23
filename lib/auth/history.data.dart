import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(AuthHistory());

class AuthHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Flask PostgreSQL',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Flutter Flask PostgreSQL")),
        body: UserList(),
      ),
    );
  }
}

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<dynamic> users = []; // Menggunakan dynamic untuk fleksibilitas

  Future<void> fetchUsers() async {
    final url = Uri.parse('http://192.168.1.4:5000/history'); // URL Flask API
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return users.isEmpty // Menampilkan loading atau pesan jika data kosong
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(users[index]['input'] ?? 'No Input'),
                subtitle: Text(users[index]['hasil'] ?? 'No Hasil'),
                trailing: Text(users[index]['release'] ??
                    'No Release Info'), // Menampilkan informasi release
              );
            },
          );
  }
}
