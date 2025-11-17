import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../veiculo/presentation/pages/veiculo_list_page.dart';
import '../../../abastecimento/presentation/pages/abastecimento_form_page.dart';
import '../../../abastecimento/presentation/pages/abastecimento_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _logout(BuildContext context) async {
    final auth = context.read<AuthController>();
    await auth.logout();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _abrirVeiculos(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VeiculoListPage()),
    );
  }

  void _registrarAbastecimento(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AbastecimentoFormPage()),
    );
  }

  void _historicoAbastecimentos(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AbastecimentoListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controle de Abastecimento')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Center(child: Icon(Icons.directions_car, size: 64)),
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Meus Veículos'),
              onTap: () {
                Navigator.pop(context);
                _abrirVeiculos(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_gas_station),
              title: const Text('Registrar Abastecimento'),
              onTap: () {
                Navigator.pop(context);
                _registrarAbastecimento(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Histórico de Abastecimentos'),
              onTap: () {
                Navigator.pop(context);
                _historicoAbastecimentos(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                Navigator.pop(context);
                _logout(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.directions_car_filled, size: 96),
            SizedBox(height: 16),
            Text(
              'Bem-vindo ao controle de veículos e abastecimentos!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
