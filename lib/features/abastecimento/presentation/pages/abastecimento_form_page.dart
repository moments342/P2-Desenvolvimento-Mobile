import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/abastecimento_model.dart';
import '../controllers/abastecimento_controller.dart';
import '../../../veiculo/presentation/controllers/veiculo_controller.dart';
import '../../../veiculo/domain/models/veiculo_model.dart';
import '../../../../core/theme/app_theme.dart';

class AbastecimentoFormPage extends StatefulWidget {
  final AbastecimentoModel? abastecimento;

  const AbastecimentoFormPage({super.key, this.abastecimento});

  @override
  State<AbastecimentoFormPage> createState() => _AbastecimentoFormPageState();
}

class _AbastecimentoFormPageState extends State<AbastecimentoFormPage> {
  final _formKey = GlobalKey<FormState>();

  DateTime? dataSelecionada;
  late TextEditingController quantidadeCtrl;
  late TextEditingController valorCtrl;
  late TextEditingController consumoCtrl;
  late TextEditingController observacaoCtrl;
  late TextEditingController quilometragemCalculadaCtrl;

  String tipoCombustivel = 'Gasolina';
  String? veiculoSelecionadoId;

  final List<String> combustiveis = ['Gasolina', 'Etanol', 'Diesel', 'Flex'];

  @override
  void initState() {
    super.initState();

    final ab = widget.abastecimento;

    dataSelecionada = ab?.data ?? DateTime.now();

    quantidadeCtrl = TextEditingController(
      text: ab != null ? ab.quantidadeLitros.toString() : '',
    );
    valorCtrl = TextEditingController(
      text: ab != null ? ab.valorPago.toString() : '',
    );
    consumoCtrl = TextEditingController(
      text: ab != null ? ab.consumo.toString() : '',
    );
    observacaoCtrl = TextEditingController(
      text: ab != null ? ab.observacao ?? '' : '',
    );
    tipoCombustivel = ab?.tipoCombustivel ?? 'Gasolina';
    veiculoSelecionadoId = ab?.veiculoId;

    final litros = double.tryParse(quantidadeCtrl.text) ?? 0;
    final consumo = double.tryParse(consumoCtrl.text) ?? 0;

    final kmCalc = litros * consumo;

    quilometragemCalculadaCtrl = TextEditingController(
      text: kmCalc.toStringAsFixed(2),
    );

    quantidadeCtrl.addListener(_recalcularQuilometragem);
    consumoCtrl.addListener(_recalcularQuilometragem);
  }

  @override
  void dispose() {
    quantidadeCtrl.dispose();
    valorCtrl.dispose();
    consumoCtrl.dispose();
    observacaoCtrl.dispose();
    quilometragemCalculadaCtrl.dispose();
    super.dispose();
  }

  void _recalcularQuilometragem() {
    final litros = double.tryParse(quantidadeCtrl.text) ?? 0;
    final consumo = double.tryParse(consumoCtrl.text) ?? 0;

    final km = litros * consumo;

    quilometragemCalculadaCtrl.text = km.toStringAsFixed(2);
  }

  String _formatarData(DateTime data) {
    return "${data.day.toString().padLeft(2, '0')}/"
        "${data.month.toString().padLeft(2, '0')}/"
        "${data.year}";
  }

  Future<void> _selecionarData() async {
    final novaData = await showDatePicker(
      context: context,
      initialDate: dataSelecionada ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (novaData != null) {
      setState(() => dataSelecionada = novaData);
    }
  }

  Future<void> _salvar(AbastecimentoController controller) async {
    if (!_formKey.currentState!.validate()) return;

    if (veiculoSelecionadoId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Selecione um veículo")));
      return;
    }

    final litros = double.tryParse(quantidadeCtrl.text.trim()) ?? 0.0;
    final valor = double.tryParse(valorCtrl.text.trim()) ?? 0.0;
    final consumo = double.tryParse(consumoCtrl.text.trim()) ?? 0.0;
    final km = double.tryParse(quilometragemCalculadaCtrl.text) ?? 0.0;

    final novo = AbastecimentoModel(
      id: widget.abastecimento?.id,
      data: dataSelecionada!,
      quantidadeLitros: litros,
      valorPago: valor,
      quilometragem: km.toInt(),
      tipoCombustivel: tipoCombustivel,
      veiculoId: veiculoSelecionadoId!,
      consumo: consumo,
      observacao: observacaoCtrl.text.trim().isEmpty
          ? null
          : observacaoCtrl.text.trim(),
    );

    await controller.salvarAbastecimento(novo);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final veiculosController = context.watch<VeiculoController>();
    final abastController = context.watch<AbastecimentoController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.abastecimento == null
              ? "Registrar Abastecimento"
              : "Editar Abastecimento",
        ),
      ),
      body: StreamBuilder<List<VeiculoModel>>(
        stream: veiculosController.veiculosStream,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final veiculos = snap.data ?? [];

          if (veiculos.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum veículo cadastrado.\nCadastre um veículo primeiro.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          veiculoSelecionadoId ??= veiculos.first.id;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // DATA
                  TextFormField(
                    readOnly: true,
                    onTap: _selecionarData,
                    decoration: const InputDecoration(
                      labelText: "Data",
                      suffixIcon: Icon(Icons.calendar_month),
                    ),
                    controller: TextEditingController(
                      text: _formatarData(dataSelecionada!),
                    ),
                  ),
                  const SizedBox(height: 14),

                  DropdownButtonFormField<String>(
                    value: veiculoSelecionadoId,
                    items: veiculos
                        .map(
                          (v) => DropdownMenuItem(
                            value: v.id,
                            child: Text("${v.modelo} - ${v.placa}"),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => veiculoSelecionadoId = v),
                    decoration: const InputDecoration(labelText: "Veículo"),
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: quantidadeCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: "Quantidade (litros)",
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Informe os litros" : null,
                  ),
                  const SizedBox(height: 14),

                  // Valor
                  TextFormField(
                    controller: valorCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: "Valor pago (R\$)",
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Informe o valor" : null,
                  ),
                  const SizedBox(height: 14),

                  DropdownButtonFormField<String>(
                    value: tipoCombustivel,
                    items: combustiveis
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => tipoCombustivel = v ?? tipoCombustivel),
                    decoration: const InputDecoration(
                      labelText: "Tipo de combustível",
                    ),
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: consumoCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: "Consumo (km/L)",
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Informe o consumo" : null,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: quilometragemCalculadaCtrl,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Quilometragem (calculada)",
                    ),
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: observacaoCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: "Observação (opcional)",
                    ),
                  ),
                  const SizedBox(height: 18),

                  if (abastController.erro != null)
                    Text(
                      abastController.erro!,
                      style: const TextStyle(
                        color: AppTheme.errorColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  const SizedBox(height: 12),

                  abastController.carregando
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => _salvar(abastController),
                          child: Text(
                            widget.abastecimento == null
                                ? "Registrar"
                                : "Salvar alterações",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
