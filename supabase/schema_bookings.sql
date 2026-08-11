-- 1. Bang bookings - 1 lich hen cua khach hang.

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
--    CHINH MINH, khong duoc xem booking cua nguoi khac
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

-- Cho phep khach TU sua booking cua minh (dung de huy lich)
drop policy if exists "bookings_update_own" on public.bookings;
create policy "bookings_update_own"
  on public.bookings for update
  using (auth.uid() = customer_id)
  with check (auth.uid() = customer_id);