alter table public.staff
  add column if not exists profile_id uuid references public.profiles (id) on delete set null;

-- 1 tai khoan chi duoc gan toi da 1 dong staff (khong the "la 2 tho cung luc")
create unique index if not exists staff_profile_id_unique
  on public.staff (profile_id)
  where profile_id is not null;

-- ----------------------------------------------------------------------------
-- 2. Mo rong RLS cua `bookings`:
-- ----------------------------------------------------------------------------
drop policy if exists "bookings_select_staff_or_owner" on public.bookings;
create policy "bookings_select_staff_or_owner"
  on public.bookings for select
  using (
    exists (
      select 1 from public.staff s
      where s.id = bookings.staff_id and s.profile_id = auth.uid()
    )
    or exists (
      select 1 from public.shops sh
      where sh.id = bookings.shop_id and sh.owner_id = auth.uid()
    )
  );

-- ----------------------------------------------------------------------------
-- 3. Bang leave_requests - don xin nghi cua Staff, Owner/Manager duyet.
-- ----------------------------------------------------------------------------
create table if not exists public.leave_requests (
  id uuid primary key default gen_random_uuid(),
  staff_profile_id uuid not null references public.profiles (id) on delete cascade,
  shop_id uuid not null references public.shops (id) on delete cascade,
  staff_name text not null default '',
  start_date date not null,
  end_date date not null,
  reason text,
  status text not null default 'pending' check (status in ('pending', 'approved', 'rejected')),
  reviewed_by uuid references public.profiles (id) on delete set null,
  reviewed_at timestamptz,
  created_at timestamptz not null default now(),
  constraint leave_requests_date_check check (end_date >= start_date)
);

comment on table public.leave_requests is 'Don xin nghi cua Staff - phan Staff cua US-STAFF-002.';

create index if not exists leave_requests_shop_id_idx on public.leave_requests (shop_id);

create or replace function public.set_leave_request_staff_name()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  select full_name into new.staff_name from public.profiles where id = new.staff_profile_id;
  return new;
end;
$$;

drop trigger if exists on_leave_request_insert_set_name on public.leave_requests;
create trigger on_leave_request_insert_set_name
  before insert on public.leave_requests
  for each row execute procedure public.set_leave_request_staff_name();

-- ----------------------------------------------------------------------------
-- 4. RLS cho leave_requests:
--    - SELECT: Staff xem don CUA CHINH MINH; Owner/Manager xem TAT CA don cua shop minh quan ly.
--    - INSERT: Staff CHI tao duoc don CHO CHINH MINH.
--    - UPDATE: CHI Owner/Manager duoc sua (duyet/tu choi) - Staff KHONG tu
--      sua duoc trang thai don cua minh sau khi da gui.
-- ----------------------------------------------------------------------------
alter table public.leave_requests enable row level security;

drop policy if exists "leave_requests_select" on public.leave_requests;
create policy "leave_requests_select"
  on public.leave_requests for select
  using (
    auth.uid() = staff_profile_id
    or exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role in ('owner', 'manager')
    )
  );

drop policy if exists "leave_requests_insert_own" on public.leave_requests;
create policy "leave_requests_insert_own"
  on public.leave_requests for insert
  with check (auth.uid() = staff_profile_id);

drop policy if exists "leave_requests_update_review" on public.leave_requests;
create policy "leave_requests_update_review"
  on public.leave_requests for update
  using (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role in ('owner', 'manager')
    )
  )
  with check (
    exists (
      select 1 from public.profiles p
      where p.id = auth.uid() and p.role in ('owner', 'manager')
    )
  );