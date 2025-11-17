class UsuarioModel {
  final String id;
  final String email;

  UsuarioModel({required this.id, required this.email});

  factory UsuarioModel.fromFirebase(String id, String email) {
    return UsuarioModel(id: id, email: email);
  }
}
