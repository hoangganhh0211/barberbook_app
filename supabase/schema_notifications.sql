-- ============================================================================
-- BarberBook - Supabase Schema (Sprint 4: Trung tam Thong bao - US-NOTIFY-012)
-- An toan khi chay lai NHIEU LAN (idempotent). Chay SAU schema_bookings.sql.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Bang notifications - thong bao trong app (rieng biet voi Push
--    Notification that qua Firebase - xem ghi chu pham vi trong hoi thoai).
-- ----------------------------------------------------------------------------
create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.profiles (id) on delete cascade,
  title text not null,
  body text not null,
  type text not null default 'general' check (type in ('general', 'booking', 'promotion')),
  related_booking_id uuid references public.bookings (id) on delete set null,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

comment on table public.notifications is 'Thong bao trong app - US-NOTIFY-012.';

create index if not exists notifications_customer_id_idx on public.notifications (customer_id);

-- ----------------------------------------------------------------------------
-- 2. Trigger: TU DONG sinh thong bao khi booking duoc TAO MOI hoac DOI
--    `status`. Day la nguon thong bao DUY NHAT o Sprint 4 (chua co Partner
--    Dashboard de Owner/Staff tu xac nhan/huy - Sprint 6-7). Khi Partner
--    App hoan thien va tu doi status qua UPDATE binh thuong (khong phai
--    thao tac dac biet), trigger nay se TU DONG hoat dong dung, KHONG can
--    sua gi them.
-- ----------------------------------------------------------------------------
create or replace function public.notify_booking_change()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_title text;
  v_body text;
begin
  if TG_OP = 'INSERT' then
    v_title := 'Đặt lịch thành công';
    v_body := 'Lịch hẹn của bạn đã được ghi nhận và đang chờ tiệm xác nhận.';
  elsif TG_OP = 'UPDATE' and new.status is distinct from old.status then
    case new.status
      when 'confirmed' then
        v_title := 'Lịch hẹn đã được xác nhận';
        v_body := 'Tiệm đã xác nhận lịch hẹn của bạn. Hẹn gặp bạn đúng giờ nhé!';
      when 'cancelled' then
        v_title := 'Lịch hẹn đã bị huỷ';
        v_body := 'Lịch hẹn của bạn đã được huỷ.';
      when 'completed' then
        v_title := 'Dịch vụ đã hoàn tất';
        v_body := 'Cảm ơn bạn đã sử dụng dịch vụ! Hãy chia sẻ trải nghiệm bằng cách đánh giá tiệm nhé.';
      else
        return new;
    end case;
  else
    return new;
  end if;

  insert into public.notifications (customer_id, title, body, type, related_booking_id)
  values (new.customer_id, v_title, v_body, 'booking', new.id);

  return new;
end;
$$;

drop trigger if exists on_booking_notify on public.bookings;
create trigger on_booking_notify
  after insert or update on public.bookings
  for each row execute procedure public.notify_booking_change();

-- ----------------------------------------------------------------------------
-- 3. Row Level Security - chi xem/sua (danh dau da doc) thong bao CUA
--    CHINH MINH. KHONG co policy INSERT/DELETE cho client - chi trigger
--    (security definer) moi duoc tao thong bao.
-- ----------------------------------------------------------------------------
alter table public.notifications enable row level security;

drop policy if exists "notifications_select_own" on public.notifications;
create policy "notifications_select_own"
  on public.notifications for select
  using (auth.uid() = customer_id);

drop policy if exists "notifications_update_own" on public.notifications;
create policy "notifications_update_own"
  on public.notifications for update
  using (auth.uid() = customer_id)
  with check (auth.uid() = customer_id);