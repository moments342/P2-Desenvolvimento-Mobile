import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../../../../core/theme/app_theme.dart';

class CadastroPage extends StatelessWidget {
  const CadastroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    final emailCtrl = TextEditingController();
    final senhaCtrl = TextEditingController();
    final confirmaCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.person_add,
              size: 90,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 20),

            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: senhaCtrl,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: confirmaCtrl,
              decoration: const InputDecoration(labelText: 'Confirmar senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            if (auth.erro != null)
              Text(auth.erro!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 10),

            auth.carregando
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      if (senhaCtrl.text != confirmaCtrl.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("As senhas não coincidem."),
                          ),
                        );
                        return;
                      }
                      auth.cadastrar(emailCtrl.text, senhaCtrl.text);
                    },
                    child: const Text('Cadastrar'),
                  ),
          ],
        ),
      ),
    );
  }
}
