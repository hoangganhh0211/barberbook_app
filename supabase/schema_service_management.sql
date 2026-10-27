begin;

do $$
begin
  if to_regclass('public.services') is null then
    raise exception 'Chua co bang public.services. Hay chay schema_services_staff.sql truoc.';
  end if;
  if to_regclass('public.shops') is null then
    raise exception 'Chua co bang public.shops. Hay chay schema_shops.sql truoc.';
  end if;
  if to_regclass('public.profiles') is null then
    raise exception 'Chua co bang public.profiles. Hay chay schema_profile.sql truoc.';
  end if;
end;
$$;

alter table public.services enable row level security;

drop policy if exists "services_select_all" on public.services;
drop policy if exists "services_select_active_or_owner" on public.services;
create policy "services_select_active_or_owner"
  on public.services
  for select
  using (
    is_active = true
    or exists (
      select 1
      from public.shops sh
      where sh.id = services.shop_id
        and sh.owner_id = (select auth.uid())
    )
  );

drop policy if exists "services_owner_insert" on public.services;
create policy "services_owner_insert"
  on public.services
  for insert
  to authenticated
  with check (
    exists (
      select 1
      from public.shops sh
      join public.profiles p on p.id = sh.owner_id
      where sh.id = services.shop_id
        and sh.owner_id = (select auth.uid())
        and p.role = 'owner'
    )
  );

drop policy if exists "services_owner_update" on public.services;
create policy "services_owner_update"
  on public.services
  for update
  to authenticated
  using (
    exists (
      select 1
      from public.shops sh
      join public.profiles p on p.id = sh.owner_id
      where sh.id = services.shop_id
        and sh.owner_id = (select auth.uid())
        and p.role = 'owner'
    )
  )
  with check (
    exists (
      select 1
      from public.shops sh
      join public.profiles p on p.id = sh.owner_id
      where sh.id = services.shop_id
        and sh.owner_id = (select auth.uid())
        and p.role = 'owner'
    )
  );

grant select on public.services to anon, authenticated;
grant insert, update on public.services to authenticated;

create index if not exists services_shop_active_idx
  on public.services (shop_id, is_active);

commit;
