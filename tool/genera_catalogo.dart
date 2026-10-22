import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main() {
  final rnd = Random(42);
  const categorie = ['Libri', 'Giochi', 'Casa', 'Sport', 'Musica', 'Cucina'];
  
  final prodotti = List.generate(6000, (i) {
    return {
      'id': i,
      'nome': 'Prodotto ${i.toString().padLeft(5, '0')}',
      // Sceglie una categoria a caso dalla lista
      'categoria': categorie[rnd.nextInt(categorie.length)],
      // Genera un prezzo tra 0.99 e 200.99 (arrotondato a 2 decimali)
      'prezzo': (rnd.nextInt(20000) + 99) / 100, 
      'descrizione': 'Descrizione lunga del prodotto $i. ' * 2,
    };
  });

  Directory('assets').createSync(recursive: true);
  File('assets/catalogo.json').writeAsStringSync(jsonEncode(prodotti));
  stdout.writeln('Generati ${prodotti.length} prodotti in assets/catalogo.json');
}