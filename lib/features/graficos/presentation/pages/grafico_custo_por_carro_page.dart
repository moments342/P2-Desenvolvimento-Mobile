import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../abastecimento/domain/models/abastecimento_model.dart';
import '../../../abastecimento/presentation/controllers/abastecimento_controller.dart';
import '../../../veiculo/presentation/controllers/veiculo_controller.dart';
import '../../../veiculo/domain/models/veiculo_model.dart';
import '../../../../core/theme/app_theme.dart';

class GraficoCustoPorCarroPage extends StatelessWidget {
  const GraficoCustoPorCarroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final abastecimentoController = context.watch<AbastecimentoController>();
    final veiculoController = context.watch<VeiculoController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gráfico de Custos por Veículo',
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

          return StreamBuilder<List<AbastecimentoModel>>(
            stream: abastecimentoController.abastecimentosStream,
            builder: (context, abastSnap) {
              if (abastSnap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final abastecimentos = abastSnap.data ?? [];

              if (veiculos.isEmpty || abastecimentos.isEmpty) {
                return const Center(
                  child: Text(
                    'Dados insuficientes para gerar o gráfico.',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              final Map<String, double> custoPorCarro = {};
              final Map<String, VeiculoModel> mapaCarros = {
                for (var v in veiculos) v.id!: v,
              };

              for (var a in abastecimentos) {
                custoPorCarro[a.veiculoId] =
                    (custoPorCarro[a.veiculoId] ?? 0) + a.valorPago;
              }

              if (custoPorCarro.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhum custo encontrado para os veículos.',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              final List<String> labels = [];
              final List<double> valores = [];

              custoPorCarro.forEach((veiculoId, total) {
                final v = mapaCarros[veiculoId];
                if (v != null) {
                  labels.add('${v.modelo} - ${v.placa}');
                  valores.add(total);
                }
              });

              if (labels.isEmpty) {
                return const Center(
                  child: Text(
                    'Não foi possível associar custos aos veículos.',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              final double maxY = valores.reduce((a, b) => a > b ? a : b) * 1.2;

              return Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Total gasto (R\$) por veículo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: true),
                          barGroups: List.generate(valores.length, (i) {
                            return BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: valores[i],
                                  color: AppTheme.primaryColor,
                                  width: 26,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            );
                          }),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index < 0 || index >= labels.length) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      labels[index],
                                      style: const TextStyle(fontSize: 11),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                                reservedSize: 60,
                              ),
                            ),
                          ),

                          maxY: maxY > 0 ? maxY : 100,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildEstatisticas(custoPorCarro, mapaCarros),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEstatisticas(
    Map<String, double> custos,
    Map<String, VeiculoModel> carros,
  ) {
    if (custos.isEmpty) return const SizedBox.shrink();

    final valores = custos.values.toList();
    final total = valores.reduce((a, b) => a + b);
    final media = total / valores.length;

    final maisCaroEntry = custos.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    final carroMaisCaro = carros[maisCaroEntry.key];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Gasto total: R\$ ${total.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.secondaryColor,
          ),
        ),
        Text('Média por veículo: R\$ ${media.toStringAsFixed(2)}'),
        if (carroMaisCaro != null)
          Text(
            'Veículo com maior gasto: ${carroMaisCaro.modelo} - ${carroMaisCaro.placa}',
          ),
      ],
    );
  }
}
