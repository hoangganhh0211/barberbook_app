-- ============================================================================
-- BarberBook - Supabase Schema (Sprint 1: Auth)
-- Chay toan bo file nay trong Supabase Dashboard > SQL Editor > New query
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Bang profiles - luu thong tin mo rong ma Supabase Auth khong co san
--    (full_name, role). Lien ket 1-1 voi auth.users qua khoa chinh `id`.
-- ----------------------------------------------------------------------------
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  full_name text not null default '',
  -- Gia tri phai khop CHINH XAC voi UserRole.fromServerValue() trong Flutter
  -- (lib/core/enums/user_role.dart) - doi 1 ben PHAI doi ca 2.
  role text not null default 'customer'
    check (role in ('customer', 'owner', 'manager', 'receptionist', 'staff')),
  phone text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.profiles is
  'Thong tin mo rong cua user (ho ten, role) - Supabase Auth mac dinh khong co san 2 field nay.';

-- ----------------------------------------------------------------------------
-- 2. Trigger: tu dong tao 1 dong `profiles` moi khi co user dang ky moi.
--    `full_name` doc tu `raw_user_meta_data` (duoc AuthService.signUpWithPhonePassword
--    truyen vao qua tham so `data: {'full_name': fullName}`).
--    `role` mac dinh la 'customer' - tai khoan Owner/Staff can duoc set thu
--    cong trong Dashboard (Table Editor > profiles > sua cot role) cho toi
--    khi co tinh nang "Moi nhan vien" o Sprint 6/7.
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
    new.phone
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ----------------------------------------------------------------------------
-- 3. Row Level Security - BAT BUOC, neu khong bat RLS thi bat ky ai co
--    anon key (nam san trong app) deu doc/sua duoc TOAN BO du lieu user khac.
-- ----------------------------------------------------------------------------
alter table public.profiles enable row level security;

-- Moi user dang nhap chi doc duoc dung 1 dong profile cua chinh minh.
create policy "profiles_select_own"
  on public.profiles for select
  using (auth.uid() = id);

-- Moi user dang nhap chi sua duoc dung 1 dong profile cua chinh minh, va
-- KHONG duoc tu doi `role` cua chinh minh (chan leo thang quyen).
create policy "profiles_update_own"
  on public.profiles for update
  using (auth.uid() = id)
  with check (auth.uid() = id and role = (select role from public.profiles where id = auth.uid()));

-- KHONG co policy cho insert/delete tu client - chi trigger (security definer)
-- moi duoc tao dong profiles, user khong tu insert/xoa profile qua API.