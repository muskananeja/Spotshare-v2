-- Run this once in the Supabase SQL Editor, on the NEW project
-- (the two prior projects — dojacrbhqzaptbkmhjrv and bmlesyzadmsfbrgczwgu —
-- are both DNS-dead, not paused; do not reuse those IDs).
--
-- Requires the `spots` table to already exist (see seed-spots.sql).
--
-- Project: <fill in new project ref after creating it>

-- ============================================================
-- spot_reports — user-submitted status reports, one row per report.
-- Immutable log: never updated or deleted by the client. "Current
-- status" is derived from this table by the spot_current_status view
-- below, not stored redundantly here.
-- ============================================================
create table if not exists public.spot_reports (
  id bigint generated always as identity primary key,
  spot_id bigint not null references public.spots(id) on delete cascade,
  status text not null check (status in ('open', 'limited')),
  reported_at timestamptz not null default now(),
  reporter_id uuid not null
);

-- speeds up "most recent report for this spot" (used by the view below)
create index if not exists spot_reports_spot_id_reported_at_idx
  on public.spot_reports (spot_id, reported_at desc);

alter table public.spot_reports enable row level security;

drop policy if exists "Public read access" on public.spot_reports;
create policy "Public read access"
  on public.spot_reports for select
  using (true);

-- SPAM TRADEOFF, accepted deliberately: there is no auth yet, so this
-- policy lets *anyone* who can reach this endpoint — not just the app's
-- UI — insert an arbitrary report for any spot_id with any reporter_id.
-- No rate limiting, no ownership check, no CAPTCHA. Building real abuse
-- protection (auth, a server-side validation layer, per-reporter
-- cooldowns) before there's enough real traffic to be worth abusing is
-- solving a problem that doesn't exist yet. Revisit this policy before,
-- or as soon as, real usage makes spam plausible.
drop policy if exists "Public insert access" on public.spot_reports;
create policy "Public insert access"
  on public.spot_reports for insert
  with check (true);

-- PostgREST needs an explicit grant on top of RLS to expose this table
-- to the anon/authenticated roles. No separate sequence grant needed —
-- unlike old-style `serial`, GENERATED ALWAYS AS IDENTITY doesn't
-- require the inserting role to have USAGE on the underlying sequence.
grant select, insert on public.spot_reports to anon, authenticated;

-- ============================================================
-- spot_current_status — one row per spot, derived (not stored):
-- the most recent report within the freshness window if one exists,
-- otherwise the spot's static seed status from `spots`.
--
-- Freshness window: 30 minutes. Change the interval below to adjust.
--
-- security_invoker (Postgres 15+, Supabase's default for new projects)
-- makes the view enforce RLS as the querying role rather than the view
-- owner's — harmless here since both underlying tables are fully
-- public-read anyway, but correct practice regardless.
-- ============================================================
create or replace view public.spot_current_status
with (security_invoker = true) as
select
  s.id as spot_id,
  coalesce(r.status, s.status) as status,
  r.reported_at as last_reported_at,
  (r.status is not null) as is_live_reported
from public.spots s
left join lateral (
  select sr.status, sr.reported_at
  from public.spot_reports sr
  where sr.spot_id = s.id
    and sr.reported_at > now() - interval '30 minutes'
  order by sr.reported_at desc
  limit 1
) r on true;

grant select on public.spot_current_status to anon, authenticated;

-- If PostgREST doesn't pick up the new table/view immediately, use
-- Supabase dashboard → Settings → API → "Reload schema cache".
