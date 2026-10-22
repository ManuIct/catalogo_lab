import 'package:catalogo_lab/core/data/catalogo_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/prodotto.dart';

typedef Filtro = ({String categoria, double prezzoMax});
final strategiaProvider = Provider<Strategia>((ref) => Strategia.sincrona);
final catalogoRepositoryProvider = Provider<CatalogoRepository>(
  (ref) => CatalogoRepository(ref.watch(strategiaProvider)),
);
final catalogoJsonProvider = FutureProvider<String>(
  (ref) => rootBundle.loadString('assets/catalogo.json'),
);
final cercaProvider = FutureProvider.autoDispose.family<List<Prodotto>, Filtro>(
  (ref, filtro) {
    final json = ref.read(catalogoJsonProvider).requireValue;
    final sw = Stopwatch()..start();
    final lavoro = ref
        .read(catalogoRepositoryProvider)
        .cerca(json, filtro.categoria, filtro.prezzoMax);
    ref.onDispose(lavoro.annulla);
    return lavoro.risultato.whenComplete(() {
      debugPrint(
        'cerca ${filtro.categoria} <= ${filtro.prezzoMax}: '
        '${sw.elapsedMilliseconds} ms',
      );
    });
  },
);
