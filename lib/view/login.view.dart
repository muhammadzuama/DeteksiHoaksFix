import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoaks/view/home.view.dart';
import 'package:http/http.dart' as http;
import 'package:hoaks/view/register.view.dart';
import 'package:hoaks/util/global.color.dart'; // Import halaman ProfilePage
import 'package:shared_preferences/shared_preferences.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginView(), // Set LoginView sebagai home
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey =
      GlobalKey<FormState>(); // Menambahkan GlobalKey untuk form validation

  Future<void> _login(BuildContext context) async {
    String email = emailController.text; // Use email instead of username
    String password = passwordController.text;

    if (!_formKey.currentState!.validate()) {
      return; // Jika validasi gagal, tidak lanjutkan login
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.4:5000/login'), // Your API endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'email': email, // Send email instead of username
          'password': password,
        }),
      );

      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200) {
        final user = data['user'];
        final userId = user['id'];
        final userName = user['name'];
        final userEmail = user['email'];

        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('user_id', userId);
        prefs.setString('user_name', userName);
        prefs.setString('user_email', userEmail);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(userId: userId),
          ),
        );
      } else {
        _showErrorDialog(context, data['message'] ?? 'Login failed');
      }
    } catch (e) {
      _showErrorDialog(
          context, "Terjadi kesalahan jaringan. Silakan coba lagi.");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Gagal"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.background,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: GlobalColors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 11),
                const Text(
                  'Selamat datang kembali yuk login biar bisa akses fitur kita',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Masukkan Email",
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: const Color.fromARGB(255, 168, 168, 168)
                                .withOpacity(0.6),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 17),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Password',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Masukkan Password",
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: const Color.fromARGB(255, 168, 168, 168)
                                .withOpacity(0.6),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 17),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: 110),
                    GestureDetector(
                      onTap: () {
                        print("Forgot Password");
                      },
                      child: const Text(
                        "Forgot Password ?",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 133, 143, 180),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => _login(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: GlobalColors.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Register(),
                        ));
                  },
                  child: const Text(
                    'Create an account',
                    style: TextStyle(
                      color: Colors.black12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
