-- OPX Scan · Aretia — aplicado em 24/10/2026 no projeto app-5S (swrbiwtoupytmfhdaiaw)
-- Camada comum ar_ (compartilhada) + prefixo ox_ (este app). Ver LEIA-ME.txt.
-- (1) camada comum
create table if not exists public.ar_clientes (id text primary key, nome text not null, ativo boolean default true, criado timestamptz default now());
create table if not exists public.ar_apps (id text primary key, nome text not null, prefixo text not null, url text, criado timestamptz default now());
create table if not exists public.ar_eventos (id bigserial primary key, app text not null references public.ar_apps(id), cliente text references public.ar_clientes(id), tipo text not null, ref_id text, resumo text, dados jsonb, por text, em timestamptz default now());
alter table public.ar_clientes enable row level security; alter table public.ar_apps enable row level security; alter table public.ar_eventos enable row level security;
revoke all on public.ar_clientes, public.ar_apps, public.ar_eventos from anon, authenticated;
create or replace function public.ar_evento(p_app text, p_cliente text, p_tipo text, p_ref text, p_resumo text, p_dados jsonb, p_por text) returns void language sql security definer set search_path = public as $$ insert into public.ar_eventos(app, cliente, tipo, ref_id, resumo, dados, por) values (p_app, p_cliente, p_tipo, p_ref, p_resumo, p_dados, p_por) $$;
revoke all on function public.ar_evento(text,text,text,text,text,jsonb,text) from public, anon, authenticated;
-- (2) OPX Scan: tabelas
create table if not exists public.ox_config (k text primary key, v text);
create table if not exists public.ox_usuarios (id bigserial primary key, nome text not null, pin_hash text not null unique, papel text not null default 'equipe' check (papel in ('admin','equipe')), criado timestamptz default now());
create table if not exists public.ox_falhas (quem text, em timestamptz default now());
create table if not exists public.ox_avaliacoes (id text primary key, cliente text not null default 'imtab' references public.ar_clientes(id), rotulo text, avaliador text, data date, respostas jsonb not null default '{}'::jsonb, evidencias jsonb not null default '{}'::jsonb, media numeric, respondidas int, criado timestamptz default now(), atualizado timestamptz default now(), por text, apagado boolean default false);
alter table public.ox_config enable row level security; alter table public.ox_usuarios enable row level security; alter table public.ox_falhas enable row level security; alter table public.ox_avaliacoes enable row level security;
revoke all on public.ox_config, public.ox_usuarios, public.ox_falhas, public.ox_avaliacoes from anon, authenticated;
-- (3) funções: ox_hash, ox_quem, ox_auth, ox_erro, ox_instalar, ox_login, ox_usuario_salvar, ox_usuarios_listar, ox_pull, ox_push
-- (corpo completo está no banco; use "select pg_get_functiondef('public.ox_push'::regproc)" para consultar)
-- grants: execute em ox_instalar, ox_login, ox_usuario_salvar, ox_usuarios_listar, ox_pull, ox_push para anon/authenticated.
