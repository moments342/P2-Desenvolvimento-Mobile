import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/veiculo_model.dart';
import '../controllers/veiculo_controller.dart';

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

    final ano = int.tryParse(anoCtrl.text.trim()) ?? 0;

    final novoVeiculo = VeiculoModel(
      id: widget.veiculo?.id,
      modelo: modeloCtrl.text.trim(),
      marca: marcaCtrl.text.trim(),
      placa: placaCtrl.text.trim(),
      ano: ano,
      tipoCombustivel: tipoCombustivel,
    );

    final controller = context.read<VeiculoController>();
    await controller.salvarVeiculo(novoVeiculo);

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: modeloCtrl,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o modelo' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: marcaCtrl,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe a marca' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: placaCtrl,
                decoration: const InputDecoration(labelText: 'Placa'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe a placa' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: anoCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Ano'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o ano' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: tipoCombustivel,
                items: combustiveis
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (valor) {
                  if (valor != null) {
                    setState(() {
                      tipoCombustivel = valor;
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Tipo de combustível',
                ),
              ),
              const SizedBox(height: 20),
              if (controller.erro != null)
                Text(
                  controller.erro!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 10),
              controller.carregando
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _salvar,
                      child: const Text('Salvar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
