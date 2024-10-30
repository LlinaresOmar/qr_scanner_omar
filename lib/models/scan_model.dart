import 'dart:convert';

class ScanModel {
    int? id;
    String tipo;
    String valor;

    ScanModel({
        this.id,
        required this.valor,
    }) : tipo = valor.contains('http') ? 'http' : 'geo';

    factory ScanModel.fromRawJson(String str) => ScanModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        valor: json["valor"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "valor": valor,
    };
}
