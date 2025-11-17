import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final emailCtrl = TextEditingController();
  final senhaCtrl = TextEditingController();
  final confirmaCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Criar Conta")),
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
            const SizedBox(height: 16),

            TextField(
              controller: confirmaCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Confirmar senha"),
            ),
            const SizedBox(height: 20),

            if (auth.erro != null)
              Text(auth.erro!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 20),

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
                    child: const Text("Cadastrar"),
                  ),
          ],
        ),
      ),
    );
  }
}
