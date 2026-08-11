-- 1. Bang reviews - 1 danh gia gan voi DUY NHAT 1 booking
  id uuid primary key default gen_random_uuid(),
  booking_id uuid not null unique references public.bookings (id) on delete cascade,
  customer_id uuid not null references public.profiles (id) on delete cascade,
  shop_id uuid not null references public.shops (id) on delete cascade,
  customer_name text not null default '',
  rating smallint not null check (rating between 1 and 5),
  comment text,
  created_at timestamptz not null default now()
);

comment on table public.reviews is 'Danh gia cua khach hang sau khi hoan tat booking - US-REVIEW-011.';

create index if not exists reviews_shop_id_idx on public.reviews (shop_id);

-- ----------------------------------------------------------------------------
-- 2. Trigger: tu dong dien `customer_name` tu `profiles.full_name`
-- ----------------------------------------------------------------------------
create or replace function public.set_review_customer_name()
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

drop trigger if exists on_review_insert_set_name on public.reviews;
create trigger on_review_insert_set_name
  before insert on public.reviews
  for each row execute procedure public.set_review_customer_name();

-- ----------------------------------------------------------------------------
-- 3. Trigger: tu dong cap nhat lai `shops.rating` = trung binh cong tat ca danh gia cua tiem do 
-- ----------------------------------------------------------------------------
create or replace function public.update_shop_rating()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.shops
  set rating = coalesce(
    (select round(avg(rating)::numeric, 1) from public.reviews where shop_id = new.shop_id),
    0
  )
  where id = new.shop_id;
  return new;
end;
$$;

drop trigger if exists on_review_created_update_rating on public.reviews;
create trigger on_review_created_update_rating
  after insert on public.reviews
  for each row execute procedure public.update_shop_rating();

-- ----------------------------------------------------------------------------
-- 4. Row Level Security
--    - SELECT: cong khai (giong shops) - ai cung xem duoc danh gia.
--    - INSERT: chi khach SO HUU booking, VA booking phai o trang thai 'completed' 
-- ----------------------------------------------------------------------------
alter table public.reviews enable row level security;

drop policy if exists "reviews_select_all" on public.reviews;
create policy "reviews_select_all"
  on public.reviews for select
  using (true);

drop policy if exists "reviews_insert_own_completed" on public.reviews;
create policy "reviews_insert_own_completed"
  on public.reviews for insert
  with check (
    auth.uid() = customer_id
    and exists (
      select 1 from public.bookings b
      where b.id = booking_id and b.customer_id = auth.uid() and b.status = 'completed'
    )
  );