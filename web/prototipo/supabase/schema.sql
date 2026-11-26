-- =====================================================================
-- SportFactory Gym · esquema de base de datos para Supabase (PostgreSQL)
-- Pégalo entero en: Supabase → SQL Editor → New query → Run
-- Se puede ejecutar más de una vez sin romper nada.
-- =====================================================================

-- 1) Tablas ------------------------------------------------------------
create table if not exists public.profiles (
  id         uuid primary key references auth.users(id) on delete cascade,
  full_name  text not null default '',
  created_at timestamptz not null default now()
);

create table if not exists public.classes (
  id          text primary key,
  name        text not null,
  description text not null,
  minutes     int  not null check (minutes > 0),
  level       text not null,
  capacity    int  not null check (capacity > 0),
  room        text not null
);

-- Horario semanal: weekday 0 = lunes ... 5 = sábado
create table if not exists public.sessions (
  id         uuid primary key default gen_random_uuid(),
  class_id   text not null references public.classes(id) on delete cascade,
  weekday    smallint not null check (weekday between 0 and 5),
  start_time time not null,
  capacity   int  not null check (capacity > 0),
  unique (class_id, weekday, start_time)
);

create table if not exists public.bookings (
  id         uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.sessions(id) on delete cascade,
  user_id    uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (session_id, user_id)
);
create index if not exists bookings_user_idx on public.bookings(user_id);

-- 2) Vista pública con las plazas ocupadas ---------------------------------
-- Cuenta TODAS las reservas (no revela quién ha reservado, solo cuántas).
create or replace view public.sessions_with_taken as
select s.id,
       s.class_id,
       s.weekday,
       to_char(s.start_time, 'HH24:MI') as start_time,
       s.capacity,
       (select count(*) from public.bookings b where b.session_id = s.id)::int as taken
from public.sessions s;

-- 3) Perfil automático al registrarse -------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'full_name', ''))
  on conflict (id) do nothing;
  return new;
end
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 4) Reservar y cancelar: SOLO a través de estas funciones -----------------
-- El bloqueo "for update" evita que dos socios cojan a la vez la última plaza.
create or replace function public.book_session(p_session uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid   uuid := auth.uid();
  v_cap   int;
  v_taken int;
begin
  if v_uid is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  select capacity into v_cap from public.sessions where id = p_session for update;
  if not found then
    raise exception 'session_not_found' using errcode = 'P0002';
  end if;

  if exists (select 1 from public.bookings where session_id = p_session and user_id = v_uid) then
    raise exception 'already_booked' using errcode = '23505';
  end if;

  select count(*) into v_taken from public.bookings where session_id = p_session;
  if v_taken >= v_cap then
    raise exception 'session_full' using errcode = 'P0001';
  end if;

  insert into public.bookings (session_id, user_id) values (p_session, v_uid);
end
$$;

create or replace function public.cancel_booking(p_session uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
begin
  if v_uid is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  delete from public.bookings where session_id = p_session and user_id = v_uid;
end
$$;

revoke all on function public.book_session(uuid)    from public, anon;
revoke all on function public.cancel_booking(uuid)  from public, anon;
grant execute on function public.book_session(uuid)   to authenticated;
grant execute on function public.cancel_booking(uuid) to authenticated;

-- 5) Seguridad a nivel de fila (RLS) ---------------------------------------
alter table public.profiles enable row level security;
alter table public.classes  enable row level security;
alter table public.sessions enable row level security;
alter table public.bookings enable row level security;

drop policy if exists "classes visibles para todos"  on public.classes;
drop policy if exists "sessions visibles para todos" on public.sessions;
drop policy if exists "perfil propio: ver"           on public.profiles;
drop policy if exists "perfil propio: editar"        on public.profiles;
drop policy if exists "reservas propias: ver"        on public.bookings;

create policy "classes visibles para todos"  on public.classes
  for select to anon, authenticated using (true);
create policy "sessions visibles para todos" on public.sessions
  for select to anon, authenticated using (true);
create policy "perfil propio: ver"    on public.profiles
  for select to authenticated using (id = auth.uid());
create policy "perfil propio: editar" on public.profiles
  for update to authenticated using (id = auth.uid()) with check (id = auth.uid());
create policy "reservas propias: ver" on public.bookings
  for select to authenticated using (user_id = auth.uid());
-- Sin políticas de insert/update/delete en bookings: solo las funciones anteriores pueden escribir.

-- 6) Permisos explícitos ---------------------------------------------------
grant usage on schema public to anon, authenticated;
grant select on public.classes, public.sessions, public.sessions_with_taken to anon, authenticated;
grant select on public.bookings to authenticated;
grant select on public.profiles to authenticated;
grant update (full_name) on public.profiles to authenticated;
revoke insert, update, delete on public.bookings from anon, authenticated;

-- 7) Datos iniciales: las 7 clases y el horario de ejemplo -----------------
insert into public.classes (id, name, description, minutes, level, capacity, room) values
  ('spin','Spinning',  'Ciclismo indoor al ritmo de la música, con intervalos de subida y sprint.',45,'Todos los niveles',20,'Sala ciclo'),
  ('func','Funcional', 'Circuitos con tu propio peso, kettlebells y gomas para ganar fuerza y resistencia.',50,'Intermedio',16,'Zona funcional'),
  ('yoga','Yoga',      'Posturas y respiración para ganar flexibilidad y desconectar del día.',60,'Todos los niveles',14,'Sala 2'),
  ('pila','Pilates',   'Trabajo de core y postura con ejercicios controlados sobre esterilla.',55,'Todos los niveles',12,'Sala 2'),
  ('zumb','Zumba',     'Baile fitness con ritmos latinos. Se suda, y mucho, sin darse cuenta.',50,'Todos los niveles',25,'Sala principal'),
  ('pump','Body Pump', 'Tonificación con barra y discos, muchas repeticiones y música.',55,'Intermedio',18,'Sala principal'),
  ('hiit','HIIT',      'Intervalos de alta intensidad en 40 minutos. Corto, directo y exigente.',40,'Avanzado',15,'Zona funcional')
on conflict (id) do nothing;

insert into public.sessions (class_id, weekday, start_time, capacity)
select v.class_id, v.weekday, v.start_time::time, c.capacity
from (values
  ('spin',0,'07:30'),('yoga',0,'09:30'),('func',0,'18:00'),('zumb',0,'19:30'),('pump',0,'20:30'),
  ('hiit',1,'07:30'),('pila',1,'10:00'),('spin',1,'18:30'),('func',1,'19:30'),('yoga',1,'20:30'),
  ('func',2,'07:30'),('zumb',2,'09:30'),('pila',2,'18:00'),('spin',2,'19:30'),('hiit',2,'20:30'),
  ('spin',3,'07:30'),('yoga',3,'10:00'),('pump',3,'18:00'),('spin',3,'19:30'),('pila',3,'20:30'),
  ('hiit',4,'07:30'),('pump',4,'09:30'),('zumb',4,'18:00'),('func',4,'19:30'),
  ('zumb',5,'09:30'),('func',5,'10:30'),('spin',5,'11:30')
) as v(class_id, weekday, start_time)
join public.classes c on c.id = v.class_id
on conflict (class_id, weekday, start_time) do nothing;
