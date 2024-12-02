import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(AuthUser());

class AuthUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  List users = [];

  Future<void> fetchUsers() async {
    var url = Uri.parse('http://192.168.1.7:5000/users'); // URL Flask API
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        // Akses kunci 'users' dari respons JSON
        users = json.decode(response.body)['users'];
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
    return users.isEmpty
        ? Center(
            child:
                CircularProgressIndicator()) // Tampilkan loader jika data belum dimuat
        : ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(users[index]['name']),
                subtitle: Text(users[index]['email']),
              );
            },
          );
  }
}
