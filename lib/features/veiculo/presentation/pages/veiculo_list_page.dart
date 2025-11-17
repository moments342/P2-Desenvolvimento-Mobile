import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/veiculo_model.dart';
import '../controllers/veiculo_controller.dart';
import 'veiculo_form_page.dart';

class VeiculoListPage extends StatelessWidget {
  const VeiculoListPage({super.key});

  void _abrirFormulario(BuildContext context, [VeiculoModel? veiculo]) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => VeiculoFormPage(veiculo: veiculo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<VeiculoController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Meus Veículos')),
      body: StreamBuilder<List<VeiculoModel>>(
        stream: controller.veiculosStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final veiculos = snapshot.data ?? [];

          if (veiculos.isEmpty) {
            return const Center(child: Text('Nenhum veículo cadastrado.'));
          }

          return ListView.separated(
            itemCount: veiculos.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) {
              final v = veiculos[index];
              return ListTile(
                title: Text('${v.modelo} (${v.ano})'),
                subtitle: Text(
                  '${v.marca} • ${v.placa} • ${v.tipoCombustivel}',
                ),
                onTap: () => _abrirFormulario(context, v),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await controller.excluirVeiculo(v.id!);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
