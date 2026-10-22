import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

Future<int> battitiDurante(Future<void> Function() azione) async {
  int battiti = 0;
  final timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      battiti++;
  });

  await azione();
  timer.cancel();
  return battiti;
}
