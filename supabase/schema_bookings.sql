-- ============================================================================
-- BarberBook - Supabase Schema (Sprint 3: Booking Flow - Bookings)
-- An toan khi chay lai NHIEU LAN (idempotent). Chay SAU schema.sql,
-- schema_shops.sql, schema_services_staff.sql. Chay trong SQL Editor.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Bang bookings - 1 lich hen cua khach hang.
--
--    LUU Y PHAM VI Sprint 3: MOI booking chi gan 1 dich vu duy nhat (chua
--    ho tro dat nhieu dich vu/combo trong 1 lan - se mo rong o Sprint 8
--    khi lam Combo). `staff_id` co the NULL = "Bat ky tho nao".
-- ----------------------------------------------------------------------------
create table if not exists public.bookings (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.profiles (id) on delete cascade,
  shop_id uuid not null references public.shops (id) on delete restrict,
  service_id uuid not null references public.services (id) on delete restrict,
  staff_id uuid references public.staff (id) on delete set null,
  start_time timestamptz not null,
  end_time timestamptz not null,
  status text not null default 'pending'
    check (status in ('pending', 'confirmed', 'completed', 'cancelled')),
  total_price numeric(12, 0) not null default 0,
  note text,
  created_at timestamptz not null default now(),
  constraint bookings_time_check check (end_time > start_time)
);

comment on table public.bookings is 'Lich hen cua khach hang - US-BOOKING-009, US-MYBOOKING-010.';

create index if not exists bookings_customer_id_idx on public.bookings (customer_id);
create index if not exists bookings_shop_id_idx on public.bookings (shop_id);

-- ----------------------------------------------------------------------------
-- 2. Row Level Security - khach hang CHI duoc xem/tao/sua booking cua
--    CHINH MINH, khong duoc xem booking cua nguoi khac (khac voi
--    shops/services/staff la du lieu cong khai).
-- ----------------------------------------------------------------------------
alter table public.bookings enable row level security;

drop policy if exists "bookings_select_own" on public.bookings;
create policy "bookings_select_own"
  on public.bookings for select
  using (auth.uid() = customer_id);

drop policy if exists "bookings_insert_own" on public.bookings;
create policy "bookings_insert_own"
  on public.bookings for insert
  with check (auth.uid() = customer_id);

-- Cho phep khach TU sua booking cua minh (dung de huy lich o Sprint 3
-- Chuc nang 4). LUU Y: RLS o day CHUA gioi han chi duoc doi `status` sang
-- 'cancelled' (Postgres RLS kho gioi han theo tung cot don le) - viec nay
-- duoc kiem soat o TANG APP (UI chi cho phep goi update voi status =
-- 'cancelled', khong cho sua gio/gia). Neu can chat che hon o tang DB,
-- co the them trigger rieng sau.
drop policy if exists "bookings_update_own" on public.bookings;
create policy "bookings_update_own"
  on public.bookings for update
  using (auth.uid() = customer_id)
  with check (auth.uid() = customer_id);