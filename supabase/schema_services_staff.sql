-- 1. Bang services - danh sach dich vu cua 1 tiem.
create table if not exists public.services (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops (id) on delete cascade,
  name text not null,
  description text,
  price numeric(12, 0) not null default 0, -- VND, so nguyen (khong co phan le)
  duration_minutes int not null default 30 check (duration_minutes > 0),
  image_url text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

comment on table public.services is 'Dich vu cua 1 tiem - dung o buoc 1 luong Dat lich (US-BOOKING-009).';

-- ----------------------------------------------------------------------------
-- 2. Bang staff - danh sach "Tho" HIEN THI cho khach chon khi dat lich.
-- ----------------------------------------------------------------------------
create table if not exists public.staff (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops (id) on delete cascade,
  full_name text not null,
  avatar_url text,
  bio text,
  rating numeric(2, 1) not null default 0 check (rating >= 0 and rating <= 5),
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

comment on table public.staff is 'Danh sach Tho hien thi cho khach chon khi dat lich - xem LUU Y ve pham vi o tren.';

-- ----------------------------------------------------------------------------
-- 3. RLS - cong khai doc (giong `shops`), khach chua dang nhap van xem duoc
--    de quyet dinh co dang ky khong.
-- ----------------------------------------------------------------------------
alter table public.services enable row level security;
drop policy if exists "services_select_all" on public.services;
create policy "services_select_all" on public.services for select using (true);

alter table public.staff enable row level security;
drop policy if exists "staff_select_all" on public.staff;
create policy "staff_select_all" on public.staff for select using (true);
