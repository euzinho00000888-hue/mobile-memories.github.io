import 'dart:async';
import 'dart:html';

import 'package:mobile_memories/credits.dart';
import 'package:mobile_memories/dom.dart';
import 'package:mobile_memories/downloads.dart';

/// Elementos do card de download, atualizados depois que a verificação termina.
class DownloadUi {
  final Element title = el('h3', text: 'Verificando disponibilidade…');
  final Element desc = el('p', text: 'Só um instante.');
  final Element meta = el('span', cls: 'download-meta');
  final AnchorElement button = AnchorElement(href: '#')
    ..className = 'btn btn-primary disabled'
    ..text = 'Aguarde'
    ..setAttribute('aria-disabled', 'true');
}

const sectionIds = ['home', 'sobre', 'download', 'creditos'];

void main() {
  final app = querySelector('#app')!;
  final ui = DownloadUi();

  final preloader = buildPreloader();
  final navbar = buildNavbar();
  final topButton = buildBackToTop();

  app
    ..append(preloader)
    ..append(navbar)
    ..append(buildHero())
    ..append(buildAbout())
    ..append(buildStats())
    ..append(buildDownload(ui))
    ..append(buildCredits())
    ..append(buildFooter())
    ..append(topButton);

  setupScroll(navbar, topButton);
  hidePreloader(preloader);
  checkDownload(ui);
}

// ---------------------------------------------------------------
// Seções
// ---------------------------------------------------------------

Element sectionHead(String text) =>
    el('div', cls: 'section-head reveal', children: [
      el('h2', text: text),
      el('span', cls: 'divider'),
    ]);

Element buildPreloader() => el('div', cls: 'preloader', children: [
      el('div', cls: 'spinner'),
    ]);

Element buildNavbar() {
  final links = el('ul', cls: 'nav-links');
  const items = [
    ['Início', '#home'],
    ['Sobre', '#sobre'],
    ['Download', '#download'],
    ['Créditos', '#creditos'],
  ];

  for (final item in items) {
    final a = AnchorElement(href: item[1])..text = item[0];
    a.onClick.listen((_) => links.classes.remove('open'));
    links.append(el('li', children: [a]));
  }

  final toggle = ButtonElement()
    ..className = 'nav-toggle'
    ..setAttribute('aria-label', 'Abrir menu')
    ..append(icon('bars'));
  toggle.onClick.listen((_) => links.classes.toggle('open'));

  final brand = AnchorElement(href: '#home')
    ..className = 'nav-brand'
    ..append(ImageElement(src: 'assets/logo.png', height: 34)..alt = '')
    ..append(el('span', text: 'Mobile Memories'));

  return el('header', cls: 'navbar', children: [
    el('div', cls: 'container nav-inner', children: [brand, toggle, links]),
  ]);
}

Element buildHero() {
  final typed = el('span', cls: 'typed');

  final download = AnchorElement(href: '#download')
    ..className = 'btn btn-primary'
    ..text = 'Baixar o mod';
  final about = AnchorElement(href: '#sobre')
    ..className = 'btn btn-ghost'
    ..text = 'Saiba mais';

  final scroll = AnchorElement(href: '#sobre')
    ..className = 'hero-scroll'
    ..setAttribute('aria-label', 'Rolar para baixo')
    ..append(el('span', cls: 'mouse', children: [el('span', cls: 'wheel')]));

  final logo = ImageElement(src: 'assets/logo.png')
    ..className = 'hero-logo'
    ..alt = 'Mobile Memories';

  startTyping(typed, [
    "Um mod de Friday Night Funkin'",
    'Inspirado em Pou',
    'Inspirado em Subway Surfers',
    'Inspirado em Doodle Jump',
    'Direto dos celulares de 2012',
  ]);

  return el('section', cls: 'hero', attrs: {'id': 'home'}, children: [
    el('div', cls: 'hero-inner', children: [
      logo,
      el('h1', text: 'Sua bateria tá em 12%.'),
      el('p', cls: 'hero-sub', children: [typed, el('span', cls: 'cursor', text: '|')]),
      el('div', cls: 'hero-buttons', children: [download, about]),
    ]),
    scroll,
  ]);
}

