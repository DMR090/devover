# DEVOVER

A dark, editorial website for a software and digital-solutions studio. Built with Next.js App Router, React, TypeScript, Tailwind CSS, React Three Fiber, Supabase and EmailJS.

## Local development

- Install dependencies with `pnpm install`.
- Start the development server with `pnpm dev`.
- Validate TypeScript with `pnpm exec tsc --noEmit`.
- Create a production bundle with `pnpm build`.
- Run browser tests with `pnpm exec playwright test tests/site.spec.ts`. Install Playwright Chromium in a development environment first if it is missing.

## Supabase setup

The application uses the Supabase project connected to this Vercel project. The migration in `supabase/migrations/` creates:

- `leads`, private inquiry records; public API roles have no access.
- `projects`, portfolio content; public roles can read published projects only.
- `lead_rate_limits`, a server-only rate-limit ledger.

Migrations are applied through the connected Supabase integration in v0. The current project has the schema applied. For new environments, apply the migration files in timestamp order and verify RLS is enabled before deploying. Use the Supabase integration’s table and policy tools to manage internal portfolio content and view inquiries; this site intentionally has no public login or admin screen.

## Environment configuration

Supabase URL and keys are injected by the connected integration. `SUPABASE_SERVICE_ROLE_KEY` is server-only and must never be exposed to browser code. Set `NEXT_PUBLIC_SITE_URL` to the canonical HTTPS origin for production metadata and the sitemap. `.env.example` lists the supported values; never commit actual secrets.

## EmailJS notifications

Set `EMAILJS_PUBLIC_KEY` in project environment variables. The app uses EmailJS service `service_xvymm7n`, business-notification template `template_5bqhgpj`, and client auto-reply template `template_bqniojp`. Configure the notification template to deliver to `agencydmr854@gmail.com`, with reply-to set to the submitted client email. Configure the auto-reply recipient as `{{to_email}}`.

Templates should use the supplied variables: `reference_id`, `full_name` / `user_name`, `email`, `reply_to`, `phone`, `company_name`, `services`, `source`, `project_name`, `business_description`, `project_description`, `objectives`, `required_features`, `existing_website`, `budget_range`, `timeline`, and `preferred_contact_method`. Email delivery occurs only after an inquiry is stored. Email failure does not discard the lead or show a false submission success; review server logs for delivery failures. Do not add the public key to client-side code.

## Forms and data handling

The contact form and five-step project inquiry form validate on the client and again on the server. The server checks same-origin requests, bounds the request body, validates with Zod, rejects the honeypot, applies a database-backed limit of five submissions per IP per minute, and uses a unique idempotency key. Inquiry rows are inserted only with the server-side service-role client. Public visitors cannot read or alter leads. The project endpoints return published rows only and support category filters and pagination.

## Portfolio publishing

Projects are authored internally in the Supabase `projects` table; a record appears on the site only after it is marked `published`. Supply accurate summaries, category, project type (`concept`, `internal` or `client`), status, year, technologies, features and verified case-study details. Use genuine screenshots only. The public site never invents client work, outcomes or testimonials.

## Production deployment

Connect this repository to a Vercel project, ensure the Supabase integration is attached, set `NEXT_PUBLIC_SITE_URL` and `EMAILJS_PUBLIC_KEY` for the production environment, then deploy through Vercel. Add a custom domain in project settings and update the canonical site URL to match. Confirm the EmailJS templates route correctly before using the production forms.

## Company details and legal copy

The configured contact email is `agencydmr854@gmail.com`. Update centralized service content in `lib/studio.ts`, company policy text in `lib/privacy.ts`, and metadata in `app/layout.tsx`. Privacy and Terms are drafts and require legal review before public launch. No social accounts, founder profiles, company registration status or unverified client metrics are claimed.
