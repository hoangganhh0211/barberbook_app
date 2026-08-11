-- 1. Bang shops - thong tin tiem cat toc.
create table if not exists public.shops (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid references public.profiles (id) on delete set null,
  name text not null,
  description text,
  address text not null,
  phone text,
  cover_image_url text,
  rating numeric(2, 1) not null default 0 check (rating >= 0 and rating <= 5),
  is_open boolean not null default true,
  latitude double precision,
  longitude double precision,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.shops is 'Thong tin tiem cat toc - hien thi o Customer App (Home/Tiem/Chi tiet Tiem).';

-- ----------------------------------------------------------------------------
-- 2. Row Level Security - cong khai doc (giong `services`/`staff`), khach chua dang nhap van xem duoc
-- ----------------------------------------------------------------------------
alter table public.shops enable row level security;

drop policy if exists "shops_select_all" on public.shops;
create policy "shops_select_all"
  on public.shops for select
  using (true);

