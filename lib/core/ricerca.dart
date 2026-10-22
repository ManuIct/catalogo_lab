import 'dart:convert';
import 'prodotto.dart';

List<Prodotto> cercaProdotti(String json, String categoria, double prezzoMax) {
  final lista = (jsonDecode(json) as List)
  .map((e) => Prodotto.fromJson(e as Map<String, dynamic>))
  .where((p) => p.categoria == categoria && p.prezzo <= prezzoMax)
  .toList()
  ..sort((a, b) => a.prezzo.compareTo(b.prezzo));
  return lista;
}