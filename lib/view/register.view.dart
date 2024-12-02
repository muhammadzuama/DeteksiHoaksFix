import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoaks/util/global.color.dart';
import 'package:hoaks/view/login.view.dart';
import 'package:http/http.dart' as http;

final TextEditingController usernameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController konfirmpasswordController = TextEditingController();

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> registerUser(BuildContext context) async {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = konfirmpasswordController.text.trim();

    // Validasi input
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showDialog(context, "Input Error", "Semua kolom harus diisi.");
      return;
    }
    if (!_isValidEmail(email)) {
      _showDialog(
          context, "Invalid Email", "Masukkan format email yang valid.");
      return;
    }
    if (password != confirmPassword) {
      _showDialog(context, "Invalid Password",
          "Password dan Konfirmasi Password Tidak Cocok");
      return;
    }

    // Data untuk dikirim ke backend
    Map<String, dynamic> data = {
      "name": username,
      "email": email,
      "password": password,
    };

    // URL endpoint API
    const String apiUrl = "http://192.168.1.4:5000/register";

    try {
      // Melakukan request POST
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      // Mengecek status response
      if (response.statusCode == 201) {
        // Menampilkan dialog berhasil registrasi
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Registrasi Berhasil"),
            content: const Text("Akun Anda berhasil dibuat! Silakan login."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Menutup dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        final responseData = jsonDecode(response.body);
        _showDialog(
            context, "Error", responseData["message"] ?? "Registrasi gagal");
      }
    } catch (e) {
      _showDialog(
          context, "Error", "Terjadi kesalahan saat mencoba mendaftar.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.background,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello! Register to get started',
                style: TextStyle(
                    color: GlobalColors.button,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 11),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildInputField(
                      'Username', usernameController, "Masukkan Username"),
                  const SizedBox(height: 15),
                  _buildInputField('Email', emailController, "Masukkan Email",
                      email: true),
                  const SizedBox(height: 15),
                  _buildPasswordField(
                      'Password', passwordController, "Masukkan Password",
                      isPassword: true, isVisible: _isPasswordVisible),
                  const SizedBox(height: 15),
                  _buildPasswordField('Konfirmasi Password',
                      konfirmpasswordController, "Konfirmasi Password",
                      isPassword: true, isVisible: _isConfirmPasswordVisible),
                  const SizedBox(height: 25),
                  _buildRegisterButton(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String label, TextEditingController controller, String hint,
      {bool email = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: TextField(
            controller: controller,
            keyboardType:
                email ? TextInputType.emailAddress : TextInputType.text,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 168, 168, 168)
                        .withOpacity(0.6)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 17)),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
      String label, TextEditingController controller, String hint,
      {required bool isPassword, required bool isVisible}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword ? !isVisible : false,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 15,
                color:
                    const Color.fromARGB(255, 168, 168, 168).withOpacity(0.6),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          if (label == 'Password') {
                            _isPasswordVisible = !_isPasswordVisible;
                          } else {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          }
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            backgroundColor: GlobalColors.button),
        onPressed: () => registerUser(context),
        child: const Text("REGISTER"),
      ),
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
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
}
