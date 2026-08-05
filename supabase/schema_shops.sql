-- ============================================================================
-- BarberBook - Supabase Schema (Sprint 2: Customer Home & Tiem)
-- An toan khi chay lai NHIEU LAN (idempotent) - chay SAU khi da chay
-- schema.sql (Sprint 1). Chay trong Supabase Dashboard > SQL Editor.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Bang shops - thong tin tiem cat toc. `owner_id` de san cho Sprint 6-8
--    (Partner App quan ly tiem cua minh) - Sprint 2 CHUA dung field nay.
-- ----------------------------------------------------------------------------
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
-- 2. Row Level Security - danh sach tiem la thong tin CONG KHAI (khach hang
--    chua dang nhap cung phai xem duoc de quyet dinh co dang ky khong), nen
--    cho phep SELECT tu do. Insert/Update/Delete se rang buoc chat hon o
--    Sprint 6-8 khi Partner App can quan ly tiem cua minh - Sprint 2 CHUA
--    can policy do (chua co man nao trong app duoc phep sua bang nay).
-- ----------------------------------------------------------------------------
alter table public.shops enable row level security;

drop policy if exists "shops_select_all" on public.shops;
create policy "shops_select_all"
  on public.shops for select
  using (true);

-- ----------------------------------------------------------------------------
-- 3. Du lieu mau de test UI ngay (xoa di khi co du lieu that tu Partner App).
-- ----------------------------------------------------------------------------
insert into public.shops (name, description, address, phone, rating, is_open, cover_image_url)
select * from (values
  ('The Heritage Guild', 'Barbershop phong cach co dien, khong gian sang trong.', '12 Ly Thuong Kiet, Hoan Kiem, Ha Noi', '0912345678', 4.8, true, null),
  ('Urban Fade Studio', 'Chuyen fade & undercut theo xu huong Han Quoc.', '45 Nguyen Trai, Thanh Xuan, Ha Noi', '0987654321', 4.5, true, null),
  ('Old Town Barber', 'Tiem cat toc lau nam, tho tay nghe cao.', '8 Hang Bac, Hoan Kiem, Ha Noi', '0909090909', 4.2, false, null)
) as seed(name, description, address, phone, rating, is_open, cover_image_url)
where not exists (select 1 from public.shops where public.shops.name = seed.name);
