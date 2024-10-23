import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hoaks/util/global.color.dart';
import 'package:hoaks/view/home.view.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    });
    return Scaffold(
        backgroundColor: GlobalColors.splashscreen,
        body: const Center(
          child: Image(
            image: AssetImage("images/logo.png"),
            width: 170,
            height: 170,
          ),
        ));
  }
}
