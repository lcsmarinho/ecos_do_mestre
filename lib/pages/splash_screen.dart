import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Aguarda o primeiro frame renderizado para iniciar o timer de 3 segundos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacementNamed('/');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000), // Preto absoluto para AMOLED
      body: Center(
        child: Image.asset(
          'assets/images/logo_dev_9-16.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
