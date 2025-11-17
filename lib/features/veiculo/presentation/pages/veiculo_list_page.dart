import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/veiculo_model.dart';
import '../controllers/veiculo_controller.dart';
import 'veiculo_form_page.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';

class VeiculoListPage extends StatelessWidget {
  const VeiculoListPage({super.key});

  void _abrirFormulario(BuildContext context, [VeiculoModel? veiculo]) {
    AppNavigator.navigateTo(context, VeiculoFormPage(veiculo: veiculo));
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<VeiculoController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meus Veículos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<List<VeiculoModel>>(
        stream: controller.veiculosStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final veiculos = snapshot.data ?? [];

          if (veiculos.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum veículo cadastrado.',
                style: TextStyle(fontSize: 16, color: AppTheme.secondaryColor),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: veiculos.length,
            itemBuilder: (context, index) {
              final v = veiculos[index];

              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 350 + (index * 80)),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: 0.9 + (value * 0.1),
                      child: child,
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    leading: const Icon(
                      Icons.directions_car,
                      size: 32,
                      color: AppTheme.secondaryColor,
                    ),
                    title: Text(
                      '${v.modelo} (${v.ano})',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    subtitle: Text(
                      '${v.marca} • ${v.placa} • ${v.tipoCombustivel}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    onTap: () => _abrirFormulario(context, v),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: AppTheme.errorColor,
                      ),
                      onPressed: () => controller.excluirVeiculo(v.id!),
                    ),
                  ),
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
