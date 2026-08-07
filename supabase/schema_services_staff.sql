-- ============================================================================
-- BarberBook - Supabase Schema (Sprint 3: Booking Flow - Dich vu & Tho)
-- An toan khi chay lai NHIEU LAN (idempotent). Chay SAU schema.sql va
-- schema_shops.sql. Chay trong Supabase Dashboard > SQL Editor.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Bang services - danh sach dich vu cua 1 tiem (cat toc, uon, nhuom...).
-- ----------------------------------------------------------------------------
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
--
--    LUU Y QUAN TRONG: bang nay KHONG lien ket voi `auth.users`/`profiles`
--    (Sprint 3 CHUA co he thong tai khoan dang nhap cho Staff - thuoc pham
--    vi Sprint 6/7 "Quan ly Nhan su"). Khi Sprint 6/7 hoan thien, se can 1
--    migration RIENG de them cot `profile_id` lien ket 2 bang nay lai -
--    KHONG lam trong file nay de tranh pha vo du lieu dat lich da co san.
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

-- ----------------------------------------------------------------------------
-- 4. Du lieu mau - gan vao tiem "The Heritage Guild" (da seed o Sprint 2)
--    de test UI ngay. Xoa di khi co du lieu that tu Partner App.
-- ----------------------------------------------------------------------------
do $$
declare
  v_shop_id uuid;
begin
  select id into v_shop_id from public.shops where name = 'The Heritage Guild' limit 1;

  if v_shop_id is not null then
    insert into public.services (shop_id, name, description, price, duration_minutes)
    select * from (values
      (v_shop_id, 'Cắt tóc nam', 'Cắt gọn gàng theo phong cách bạn chọn.', 100000::numeric, 30),
      (v_shop_id, 'Cạo mặt truyền thống', 'Dùng dao cạo truyền thống, thư giãn.', 80000::numeric, 20),
      (v_shop_id, 'Gội đầu dưỡng sinh', 'Massage thư giãn kết hợp gội đầu.', 120000::numeric, 40)
    ) as seed(shop_id, name, description, price, duration_minutes)
    where not exists (
      select 1 from public.services where public.services.shop_id = seed.shop_id and public.services.name = seed.name
    );

    insert into public.staff (shop_id, full_name, bio, rating)
    select * from (values
      (v_shop_id, 'Anh Minh', 'Hơn 5 năm kinh nghiệm, chuyên cắt tóc nam cổ điển.', 4.9::numeric),
      (v_shop_id, 'Anh Tuấn', 'Chuyên fade & tạo kiểu hiện đại.', 4.6::numeric)
    ) as seed(shop_id, full_name, bio, rating)
    where not exists (
      select 1 from public.staff where public.staff.shop_id = seed.shop_id and public.staff.full_name = seed.full_name
    );
  end if;
end $$;