import 'dart:io';

import 'package:catalogo_lab/core/data/catalogo_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catalogo_lab/core/ricerca.dart';

void main() {
  late final String json;

  setUpAll(() {
      json = File('assets/catalogo.json').readAsStringSync();
  });

  test('sincrona, run e spawn danno lo stesso risultato', () async {
    final atteso = 
          cercaProdotti(json, 'Libri', 80).map((p) => p.id).toList();
      expect(atteso, isNotEmpty);

      for (final s in Strategia.values) {
        final lavoro = CatalogoRepository(s).cerca(json, 'Libri', 80);
        final ottenuto = (await lavoro.risultato).map((p) => p.id).toList();
        expect(ottenuto, atteso, reason: 'strategia $s');
      }
  });

  test('annullare uno spawn non fa esplodere niente', () async {
      final lavoro = CatalogoRepository(Strategia.spawn).cerca(json, '', 80);
      lavoro.annulla();
      await Future<void>.delayed(const Duration(milliseconds: 300));
  });
}