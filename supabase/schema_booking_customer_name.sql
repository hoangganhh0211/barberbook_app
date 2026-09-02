-- ============================================================================
-- BarberBook - Supabase Schema (Sprint 6 bo sung: customer_name tren bookings)
-- An toan khi chay lai NHIEU LAN (idempotent). Chay SAU schema_staff_schedule.sql.
--
-- LY DO: man "Lich lam viec cua toi" (Staff) can biet TEN KHACH HANG cua
-- moi lich hen duoc giao - nhung KHONG the join truc tiep voi `profiles`
-- luc doc (RLS cua `profiles` chi cho xem ho so CUA CHINH MINH, xem
-- `schema.sql`). Dung LAI dung pattern da ap dung cho `reviews.customer_name`
-- (Sprint 4) va `leave_requests.staff_name` (Sprint 6): luu SNAPSHOT ten
-- qua trigger, khong join lai.
-- ============================================================================

alter table public.bookings add column if not exists customer_name text not null default '';

create or replace function public.set_booking_customer_name()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  select full_name into new.customer_name from public.profiles where id = new.customer_id;
  return new;
end;
$$;

drop trigger if exists on_booking_insert_set_customer_name on public.bookings;
create trigger on_booking_insert_set_customer_name
  before insert on public.bookings
  for each row execute procedure public.set_booking_customer_name();

-- LUU Y: trigger CHI ap dung cho booking TAO MOI sau khi chay migration
-- nay - cac booking cu (tao truoc do) se co `customer_name` rong (''), vi
-- Postgres KHONG tu dong chay lai trigger cho du lieu da co san. Neu can
-- dien lai cho du lieu cu, chay rieng:
--
-- update public.bookings b
-- set customer_name = p.full_name
-- from public.profiles p
-- where p.id = b.customer_id and b.customer_name = '';