-- 1. Bang profiles - luu thong tin 
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  full_name text not null default '',
  role text not null default 'customer'
    check (role in ('customer', 'owner', 'manager', 'receptionist', 'staff')),
  phone text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.profiles is
  'Thong tin mo rong cua user (ho ten, role, SDT that) - Supabase Auth mac dinh khong co san.';

do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'profiles_phone_unique'
  ) then
    alter table public.profiles add constraint profiles_phone_unique unique (phone);
  end if;
end $$;

-- ----------------------------------------------------------------------------
-- 2. Trigger: tu dong tao 1 dong `profiles` moi khi co user dang ky moi.
-- ----------------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, phone)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    new.raw_user_meta_data ->> 'phone'
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ----------------------------------------------------------------------------
-- 3. Row Level Security - chi xem/sua profile cua chinh minh, KHONG duoc tao/xoa profile tu client.
-- ----------------------------------------------------------------------------
alter table public.profiles enable row level security;

-- Moi user dang nhap chi doc duoc dung 1 dong profile cua chinh minh.
drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own"
  on public.profiles for select
  using (auth.uid() = id);

-- Moi user dang nhap chi sua duoc dung 1 dong profile cua chinh minh, va
-- KHONG duoc tu doi `role` cua chinh minh (chan leo thang quyen).
drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own"
  on public.profiles for update
  using (auth.uid() = id)
  with check (auth.uid() = id and role = (select role from public.profiles where id = auth.uid()));

-- KHONG co policy cho insert/delete tu client - chi trigger (security definer)
-- moi duoc tao dong profiles, user khong tu insert/xoa profile qua API.