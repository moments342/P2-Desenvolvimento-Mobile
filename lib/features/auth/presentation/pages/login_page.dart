import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import 'cadastro_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final senhaCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "E-mail"),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: senhaCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Senha"),
            ),
            const SizedBox(height: 20),

            if (auth.erro != null)
              Text(auth.erro!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 16),

            auth.carregando
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      auth.login(emailCtrl.text, senhaCtrl.text);
                    },
                    child: const Text("Entrar"),
                  ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CadastroPage()),
                );
              },
              child: const Text("Criar conta"),
            ),
          ],
        ),
      ),
    );
  }
}
