import 'dart:isolate';
import '../prodotto.dart';
import '../ricerca.dart';
import 'lavoro_annullabile.dart';
import 'catalogo_spawn.dart';

enum Strategia { sincrona, run, spawn }

class CatalogoRepository {
  const CatalogoRepository(this.strategia);

  final Strategia strategia;

  LavoroAnnullabile<List<Prodotto>> cerca(
    String json,
    String categoria,
    double prezzoMax,
  ) {
    switch (strategia) {
      case Strategia.sincrona:
       return LavoroAnnullabile.istantaneo(
          cercaProdotti(json, categoria, prezzoMax),
        );
        case Strategia.run:
          return LavoroAnnullabile(
              Isolate.run(() => cercaProdotti(json, categoria, prezzoMax)),
            );
        case Strategia.spawn:
          throw UnimplementedError('Lo scriviamo alla Fase 4');
    }
  }
}