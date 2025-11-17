import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controle de Abastecimento')),
      body: const Center(child: Text('Tela inicial - Setup completo')),
    );
  }
}
