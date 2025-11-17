import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/veiculo_model.dart';
import '../controllers/veiculo_controller.dart';
import '../../../../core/theme/app_theme.dart';

class VeiculoFormPage extends StatefulWidget {
  final VeiculoModel? veiculo;

  const VeiculoFormPage({super.key, this.veiculo});

  @override
  State<VeiculoFormPage> createState() => _VeiculoFormPageState();
}

class _VeiculoFormPageState extends State<VeiculoFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController modeloCtrl;
  late TextEditingController marcaCtrl;
  late TextEditingController placaCtrl;
  late TextEditingController anoCtrl;

  String tipoCombustivel = 'Gasolina';

  final List<String> combustiveis = ['Gasolina', 'Etanol', 'Diesel', 'Flex'];

  @override
  void initState() {
    super.initState();
    modeloCtrl = TextEditingController(text: widget.veiculo?.modelo ?? '');
    marcaCtrl = TextEditingController(text: widget.veiculo?.marca ?? '');
    placaCtrl = TextEditingController(text: widget.veiculo?.placa ?? '');
    anoCtrl = TextEditingController(text: widget.veiculo?.ano.toString() ?? '');
    tipoCombustivel = widget.veiculo?.tipoCombustivel.isNotEmpty == true
        ? widget.veiculo!.tipoCombustivel
        : 'Gasolina';
  }

  @override
  void dispose() {
    modeloCtrl.dispose();
    marcaCtrl.dispose();
    placaCtrl.dispose();
    anoCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = context.read<VeiculoController>();

    final novo = VeiculoModel(
      id: widget.veiculo?.id,
      modelo: modeloCtrl.text.trim(),
      marca: marcaCtrl.text.trim(),
      placa: placaCtrl.text.trim(),
      ano: int.tryParse(anoCtrl.text.trim()) ?? 0,
      tipoCombustivel: tipoCombustivel,
    );

    await controller.salvarVeiculo(novo);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<VeiculoController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.veiculo == null ? 'Novo Veículo' : 'Editar Veículo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              TextFormField(
                controller: modeloCtrl,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o modelo' : null,
              ),
              const SizedBox(height: 14),

              // Marca
              TextFormField(
                controller: marcaCtrl,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe a marca' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: placaCtrl,
                decoration: const InputDecoration(labelText: 'Placa'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe a placa' : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: anoCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Ano'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o ano' : null,
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                value: tipoCombustivel,
                items: combustiveis
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => tipoCombustivel = v);
                },
                decoration: const InputDecoration(
                  labelText: 'Tipo de combustível',
                ),
              ),

              const SizedBox(height: 20),

              if (controller.erro != null)
                Text(
                  controller.erro!,
                  style: const TextStyle(color: AppTheme.errorColor),
                ),

              const SizedBox(height: 12),

              controller.carregando
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _salvar,
                      child: Text(
                        widget.veiculo == null
                            ? 'Cadastrar'
                            : 'Salvar alterações',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