Element buildAbout() {
  final people = uniquePeopleCount();

  final features = [
    [
      'mobile',
      'Inspirado em 2012',
      'Pou, Subway Surfers, Doodle Jump e outros clássicos de celular daquela '
          'época viram fases, personagens e músicas.'
    ],
    [
      'music',
      "Friday Night Funkin'",
      'Tudo no ritmo do FNF, com o clima de tela pequena, botão home físico '
          'e aquele anúncio pra continuar jogando.'
    ],
    [
      'users',
      'Feito por $people pessoas',
      'Artistas, compositores, programadores e animadores unidos pra '
          'trazer essas memórias de volta.'
    ],
  ];

  final row = el('div', cls: 'row');
  for (var i = 0; i < features.length; i++) {
    final f = features[i];
    final card = el('div', cls: 'feature reveal', children: [
      el('div', cls: 'feature-icon', children: [icon(f[0])]),
      el('h3', text: f[1]),
      el('p', text: f[2]),
    ]);
    card.style.transitionDelay = '${i * 0.15}s';
    row.append(card);
  }

  return el('section', cls: 'section', attrs: {'id': 'sobre'}, children: [
    el('div', cls: 'container', children: [
      sectionHead('Sobre o mod'),
      el('p',
          cls: 'lead reveal',
          text: 'Mobile Memories pega tudo aquilo que fez os celulares de 2012 '
              "serem inesquecíveis e transforma em um mod de Friday Night Funkin'."),
      row,
    ]),
  ]);
}

Element buildStats() {
  final stats = [
    ['users', 'Pessoas na equipe', uniquePeopleCount()],
    ['th-list', 'Funções nos créditos', credits.length],
    ['calendar', 'Ano que inspirou o mod', 2012],
  ];

  final row = el('div', cls: 'row');
  for (final s in stats) {
    row.append(el('div',
        cls: 'stat reveal',
        attrs: {'data-count': '${s[2]}'},
        children: [
          icon(s[0] as String),
          el('span', cls: 'stat-number', text: '0'),
          el('span', cls: 'stat-label', text: s[1] as String),
        ]));
  }

  return el('section', cls: 'section-stats', children: [
    el('div', cls: 'container', children: [row]),
  ]);
}

Element buildDownload(DownloadUi ui) {
  return el('section', cls: 'section', attrs: {'id': 'download'}, children: [
    el('div', cls: 'container', children: [
      sectionHead('Download'),
      el('div', cls: 'download-box reveal', children: [
        icon('download'),
        ui.title,
        ui.desc,
        ui.meta,
        ui.button,
      ]),
    ]),
  ]);
}

Element buildCredits() {
  const palette = [
    '#3498db',
    '#1abc9c',
    '#e67e22',
    '#9b59b6',
    '#e74c3c',
    '#2ecc71',
    '#f39c12',
    '#34495e',
  ];

  final wrap = el('div', cls: 'container');
  wrap.append(sectionHead('Créditos'));

  for (var g = 0; g < credits.length; g++) {
    final group = credits[g];
    final row = el('div', cls: 'team-row');

    for (var i = 0; i < group.people.length; i++) {
      final name = group.people[i];
      final avatar = el('div', cls: 'avatar', text: initials(name));
      avatar.style.backgroundColor = palette[(g + i) % palette.length];

      row.append(el('div', cls: 'member', children: [
        avatar,
        el('span', cls: 'member-name', text: name),
      ]));
    }

    wrap.append(el('div', cls: 'team-group reveal', children: [
      el('h3', text: group.role),
      row,
    ]));
  }

  return el('section',
      cls: 'section section-gray', attrs: {'id': 'creditos'}, children: [wrap]);
}

Element buildFooter() {
  return el('footer', cls: 'footer', children: [
    el('div', cls: 'container', children: [
      ImageElement(src: 'assets/logo.png')
        ..className = 'footer-logo'
        ..alt = '',
      el('p', cls: 'made-with', children: [
        Text('Feito com '),
        icon('heart'),
        Text(' e Dart'),
      ]),
      el('p',
          text: 'Mobile Memories é um projeto de fã, sem vínculo com Pou, '
              'Subway Surfers, Doodle Jump ou seus criadores.'),
    ]),
  ]);
}

Element buildBackToTop() {
  final b = ButtonElement()
    ..className = 'back-to-top'
    ..setAttribute('aria-label', 'Voltar ao topo')
    ..append(icon('angle-up'));
  b.onClick.listen((_) => window.scrollTo(0, 0));
  return b;
}

