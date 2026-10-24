# Aretia · Apps

Repositório único dos apps estáticos da Aretia, publicados no GitHub Pages: https://kafkia.github.io/aretia-apps/

| Pasta | App | Base (Supabase, projeto app-5S) |
|---|---|---|
| `opx/` | OPX Scan (maturidade em excelência operacional) | prefixo `ox_` |

Camada comum da base: `ar_clientes`, `ar_apps`, `ar_eventos` (ver `opx/LEIA-ME.txt`, seção "Regra para os próximos apps").

## Regra para um app novo
1. Criar a pasta `nome-do-app/` com `index.html`, `manifest.webmanifest`, `sw.js` e `icons/`.
2. Prefixo próprio no Supabase, tabelas com RLS e acesso só por funções com PIN; registrar em `ar_apps` e gravar eventos com `ar_evento`.
3. Adicionar o cartão do app no `index.html` da raiz.
4. Enviar para `main`; o Pages publica sozinho.
