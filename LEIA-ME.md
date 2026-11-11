# Mobile Memories — site em Dart (GitHub Pages)

Site feito em **Dart**: o `web/main.dart` monta a página inteira e o `webdev` compila pra JavaScript.

## Primeira vez
```
dart pub global activate webdev
dart pub get
```

## Testar no PC
```
webdev serve
```
Abra o endereço que aparecer (normalmente http://127.0.0.1:8080).

## Compilar pra publicar
```
webdev build --output web:docs
```
Isso gera a pasta `docs/` pronta pro GitHub Pages (index.html, main.dart.js, styles.css, assets e downloads).
Refaça o build sempre que mexer em `web/` ou `lib/`.

> Use `--output web:docs`: sem isso o webdev gera a pasta `build/`, que o GitHub Pages não consegue publicar.
> A pasta `docs/` é apagada e recriada a cada build, então **nunca edite nada direto nela**.

## Publicar no GitHub
1. Suba o projeto inteiro (inclusive a pasta `docs/` gerada).
2. No GitHub: **Settings → Pages → Deploy from a branch** → branch `main`, pasta **/docs**.
3. O site fica em `https://SEU-USUARIO.github.io/NOME-DO-REPOSITORIO/`.

## Liberar o download
1. Coloque o `.zip` do mod em **`web/downloads/`** (não em `docs/`, porque o build apaga a `docs/`).
2. Rode `webdev build --output web:docs` e dê commit/push.
3. O site pergunta pro GitHub quais arquivos existem em `docs/downloads` e libera o botão sozinho
   (qualquer nome terminado em `.zip`).

- Se a API do GitHub falhar (limite de requisições), o site tenta os nomes listados em
  `lib/config.dart` (`MobileMemories.zip`, `mobile-memories.zip`, `Mobile Memories.zip`).
- Se usar **domínio próprio**, preencha `githubOwner` e `githubRepo` em `lib/config.dart`.
- O GitHub recusa arquivos acima de 100 MB num commit normal. Se o mod passar disso, use **Releases**.

## Editar créditos
Tudo em `lib/credits.dart`.

## Estrutura
```
pubspec.yaml         → projeto Dart (com build_runner e build_web_compilers)
lib/credits.dart     → lista de créditos
lib/config.dart      → configurações do download
lib/downloads.dart   → detecção do .zip
lib/dom.dart         → helpers pra criar elementos HTML
web/main.dart        → monta toda a página
web/index.html       → casca da página
web/styles.css       → visual
web/assets/          → logo
web/downloads/       → coloque o .zip do mod aqui
docs/                → gerado pelo build (não edite)
```
