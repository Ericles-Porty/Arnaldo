String formatarDataPadraoUs(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

String formatarDataHoraPadraoUs(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}-${date.hour.toString().padLeft(2, '0')}-${date.minute.toString().padLeft(2, '0')}-${date.second.toString().padLeft(2, '0')}";
}

String formatarDataPadraoBr(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
}

final removeZeros = RegExp(r'\.0+$');

String formatarValorMonetario(double valor) {
  return valor.toStringAsFixed(2).replaceAll(removeZeros, '');
}

String formatarValorMonetarioOuVazio(double valor) {
  return valor == 0.0 ? '' : formatarValorMonetario(valor);
}
