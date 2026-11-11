/// Dados dos créditos do mod. Para editar a equipe, mexa só aqui.
class CreditGroup {
  final String role;
  final List<String> people;
  const CreditGroup(this.role, this.people);
}

const List<CreditGroup> credits = [
  CreditGroup('Director(s)', ['JovemRosa04']),
  CreditGroup('Owner(s)', ['JovemRosa04']),
  CreditGroup('Creator(s)', ['JovemRosa04']),
  CreditGroup('Artists', ['JovemRosa04', 'Mianlukas', 'SpringlessGuy']),
  CreditGroup('Composers', ['JovemRosa04', 'Mianlukas', 'Lobinho Produções', 'Xoratolegal']),
  CreditGroup('Coders', ['0_Milyy', 'Z i n n', 'Vitorcraftgamer', 'Maycon (MD)']),
  CreditGroup('Charters', ['Mianlukas', 'SpringlessGuy']),
  CreditGroup('3D Modelers', ['JovemRosa04', 'Xoratolegal', 'Vitorcraftgamer']),
  CreditGroup('3D Animator(s)', ['Xoratolegal']),
  CreditGroup('Chromatic Makers', ['Mianlukas', 'Xoratolegal', 'Vitorcraftgamer']),
  CreditGroup('Sprite animators', ['JovemRosa04', 'Lele_arj YT', 'SpringlessGuy']),
  CreditGroup('Promo artists', ['H3lt']),
];

/// Quantas pessoas diferentes aparecem nos créditos.
int uniquePeopleCount() => credits.expand((g) => g.people).toSet().length;

/// Iniciais usadas no avatar de cada pessoa.
String initials(String name) {
  final clean = name.replaceAll(RegExp(r'\(.*?\)'), '').trim();
  final parts = clean.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) {
    final p = parts.first;
    return (p.length >= 2 ? p.substring(0, 2) : p).toUpperCase();
  }
  return (parts.first[0] + parts.last[0]).toUpperCase();
}
