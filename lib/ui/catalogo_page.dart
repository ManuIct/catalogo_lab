import 'package:catalogo_lab/catalogo_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Ho eliminato l'import duplicato '../catalogo_providers.dart';

class CatalogoPage extends ConsumerStatefulWidget {
  const CatalogoPage({super.key});

  @override
  ConsumerState<CatalogoPage> createState() => _catalogoPageState();
}

class _catalogoPageState extends ConsumerState<CatalogoPage> {
  static const _categorie = [
    'Libri',
    'Giochi',
    'Casa',
    'Sport',
    'Musica',
    'Cucina',
  ];
  String _categoria = _categorie.first;
  double _prezzoMax = 100;

  @override
  Widget build(BuildContext context) {
    final json = ref.watch(catalogoJsonProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Catalogo')),
      body: Column(
        children: [
          // Ho eliminato il CircularProgressIndicator fisso che girava per sempre
          DropdownButton<String>(
            value: _categoria,
            items: [
              for (final c in _categorie)
                DropdownMenuItem(value: c, child: Text(c)),
            ],
            onChanged: (c) => setState(() => _categoria = c!),
          ),
          Slider(
            value: _prezzoMax,
            min: 10,
            max: 200,
            divisions: 19,
            label: '${_prezzoMax.round()} EUR',
            onChanged: (v) => setState(() => _prezzoMax = v),
          ),
          Expanded(
            child: json.when(
              data: (_) => _Risultati( // Ho messo la 'R' maiuscola
                filtro: (categoria: _categoria, prezzoMax: _prezzoMax),
              ),
              loading: () => const Center(child: Text('Carico il catalogo...')),
              error: (e, _) => Center(child: Text('Errore: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

// Ho rinominato la classe da '_risultati' a '_Risultati' (PascalCase)
class _Risultati extends ConsumerWidget {
  const _Risultati({required this.filtro});

  final Filtro filtro;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final risultati = ref.watch(cercaProvider(filtro));
    return risultati.when(
      loading: () => const Center(child: Text('Cerco...')),
      error: (e, _) => Center(child: Text('Errore: $e')),
      data: (lista) => Column(
        children: [
          Text('${lista.length} prodotti'),
          Expanded(
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (_, i) {
                final p = lista[i];
                return ListTile(
                  title: Text(p.nome),
                  subtitle: Text(p.categoria),
                  trailing: Text('${p.prezzo.toStringAsFixed(2)} EUR'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}