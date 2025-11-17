class VeiculoModel {
  final String? id;
  final String modelo;
  final String marca;
  final String placa;
  final int ano;
  final String tipoCombustivel;

  VeiculoModel({
    this.id,
    required this.modelo,
    required this.marca,
    required this.placa,
    required this.ano,
    required this.tipoCombustivel,
  });

  VeiculoModel copyWith({
    String? id,
    String? modelo,
    String? marca,
    String? placa,
    int? ano,
    String? tipoCombustivel,
  }) {
    return VeiculoModel(
      id: id ?? this.id,
      modelo: modelo ?? this.modelo,
      marca: marca ?? this.marca,
      placa: placa ?? this.placa,
      ano: ano ?? this.ano,
      tipoCombustivel: tipoCombustivel ?? this.tipoCombustivel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'modelo': modelo,
      'marca': marca,
      'placa': placa,
      'ano': ano,
      'tipoCombustivel': tipoCombustivel,
    };
  }

  factory VeiculoModel.fromMap(String id, Map<String, dynamic> map) {
    return VeiculoModel(
      id: id,
      modelo: map['modelo'] ?? '',
      marca: map['marca'] ?? '',
      placa: map['placa'] ?? '',
      ano: (map['ano'] ?? 0) as int,
      tipoCombustivel: map['tipoCombustivel'] ?? '',
    );
  }
}
