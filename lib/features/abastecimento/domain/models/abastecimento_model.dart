class AbastecimentoModel {
  final String? id;
  final DateTime data;
  final double quantidadeLitros;
  final double valorPago;
  final int quilometragem;
  final String tipoCombustivel;
  final String veiculoId;
  final double consumo;
  final String? observacao;

  AbastecimentoModel({
    this.id,
    required this.data,
    required this.quantidadeLitros,
    required this.valorPago,
    required this.quilometragem,
    required this.tipoCombustivel,
    required this.veiculoId,
    required this.consumo,
    this.observacao,
  });

  AbastecimentoModel copyWith({
    String? id,
    DateTime? data,
    double? quantidadeLitros,
    double? valorPago,
    int? quilometragem,
    String? tipoCombustivel,
    String? veiculoId,
    double? consumo,
    String? observacao,
  }) {
    return AbastecimentoModel(
      id: id ?? this.id,
      data: data ?? this.data,
      quantidadeLitros: quantidadeLitros ?? this.quantidadeLitros,
      valorPago: valorPago ?? this.valorPago,
      quilometragem: quilometragem ?? this.quilometragem,
      tipoCombustivel: tipoCombustivel ?? this.tipoCombustivel,
      veiculoId: veiculoId ?? this.veiculoId,
      consumo: consumo ?? this.consumo,
      observacao: observacao ?? this.observacao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.toIso8601String(),
      'quantidadeLitros': quantidadeLitros,
      'valorPago': valorPago,
      'quilometragem': quilometragem,
      'tipoCombustivel': tipoCombustivel,
      'veiculoId': veiculoId,
      'consumo': consumo,
      'observacao': observacao,
    };
  }

  factory AbastecimentoModel.fromMap(String id, Map<String, dynamic> map) {
    return AbastecimentoModel(
      id: id,
      data: DateTime.tryParse(map['data'] ?? '') ?? DateTime.now(),
      quantidadeLitros: (map['quantidadeLitros'] as num?)?.toDouble() ?? 0.0,
      valorPago: (map['valorPago'] as num?)?.toDouble() ?? 0.0,
      quilometragem: (map['quilometragem'] ?? 0) as int,
      tipoCombustivel: map['tipoCombustivel'] ?? '',
      veiculoId: map['veiculoId'] ?? '',
      consumo: (map['consumo'] as num?)?.toDouble() ?? 0.0,
      observacao: map['observacao'],
    );
  }
}
