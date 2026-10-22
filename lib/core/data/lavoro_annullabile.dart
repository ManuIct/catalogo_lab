class LavoroAnnullabile<T> {
  LavoroAnnullabile(this.risultato, [this._annulla]);

  LavoroAnnullabile.istantaneo(T valore)
      : risultato = Future.value(valore),
        _annulla = null;

  final Future<T> risultato;
  final void Function()? _annulla;

  void annulla() => _annulla?.call();
}