import 'dart:io';

import 'package:catalogo_lab/core/data/catalogo_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'battiti.dart';

void main() {
  late final String json;

  setUpAll(() {
    json = File('assets/catalogo.json').readAsStringSync();
  });

  Future<void> esegui(Strategia s) async {
    await CatalogoRepository(s).cerca(json, 'Libri', 150).risultato;
  }

  test('sincrona: il timer non riesce a battere', () async {
      expect(await battitiDurante(() => esegui(Strategia.sincrona)), lessThan(3));
  });

  test('run: il timer continua a battere', () async {
    expect(await battitiDurante(() => esegui(Strategia.run)), greaterThan(5));
  });
}

