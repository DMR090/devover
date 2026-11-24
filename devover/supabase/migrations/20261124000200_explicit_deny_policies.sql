create policy leads_public_deny on public.leads for all to anon, authenticated using (false) with check (false);
create policy lead_rate_limits_public_deny on public.lead_rate_limits for all to anon, authenticated using (false) with check (false);
