import 'package:flutter/material.dart';
import '../../../auth/data/repositories/auth_repository.dart';
import '../../../auth/domain/models/usuario_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _repository;

  AuthController(this._repository) {
    _repository.usuarioStream.listen((user) {
      if (user != null) {
        usuario = UsuarioModel.fromFirebase(user.uid, user.email ?? "");
      } else {
        usuario = null;
      }
      notifyListeners();
    });
  }

  UsuarioModel? usuario;
  bool carregando = false;
  String? erro;

  Future<void> login(String email, String senha) async {
    try {
      carregando = true;
      erro = null;
      notifyListeners();

      await _repository.login(email, senha);
    } on FirebaseAuthException catch (e) {
      erro = e.message ?? "Erro desconhecido.";
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> cadastrar(String email, String senha) async {
    try {
      carregando = true;
      erro = null;
      notifyListeners();

      await _repository.cadastrar(email, senha);
    } on FirebaseAuthException catch (e) {
      erro = e.message ?? "Erro desconhecido.";
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repository.logout();
  }
}
