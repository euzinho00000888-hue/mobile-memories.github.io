import 'dart:html';

/// Atalho pra criar elementos HTML sem repetir código.
Element el(
  String tag, {
  String? cls,
  String? text,
  Map<String, String>? attrs,
  List<Node> children = const [],
}) {
  final e = document.createElement(tag);
  if (cls != null) e.className = cls;
  if (text != null) e.text = text;
  if (attrs != null) {
    attrs.forEach((k, v) => e.setAttribute(k, v));
  }
  for (final c in children) {
    e.append(c);
  }
  return e;
}

/// Ícone do Font Awesome 4 (ex.: icon('download')).
Element icon(String name) =>
    el('i', cls: 'fa fa-$name', attrs: {'aria-hidden': 'true'});
