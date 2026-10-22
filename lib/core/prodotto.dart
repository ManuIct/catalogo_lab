class Prodotto {
  const Prodotto({
      required this.id,
      required this.nome,
      required this.categoria,
      required this.prezzo,
  });

  factory Prodotto.fromJson(Map<String, dynamic> json) {
    return Prodotto(
      id: json['id'] as int,
      nome: json['nome'] as String,
      categoria: json['categoria'] as String,
      prezzo: (json['prezzo'] as num).toDouble(),
      );
  }

  final int id;
  final String nome;
  final String categoria;
  final double prezzo;
}