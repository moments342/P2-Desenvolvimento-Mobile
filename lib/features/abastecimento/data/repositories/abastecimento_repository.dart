import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/abastecimento_model.dart';

class AbastecimentoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _colecaoAbastecimentos(
    String usuarioId,
  ) {
    return _firestore
        .collection('usuarios')
        .doc(usuarioId)
        .collection('abastecimentos');
  }

  Stream<List<AbastecimentoModel>> listarAbastecimentosStream(
    String usuarioId,
  ) {
    return _colecaoAbastecimentos(
      usuarioId,
    ).orderBy('data', descending: true).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => AbastecimentoModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> adicionarAbastecimento(
    String usuarioId,
    AbastecimentoModel modelo,
  ) async {
    await _colecaoAbastecimentos(usuarioId).add(modelo.toMap());
  }

  Future<void> atualizarAbastecimento(
    String usuarioId,
    AbastecimentoModel modelo,
  ) async {
    if (modelo.id == null) return;
    await _colecaoAbastecimentos(
      usuarioId,
    ).doc(modelo.id!).update(modelo.toMap());
  }

  Future<void> excluirAbastecimento(
    String usuarioId,
    String abastecimentoId,
  ) async {
    await _colecaoAbastecimentos(usuarioId).doc(abastecimentoId).delete();
  }
}
