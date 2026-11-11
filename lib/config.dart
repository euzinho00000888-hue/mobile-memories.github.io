/// Configurações do site.

/// Em endereços *.github.io o dono e o repositório são detectados sozinhos.
/// Se você usar domínio próprio, preencha aqui (ex.: 'JovemRosa04' e 'mobile-memories').
const String? githubOwner = null;
const String? githubRepo = null;

/// Pasta (dentro do repositório) onde o .zip do mod fica.
const String downloadsRepoPath = 'docs/downloads';

/// Nomes de arquivo tentados se a detecção automática pelo GitHub falhar
/// (por exemplo, limite de requisições da API do GitHub).
const List<String> fallbackZipNames = [
  'MobileMemories.zip',
  'mobile-memories.zip',
  'Mobile Memories.zip',
];
