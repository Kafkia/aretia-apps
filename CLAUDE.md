# Aretia · apps — regras para construir e manter

Repositório público servido pelo GitHub Pages em https://kafkia.github.io/aretia-apps/.
Tudo que estiver aqui fica visível na internet: **nunca** coloque código de acesso, PIN,
chave de serviço, nome de pessoa, dado de cliente ou número de diagnóstico neste repositório.

## Estrutura

- Uma pasta por app (`opx/`, `snapshot/`, ...), cada uma com `index.html`, `manifest.webmanifest`,
  `sw.js` e `icons/`. App estático em arquivo único, funciona offline (PWA, "adicionar à tela inicial").
- O portal fica na raiz (`index.html`): todo app novo ganha um cartão nele.
- Não mover nem renomear pastas existentes: os links já estão com clientes.

## Base de dados (Supabase, projeto `app-5S`, id `swrbiwtoupytmfhdaiaw`)

- Um prefixo por app (`ox_` OPX, `sn_` Snapshot, `gr_` Gestão da Rotina...). Camada comum `ar_`:
  `ar_clientes`, `ar_apps`, `ar_eventos` (registrar com `ar_evento`), `ar_falhas` (tentativas erradas).
- Toda tabela com RLS ligado e sem acesso direto (`revoke all ... from anon, authenticated`).
  O navegador só chama funções `security definer` com `set search_path = public`.
- **Toda função chamada pelo navegador confere PIN ou código** e bloqueia após 10 erros em
  15 minutos por endereço. Código e PIN são guardados só como hash (`ar_hash`).
- O código de acesso é digitado pelo usuário uma vez e fica no aparelho (`localStorage`);
  nunca escrito no HTML.
- Linhas com `id` texto gerado no app, `atualizado`/`atualizado_em` e exclusão lógica
  (`apagado`/`excluida`), para sincronizar por data. `on conflict` só atualiza linha do mesmo cliente.
- Mudança de esquema por migração nomeada; depois rodar os alertas de segurança do Supabase.
- Apps de terceiros na mesma base (`kb_`, `kbd_`, `cg_`, `cgd_`, `co_`, `mt_`, `company_`, 5S)
  **não são alterados** sem pedido explícito do João: estão em uso por clientes e têm automações diárias.

## Identidade visual

- Logo oficial todo laranja. Cores: laranja `#B83A18`, texto `#111110`, fundo off-white quente.
  Fontes: Manrope, Newsreader, DM Sans, DM Mono.
- Sempre um detalhe de símbolo brasileiro discreto (ex.: faixa fina verde, amarelo e azul).
- Português do Brasil. Níveis de rotina se chamam GR1, GR2, GR3. Nunca usar nomenclatura de
  outras consultorias ("LFP", "3 Rs", "Ponto de Encontro", "Ponto de Parada", "CONWIP").

## Antes de publicar

1. Testar no navegador com servidor simulado (Playwright): abrir, entrar, salvar, recarregar.
2. Incrementar a versão do cache em `sw.js`.
3. Mudança de servidor que muda o acesso: aplicar a migração **antes** de publicar o app,
   e só com aprovação do João. Se a migração falhar, não publicar.
4. Depois de publicar, abrir o link real e conferir que carrega e sincroniza.
