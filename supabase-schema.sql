create table if not exists public.dishes (
  id text primary key,
  name text not null,
  category text not null,
  time text not null,
  minutes integer not null default 0,
  ingredients text not null,
  tags jsonb not null default '[]'::jsonb,
  image text not null default '',
  note text not null default '',
  created_at timestamptz not null default now()
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  customer_name text not null default '家人',
  meal_time text not null default '待定',
  people_count text not null default '2人',
  note text not null default '',
  items jsonb not null default '[]'::jsonb,
  status text not null default '已下单',
  created_at timestamptz not null default now()
);

alter table public.orders
alter column status set default '已下单';

alter table public.dishes enable row level security;
alter table public.orders enable row level security;

drop policy if exists "family can read dishes" on public.dishes;
drop policy if exists "family can insert dishes" on public.dishes;
drop policy if exists "family can update dishes" on public.dishes;
drop policy if exists "family can delete dishes" on public.dishes;
drop policy if exists "family can insert orders" on public.orders;
drop policy if exists "family can read orders" on public.orders;
drop policy if exists "family can update orders" on public.orders;

create policy "family can read dishes"
on public.dishes for select
to anon
using (true);

create policy "family can insert dishes"
on public.dishes for insert
to anon
with check (true);

create policy "family can update dishes"
on public.dishes for update
to anon
using (true)
with check (true);

create policy "family can delete dishes"
on public.dishes for delete
to anon
using (true);

create policy "family can insert orders"
on public.orders for insert
to anon
with check (true);

create policy "family can read orders"
on public.orders for select
to anon
using (true);

create policy "family can update orders"
on public.orders for update
to anon
using (true)
with check (true);

insert into storage.buckets (id, name, public)
values ('dish-images', 'dish-images', true)
on conflict (id) do update set public = true;

drop policy if exists "family can read dish images" on storage.objects;
drop policy if exists "family can upload dish images" on storage.objects;
drop policy if exists "family can update dish images" on storage.objects;
drop policy if exists "family can delete dish images" on storage.objects;

create policy "family can read dish images"
on storage.objects for select
to anon
using (bucket_id = 'dish-images');

create policy "family can upload dish images"
on storage.objects for insert
to anon
with check (bucket_id = 'dish-images');

create policy "family can update dish images"
on storage.objects for update
to anon
using (bucket_id = 'dish-images')
with check (bucket_id = 'dish-images');

create policy "family can delete dish images"
on storage.objects for delete
to anon
using (bucket_id = 'dish-images');

create index if not exists dishes_category_idx on public.dishes (category);
create index if not exists orders_created_at_idx on public.orders (created_at desc);
