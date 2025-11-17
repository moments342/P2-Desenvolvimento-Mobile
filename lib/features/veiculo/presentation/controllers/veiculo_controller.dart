import 'package:flutter/material.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/repositories/veiculo_repository.dart';
import '../../domain/models/veiculo_model.dart';

class VeiculoController extends ChangeNotifier {
  final VeiculoRepository _repository;
  final AuthController _authController;

  VeiculoController(this._repository, this._authController);

  bool carregando = false;
  String? erro;

  String? get _usuarioId => _authController.usuario?.id;

  Stream<List<VeiculoModel>> get veiculosStream {
    final uid = _usuarioId;
    if (uid == null) {
      return const Stream.empty();
    }
    return _repository.listarVeiculosStream(uid);
  }

  Future<void> salvarVeiculo(VeiculoModel veiculo) async {
    final uid = _usuarioId;
    if (uid == null) return;

    try {
      carregando = true;
      erro = null;
      notifyListeners();

      if (veiculo.id == null) {
        await _repository.adicionarVeiculo(uid, veiculo);
      } else {
        await _repository.atualizarVeiculo(uid, veiculo);
      }
    } catch (e) {
      erro = "Erro ao salvar veículo.";
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> excluirVeiculo(String veiculoId) async {
    final uid = _usuarioId;
    if (uid == null) return;

    try {
      carregando = true;
      erro = null;
      notifyListeners();

      await _repository.excluirVeiculo(uid, veiculoId);
    } catch (e) {
      erro = "Erro ao excluir veículo.";
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
