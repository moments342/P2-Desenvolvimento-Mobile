import 'package:flutter/material.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/repositories/abastecimento_repository.dart';
import '../../domain/models/abastecimento_model.dart';

class AbastecimentoController extends ChangeNotifier {
  final AbastecimentoRepository _repository;
  final AuthController _authController;

  AbastecimentoController(this._repository, this._authController);

  bool carregando = false;
  String? erro;

  String? get _usuarioId => _authController.usuario?.id;

  Stream<List<AbastecimentoModel>> get abastecimentosStream {
    final uid = _usuarioId;
    if (uid == null) return const Stream.empty();
    return _repository.listarAbastecimentosStream(uid);
  }

  Future<void> salvarAbastecimento(AbastecimentoModel modelo) async {
    final uid = _usuarioId;
    if (uid == null) return;

    try {
      carregando = true;
      erro = null;
      notifyListeners();

      if (modelo.id == null) {
        await _repository.adicionarAbastecimento(uid, modelo);
      } else {
        await _repository.atualizarAbastecimento(uid, modelo);
      }
    } catch (e) {
      erro = 'Erro ao salvar abastecimento.';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> excluirAbastecimento(String abastecimentoId) async {
    final uid = _usuarioId;
    if (uid == null) return;

    try {
      carregando = true;
      erro = null;
      notifyListeners();

      await _repository.excluirAbastecimento(uid, abastecimentoId);
    } catch (e) {
      erro = 'Erro ao excluir abastecimento.';
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
