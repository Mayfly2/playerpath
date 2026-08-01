# INDEX.md — 004 PlayerPath

## Project Information

- **Number:** 004
- **Name:** PlayerPath
- **Created:** 2025-07-16
- **Version:** v0.3.0
- **Status:** Planning (Phase 1 MVP polish complete)
- **Stack:** Flutter + NestJS + PostgreSQL + Redis + Elasticsearch

## Current Milestone

**Phase 1 — MVP:** Auth, Player/Club profiles, Search & Discovery, Basic matching. **Backend + Frontend connected and running. App polished for distribution.**

## Completed Milestones

- [x] Project scaffolded
- [x] Full requirements captured from product spec
- [x] Architecture decisions documented

## Outstanding Tasks

### Phase 1 — MVP
- [x] Flutter project initialization (structure complete, web platform files generated)
- [x] App runs on web at `localhost:55555` (0 analysis errors)
- [x] Backend running at `localhost:3000` (SQLite, 34 API endpoints)
- [x] Flutter ↔ Backend connected (auth flow verified end-to-end)
- [x] NestJS backend initialization (12 modules, 0 TS errors)
- [x] Database schema design (12 TypeORM entities)
- [x] Authentication (Email + Google + Apple, JWT + refresh tokens)
- [x] Player profile CRUD with positions, statistics, club history
- [x] Club profile CRUD
- [x] Player search with advanced filters (geo, age, height, stats, county, step)
- [x] Club search with filters (league, step, radius, trials)
- [x] Basic matching algorithm (5-factor scoring, match tiers)
- [x] Dark/Light mode theming (ThemeCubit, full dark scheme, persisted)
- [x] Auth guard on routes (redirects unauthenticated → /login)
- [x] Bottom navigation shell (5 tabs)
- [x] Auth screens (Login, Signup with full UI)
- [ ] Video upload infrastructure
- [ ] File upload (Multer/S3 integration)
- [ ] WebSocket realtime gateway
- [ ] Unit tests
- [ ] CI/CD pipeline (GitHub Actions)

### Phase 2 — Beta
- [ ] Messaging platform (invite-accept model)
- [ ] Video upload & streaming
- [ ] Trial invitations
- [ ] Push notifications
- [ ] Saved lists & shortlists
- [ ] Home feed

### Phase 3 — Production
- [ ] AI matching engine
- [ ] Premium subscriptions
- [ ] Admin panel
- [ ] UI polish & animations
- [ ] App Store deployment

## Folder Map

```
004 PlayerPath/
├── AGENT.md
├── INDEX.md              ← You are here
├── README.md
├── docs/
│   ├── architecture.md
│   ├── requirements.md
│   ├── decisions.md
│   ├── roadmap.md
│   └── api.md
├── logs/
│   ├── work/
│   └── changes/
├── temp/
│   ├── notes/
│   ├── experiments/
│   ├── prompts/
│   └── scratch/
├── mobile/               # Flutter app (to be created)
├── backend/              # NestJS API (to be created)
├── tests/
├── assets/
└── archive/
```

## Important Files

- `README.md` — Full product overview
- `docs/requirements.md` — Complete requirements from spec
- `docs/architecture.md` — System architecture
- `docs/roadmap.md` — Phased delivery plan
- `AGENT.md` — Coding standards and conventions

## Architecture Overview

- **Mobile:** Flutter with BLoC state management, clean architecture (data/domain/presentation)
- **Backend:** NestJS with modular architecture, JWT + OAuth, WebSocket realtime
- **Search:** Elasticsearch for fast player/club discovery
- **Storage:** Cloud object storage for images and video
- **Infra:** Docker Compose local, Kubernetes production, GitHub Actions CI/CD

## Dependencies

- Flutter SDK 3.x+
- Node.js 20+
- PostgreSQL 16+
- Redis 7+
- Elasticsearch 8+
- Docker

## Current Blockers

None.

## Next Recommended Task

Push to GitHub → Set up Codemagic → Configure Apple Developer → First iOS build to iPhone.

## Recent Work Logs

- 2025-07-31 (Session 2): Brand unification (ScoutMe→PlayerPath), dark theme, auth guard, shimmer loading, push to GitHub
- 2025-07-31: Flutter platforms regenerated, Git init, Codemagic CI/CD configured for iOS builds
- 2025-07-30: Flutter SDK installed, Chrome configured, 8 compilation errors fixed, app running on web
- 2025-07-16: Project scaffold created; full requirements documented from product spec

## Recent Change Logs

- 2025-07-31: iOS/Android platforms regenerated, Git repo init, codemagic.yaml created
- 2025-07-30: Dependencies updated, compilation errors fixed, web platform generated
- 2025-07-16: Initial structure created; README, AGENT.md, docs fully populated from spec
