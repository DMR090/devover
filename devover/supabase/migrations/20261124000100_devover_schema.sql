create extension if not exists pgcrypto;

create or replace function public.set_updated_at()
returns trigger language plpgsql set search_path = '' as $$
begin new.updated_at = now(); return new; end;
$$;

create table public.leads (
  id uuid primary key default gen_random_uuid(),
  reference_id text not null unique,
  idempotency_key uuid not null unique,
  source text not null check (source in ('contact_form','project_inquiry')),
  full_name text not null check (length(btrim(full_name)) between 1 and 160),
  email text not null check (length(email) <= 254),
  phone text,
  company_name text,
  services text[] not null check (cardinality(services) between 1 and 7),
  project_name text,
  business_description text,
  project_description text not null,
  objectives text,
  required_features text,
  existing_website text,
  budget_range text,
  timeline text,
  preferred_contact_method text,
  privacy_consent boolean not null check (privacy_consent),
  consent_at timestamptz not null,
  privacy_policy_version text not null,
  status text not null default 'new' check (status in ('new','contacted','qualified','proposal_sent','accepted','rejected','archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index leads_created_at_idx on public.leads (created_at desc);
create index leads_status_created_at_idx on public.leads (status, created_at desc);
create trigger leads_set_updated_at before update on public.leads for each row execute function public.set_updated_at();
alter table public.leads enable row level security;
revoke all on public.leads from anon, authenticated;
grant all on public.leads to service_role;

create table public.projects (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique check (slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
  title text not null,
  category text not null check (category in ('Web Development','Mobile Applications','Custom Software','UI/UX Design','Creative Media')),
  summary text not null,
  description text not null,
  challenge text,
  solution text,
  technologies text[] not null default '{}',
  features text[] not null default '{}',
  project_type text not null check (project_type in ('concept','internal','client')),
  project_status text not null check (project_status in ('planned','in_development','completed','launched')),
  year integer not null check (year between 2000 and 2100),
  cover_image text,
  project_url text,
  featured boolean not null default false,
  published boolean not null default false,
  display_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index projects_published_order_idx on public.projects (published, display_order, year desc);
create index projects_featured_idx on public.projects (featured, display_order) where published = true;
create trigger projects_set_updated_at before update on public.projects for each row execute function public.set_updated_at();
alter table public.projects enable row level security;
revoke all on public.projects from anon, authenticated;
grant select on public.projects to anon, authenticated;
create policy projects_read_published on public.projects for select to anon, authenticated using (published = true);
grant all on public.projects to service_role;

create table public.lead_rate_limits (
  ip_digest text not null,
  window_start timestamptz not null,
  hit_count integer not null default 1 check (hit_count > 0),
  primary key (ip_digest, window_start)
);
alter table public.lead_rate_limits enable row level security;
revoke all on public.lead_rate_limits from anon, authenticated;
grant all on public.lead_rate_limits to service_role;

create or replace function public.consume_lead_rate_limit(p_ip_digest text, p_window_start timestamptz)
returns boolean language plpgsql security definer set search_path = '' as $$
declare v_hits integer;
begin
  delete from public.lead_rate_limits where window_start < now() - interval '10 minutes';
  insert into public.lead_rate_limits (ip_digest, window_start) values (p_ip_digest, p_window_start)
  on conflict (ip_digest, window_start) do update set hit_count = public.lead_rate_limits.hit_count + 1
  returning hit_count into v_hits;
  return v_hits <= 5;
end;
$$;
revoke all on function public.consume_lead_rate_limit(text, timestamptz) from public, anon, authenticated;
grant execute on function public.consume_lead_rate_limit(text, timestamptz) to service_role;
