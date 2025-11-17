import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/abastecimento_model.dart';
import '../controllers/abastecimento_controller.dart';
import '../../../veiculo/presentation/controllers/veiculo_controller.dart';
import '../../../veiculo/domain/models/veiculo_model.dart';
import 'abastecimento_form_page.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/navigation/app_navigator.dart';

class AbastecimentoListPage extends StatelessWidget {
  const AbastecimentoListPage({super.key});

  String _formatarData(DateTime data) {
    return "${data.day.toString().padLeft(2, '0')}/"
        "${data.month.toString().padLeft(2, '0')}/"
        "${data.year}";
  }

  void _abrirFormulario(BuildContext context, [AbastecimentoModel? ab]) {
    AppNavigator.navigateTo(context, AbastecimentoFormPage(abastecimento: ab));
  }

  @override
  Widget build(BuildContext context) {
    final abastController = context.watch<AbastecimentoController>();
    final veiculoController = context.watch<VeiculoController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Histórico de Abastecimentos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<List<VeiculoModel>>(
        stream: veiculoController.veiculosStream,
        builder: (context, veicSnap) {
          if (veicSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final veiculos = veicSnap.data ?? [];
          final mapaVeiculos = {for (var v in veiculos) v.id!: v};

          return StreamBuilder<List<AbastecimentoModel>>(
            stream: abastController.abastecimentosStream,
            builder: (context, abastSnap) {
              if (abastSnap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final lista = abastSnap.data ?? [];

              if (lista.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhum abastecimento registrado.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: lista.length,
                itemBuilder: (context, index) {
                  final a = lista[index];
                  final veiculo = mapaVeiculos[a.veiculoId];

                  final titulo = veiculo == null
                      ? 'Veículo removido'
                      : '${veiculo.modelo} - ${veiculo.placa}';

                  final infoPrincipal =
                      '${_formatarData(a.data)} • '
                      '${a.tipoCombustivel} • '
                      '${a.quantidadeLitros.toStringAsFixed(2)} L • '
                      'R\$ ${a.valorPago.toStringAsFixed(2)} • '
                      '${a.quilometragem} km';

                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 350 + (index * 70)),
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
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 18,
                        ),
                        leading: const Icon(
                          Icons.local_gas_station,
                          size: 32,
                          color: AppTheme.secondaryColor,
                        ),
                        title: Text(
                          titulo,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(infoPrincipal),
                            if (a.observacao != null &&
                                a.observacao!.trim().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  'Observação: ${a.observacao}',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        onTap: () => _abrirFormulario(context, a),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: AppTheme.errorColor,
                          ),
                          onPressed: () =>
                              abastController.excluirAbastecimento(a.id!),
                        ),
                      ),
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
