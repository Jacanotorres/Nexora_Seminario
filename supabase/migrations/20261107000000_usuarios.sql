-- Usuarios de Nexora: extiende auth.users con los datos del MER.

create type public.rol_usuario as enum ('organizador', 'participante');

create table public.usuarios (
  id uuid primary key references auth.users (id) on delete cascade,
  nombre text not null,
  correo text not null unique,
  documento text not null unique,
  rol public.rol_usuario not null default 'participante',
  creado_en timestamptz not null default now()
);

alter table public.usuarios enable row level security;

create policy "Cada usuario ve su propio perfil"
  on public.usuarios for select
  to authenticated
  using (auth.uid() = id);

create policy "Cada usuario actualiza su propio perfil"
  on public.usuarios for update
  to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- Crea el perfil al registrarse. Los datos llegan en raw_user_meta_data
-- (signUp(data: {nombre, documento, rol})).
create function public.crear_usuario_al_registrarse()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.usuarios (id, nombre, correo, documento, rol)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'nombre', ''),
    new.email,
    coalesce(new.raw_user_meta_data ->> 'documento', new.id::text),
    coalesce((new.raw_user_meta_data ->> 'rol')::public.rol_usuario, 'participante')
  );
  return new;
end;
$$;

create trigger al_crear_auth_user
  after insert on auth.users
  for each row execute function public.crear_usuario_al_registrarse();