// ---------------------------------------------------------------
// Comportamento
// ---------------------------------------------------------------

/// Tela de carregamento com spinner que some quando a página termina de carregar.
void hidePreloader(Element preloader) {
  var hidden = false;
  void hide() {
    if (hidden) return;
    hidden = true;
    preloader.classes.add('done');
    Timer(const Duration(milliseconds: 600), preloader.remove);
  }

  if (document.readyState == 'complete') {
    Timer(const Duration(milliseconds: 400), hide);
  } else {
    window.onLoad.listen((_) => Timer(const Duration(milliseconds: 400), hide));
    Timer(const Duration(seconds: 4), hide);
  }
}

/// Efeito de digitação (o clássico typed.js de 2016).
void startTyping(Element target, List<String> phrases) {
  var phrase = 0;
  var pos = 0;
  var deleting = false;

  void tick() {
    final full = phrases[phrase];
    if (!deleting) {
      pos++;
      target.text = full.substring(0, pos);
      if (pos == full.length) {
        deleting = true;
        Timer(const Duration(milliseconds: 1700), tick);
        return;
      }
    } else {
      pos--;
      target.text = full.substring(0, pos);
      if (pos == 0) {
        deleting = false;
        phrase = (phrase + 1) % phrases.length;
      }
    }
    Timer(Duration(milliseconds: deleting ? 40 : 85), tick);
  }

  tick();
}

/// Contador que sobe de 0 até o valor final.
void animateCount(Element number, int target) {
  const steps = 60;
  var step = 0;
  Timer.periodic(const Duration(milliseconds: 25), (timer) {
    step++;
    final value = (target * step / steps).round();
    number.text = '$value';
    if (step >= steps) {
      number.text = '$target';
      timer.cancel();
    }
  });
}

/// Navbar que muda ao rolar, scrollspy, animações de entrada e botão de topo.
void setupScroll(Element navbar, Element topButton) {
  final anchors = navbar.querySelectorAll('.nav-links a');

  void update() {
    final y = window.scrollY;
    final viewport = window.innerHeight ?? 800;

    navbar.classes.toggle('solid', y > 60);
    topButton.classes.toggle('show', y > 500);

    // scrollspy: marca no menu a seção que está na tela
    var current = sectionIds.first;
    for (final id in sectionIds) {
      final section = document.getElementById(id);
      if (section != null && section.getBoundingClientRect().top <= 140) {
        current = id;
      }
    }
    for (final a in anchors) {
      a.classes.toggle('active', a.getAttribute('href') == '#$current');
    }

    // animações de entrada (fade in + subida) e contadores
    for (final e in document.querySelectorAll('.reveal:not(.in)')) {
      if (e.getBoundingClientRect().top < viewport - 60) {
        e.classes.add('in');
        final count = e.getAttribute('data-count');
        if (count != null) {
          final number = e.querySelector('.stat-number');
          if (number != null) animateCount(number, int.parse(count));
        }
      }
    }
  }

  window.onScroll.listen((_) => update());
  window.onResize.listen((_) => update());
  Timer(const Duration(milliseconds: 100), update);
  update();
}

void setUnavailable(DownloadUi ui) {
  ui.title.text = 'Ainda não saiu';
  ui.desc.text = 'A equipe do mod ainda está trabalhando, aguarde.';
  ui.meta.text = '';
  ui.button
    ..text = 'Aguarde'
    ..href = '#'
    ..classes.add('disabled')
    ..removeAttribute('download')
    ..setAttribute('aria-disabled', 'true');
}

/// Vê se já existe um .zip do mod na pasta de downloads e libera o botão.
Future<void> checkDownload(DownloadUi ui) async {
  try {
    final found = await findDownload();
    if (found == null) {
      setUnavailable(ui);
      return;
    }

    ui.title.text = 'O mod já está disponível!';
    ui.desc.text =
        'Clique no botão pra baixar a versão mais recente de Mobile Memories.';
    ui.meta.text =
        found.sizeLabel == null ? found.name : '${found.name}  •  ${found.sizeLabel}';
    ui.button
      ..text = 'Baixar agora'
      ..href = found.url
      ..classes.remove('disabled')
      ..removeAttribute('aria-disabled')
      ..setAttribute('download', '');
  } catch (_) {
    setUnavailable(ui);
  }
}
