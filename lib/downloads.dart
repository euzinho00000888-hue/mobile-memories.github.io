import 'dart:convert';
import 'dart:html';

import 'config.dart';

class FoundDownload {
  final String name;
  final String url;
  final String? sizeLabel;
  const FoundDownload(this.name, this.url, this.sizeLabel);
}

String? formatSize(num? bytes) {
  if (bytes == null || bytes <= 0) return null;
  final mb = bytes / (1024 * 1024);
  if (mb < 1024) return '${mb.toStringAsFixed(1)} MB';
  return '${(mb / 1024).toStringAsFixed(2)} GB';
}

/// Descobre dono/repositório a partir do endereço *.github.io.
({String owner, String repo})? _repoFromLocation() {
  if (githubOwner != null && githubRepo != null) {
    return (owner: githubOwner!, repo: githubRepo!);
  }
  final host = window.location.hostname ?? '';
  const suffix = '.github.io';
  if (!host.endsWith(suffix)) return null;

  final owner = host.substring(0, host.length - suffix.length);
  final segments = (window.location.pathname ?? '')
      .split('/')
      .where((s) => s.isNotEmpty && !s.contains('.'))
      .toList();
  final repo = segments.isEmpty ? host : segments.first;
  return (owner: owner, repo: repo);
}

/// 1) Pergunta pro GitHub quais arquivos existem na pasta de downloads
///    (acha qualquer .zip, com qualquer nome).
/// 2) Se falhar, tenta os nomes de [fallbackZipNames].
Future<FoundDownload?> findDownload() async {
  final repo = _repoFromLocation();
  if (repo != null) {
    try {
      final body = await HttpRequest.getString(
        'https://api.github.com/repos/${repo.owner}/${repo.repo}/contents/$downloadsRepoPath',
      );
      final list = jsonDecode(body) as List<dynamic>;
      for (final item in list) {
        final map = item as Map<String, dynamic>;
        final name = map['name'] as String;
        if (name.toLowerCase().endsWith('.zip')) {
          return FoundDownload(
            name,
            'downloads/${Uri.encodeComponent(name)}',
            formatSize(map['size'] as num?),
          );
        }
      }
      return null; // pasta existe, mas não tem .zip
    } catch (_) {
      // cai pro plano B
    }
  }

  for (final name in fallbackZipNames) {
    final url = 'downloads/${Uri.encodeComponent(name)}';
    try {
      final req = await HttpRequest.request(url, method: 'HEAD');
      final length = int.tryParse(req.getResponseHeader('content-length') ?? '');
      return FoundDownload(name, url, formatSize(length));
    } catch (_) {
      // não existe, tenta o próximo
    }
  }
  return null;
}
