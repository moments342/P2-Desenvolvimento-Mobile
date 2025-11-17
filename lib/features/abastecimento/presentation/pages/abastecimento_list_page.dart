import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/abastecimento_model.dart';
import '../controllers/abastecimento_controller.dart';
import '../../../veiculo/presentation/controllers/veiculo_controller.dart';
import '../../../veiculo/domain/models/veiculo_model.dart';
import 'abastecimento_form_page.dart';

class AbastecimentoListPage extends StatelessWidget {
  const AbastecimentoListPage({super.key});

  String _formatarData(DateTime data) {
    final d = data.day.toString().padLeft(2, '0');
    final m = data.month.toString().padLeft(2, '0');
    final y = data.year.toString();
    return '$d/$m/$y';
  }

  void _abrirFormulario(BuildContext context, [AbastecimentoModel? modelo]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AbastecimentoFormPage(abastecimento: modelo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final abastController = context.watch<AbastecimentoController>();
    final veiculoController = context.watch<VeiculoController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Abastecimentos')),
      body: StreamBuilder<List<VeiculoModel>>(
        stream: veiculoController.veiculosStream,
        builder: (context, veiculosSnapshot) {
          if (veiculosSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final veiculos = veiculosSnapshot.data ?? [];
          final mapaVeiculos = {for (var v in veiculos) v.id!: v};

          return StreamBuilder<List<AbastecimentoModel>>(
            stream: abastController.abastecimentosStream,
            builder: (context, abastSnapshot) {
              if (abastSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final lista = abastSnapshot.data ?? [];

              if (lista.isEmpty) {
                return const Center(
                  child: Text('Nenhum abastecimento registrado.'),
                );
              }

              return ListView.separated(
                itemCount: lista.length,
                separatorBuilder: (_, __) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  final a = lista[index];
                  final veiculo = mapaVeiculos[a.veiculoId];
                  final tituloVeiculo = veiculo == null
                      ? 'Veículo removido'
                      : '${veiculo.modelo} - ${veiculo.placa}';

                  return ListTile(
                    title: Text(tituloVeiculo),
                    subtitle: Text(
                      '${_formatarData(a.data)} • '
                      '${a.tipoCombustivel} • '
                      '${a.quantidadeLitros.toStringAsFixed(2)} L • '
                      'R\$ ${a.valorPago.toStringAsFixed(2)} • '
                      'Autonomia: ${a.quilometragem.toStringAsFixed(2)} km',
                    ),
                    onTap: () => _abrirFormulario(context, a),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await abastController.excluirAbastecimento(a.id!);
                      },
                    ),
                  );
                },
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
