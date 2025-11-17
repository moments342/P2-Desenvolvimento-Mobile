import 'package:flutter/material.dart';
import '/home/presentation/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          },
          child: const Text('Entrar (temporário)'),
        ),
      ),
    );
  }
}
