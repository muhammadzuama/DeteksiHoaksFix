import 'package:flutter/material.dart';
import 'package:hoaks/util/global.color.dart';
import 'package:hoaks/view/login.view.dart';

String username = "";
String password = "";
final TextEditingController usernameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController konfirmpasswordController = TextEditingController();

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.background,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 32),
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
              SizedBox(
                height: 11,
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Username ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Masukkan Username ",
                          hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 168, 168, 168)
                                  .withOpacity(0.6)),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 17)),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Password',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Masukkan Password",
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 168, 168, 168)
                              .withOpacity(0.6),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                      ),
                      obscureText: true, // Menampilkan inputan sebagai password
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Konfirmasi Password',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: konfirmpasswordController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Konfirmasi Password",
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 168, 168, 168)
                              .withOpacity(0.6),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                      ),
                      obscureText: true, // Menampilkan inputan sebagai password
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            backgroundColor: GlobalColors.button),
                        onPressed: () {
                          String inputusername = usernameController
                              .text; // Mengambil nilai inputan email
                          String inputpassword = passwordController.text;
                          String password2 = konfirmpasswordController.text;
                          if (inputpassword != password2) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("Invalid Password"),
                                      content: Text(
                                          "Password dan Konfrirmasi Password Tidak cocok"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("OK"),
                                        )
                                      ],
                                    ));
                          } else {
                            username = inputusername;
                            password = inputpassword;
                            print("Username: $username");
                            print("Password: $password");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginView()),
                            );
                          }
                          // Mengambil nilai inputan password
                        },
                        child: Text(
                          "REGISTER",
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
