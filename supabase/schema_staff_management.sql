drop policy if exists "staff_insert_owner" on public.staff;
create policy "staff_insert_owner"
  on public.staff for insert
  with check (
    exists (select 1 from public.shops sh where sh.id = shop_id and sh.owner_id = auth.uid())
  );

drop policy if exists "staff_update_owner" on public.staff;
create policy "staff_update_owner"
  on public.staff for update
  using (
    exists (select 1 from public.shops sh where sh.id = shop_id and sh.owner_id = auth.uid())
  )
  with check (
    exists (select 1 from public.shops sh where sh.id = shop_id and sh.owner_id = auth.uid())
  );

drop policy if exists "staff_delete_owner" on public.staff;
create policy "staff_delete_owner"
  on public.staff for delete
  using (
    exists (select 1 from public.shops sh where sh.id = shop_id and sh.owner_id = auth.uid())
  );


create or replace function public.link_staff_to_profile(p_staff_id uuid, p_phone text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_shop_id uuid;
  v_owner_id uuid;
  v_profile_id uuid;
begin
  select shop_id into v_shop_id from public.staff where id = p_staff_id;
  if v_shop_id is null then
    raise exception 'Không tìm thấy thợ này.';
  end if;

  select owner_id into v_owner_id from public.shops where id = v_shop_id;
  if v_owner_id is null or v_owner_id <> auth.uid() then
    raise exception 'Bạn không có quyền gán tài khoản cho thợ này.';
  end if;

  select id into v_profile_id from public.profiles where phone = p_phone;
  if v_profile_id is null then
    raise exception 'Không tìm thấy tài khoản với số điện thoại này. Người đó cần đăng ký tài khoản trước.';
  end if;

  if exists (select 1 from public.staff where profile_id = v_profile_id) then
    raise exception 'Tài khoản này đã được gán cho 1 thợ khác.';
  end if;

  update public.staff set profile_id = v_profile_id where id = p_staff_id;
  update public.profiles set role = 'staff' where id = v_profile_id and role = 'customer';
end;
$$;

grant execute on function public.link_staff_to_profile(uuid, text) to authenticated;

create or replace function public.unlink_staff_profile(p_staff_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_shop_id uuid;
  v_owner_id uuid;
begin
  select shop_id into v_shop_id from public.staff where id = p_staff_id;
  if v_shop_id is null then
    raise exception 'Không tìm thấy thợ này.';
  end if;

  select owner_id into v_owner_id from public.shops where id = v_shop_id;
  if v_owner_id is null or v_owner_id <> auth.uid() then
    raise exception 'Bạn không có quyền thao tác với thợ này.';
  end if;

  update public.staff set profile_id = null where id = p_staff_id;
end;
$$;

grant execute on function public.unlink_staff_profile(uuid) to authenticated;