import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/veiculo_model.dart';

class VeiculoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _colecaoVeiculos(String usuarioId) {
    return _firestore
        .collection('usuarios')
        .doc(usuarioId)
        .collection('veiculos');
  }

  Stream<List<VeiculoModel>> listarVeiculosStream(String usuarioId) {
    return _colecaoVeiculos(usuarioId).orderBy('modelo').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => VeiculoModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> adicionarVeiculo(String usuarioId, VeiculoModel veiculo) async {
    await _colecaoVeiculos(usuarioId).add(veiculo.toMap());
  }

  Future<void> atualizarVeiculo(String usuarioId, VeiculoModel veiculo) async {
    if (veiculo.id == null) return;
    await _colecaoVeiculos(usuarioId).doc(veiculo.id!).update(veiculo.toMap());
  }

  Future<void> excluirVeiculo(String usuarioId, String veiculoId) async {
    await _colecaoVeiculos(usuarioId).doc(veiculoId).delete();
  }
}
