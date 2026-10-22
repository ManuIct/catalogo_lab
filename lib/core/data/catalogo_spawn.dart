import 'dart:async';
import 'dart:isolate';
import '../prodotto.dart';
import '../ricerca.dart';
import 'lavoro_annullabile.dart';

class _Richiesta {
  const _Richiesta(this.risposta, this.json, this.categoria, this.prezzoMax);
  final SendPort risposta;
  final String json;
  final String categoria;
  final double prezzoMax;
}

void _cercaEInvia(_Richiesta r) {
  try {
    r.risposta.send(cercaProdotti(r.json, r.categoria, r.prezzoMax));
  } catch (e) {
    r.risposta.send('Errore: $e');
  }
}

LavoroAnnullabile<List<Prodotto>> cercaConSpawn(
  String json,
  String categoria,
  double prezzoMax,
) {
  final completer = Completer<List<Prodotto>>();
  final porta = ReceivePort();
  Isolate? isolate;
  var annullato = false;
  var chiuso = false;

  void chiudi() {
    if (chiuso) return;
    chiuso = true;
    isolate?.kill(priority: Isolate.immediate);
    isolate = null;
    porta.close();
  }

  porta.listen((messaggio) {
    if (messaggio is String) {
      completer.completeError(Exception(messaggio));
    } else {
      completer.complete((messaggio as List).cast<Prodotto>());
    }
    chiudi();
  });

  Isolate.spawn(_cercaEInvia, _Richiesta(porta.sendPort, json, categoria, prezzoMax)).then((nuovo) {
    if (annullato) {
      nuovo.kill(priority: Isolate.immediate);
    } else {
      isolate = nuovo;
    }
  });

  return LavoroAnnullabile(completer.future, () {
    annullato = true;
    chiudi();
  });
}