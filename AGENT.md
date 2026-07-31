# AGENT.md — 004 PlayerPath

## Project Purpose

PlayerPath is a cross-platform mobile application (iOS & Android) connecting grassroots, semi-professional, and non-league football players with clubs, scouts, and managers. Think LinkedIn × Transfermarkt × Tinder for football recruitment.

## Coding Standards

- **Flutter/Dart:** Follow Effective Dart guidelines. Use `flutter_lints` (strict).
- **NestJS/TypeScript:** Follow NestJS conventions. Use ESLint + Prettier.
- **Modular architecture** — feature-based folder structure.
- **Meaningful names** — no abbreviations unless widely known (e.g. `id`, `url`).
- **Keep functions focused** — single responsibility.
- **Comment only when intent isn't obvious from code.**
- **No duplicated logic** — extract shared utilities.
- **Tests alongside code** — `*.test.dart`, `*.spec.ts`.

## Architecture

### Mobile (Flutter)
```
lib/
├── app/            # App config, routes, theme
├── core/           # Shared: network, storage, constants, utils
├── features/       # Feature modules (auth, profile, search, etc.)
│   ├── auth/
│   │   ├── data/       # Repositories, DTOs
│   │   ├── domain/     # Entities, use cases
│   │   └── presentation/  # Screens, widgets, BLoC/Cubit
│   └── ...
└── l10n/           # Localization
```

### Backend (NestJS)
```
src/
├── config/         # Environment, DB, Redis config
├── modules/        # Feature modules
│   ├── auth/
│   ├── users/
│   ├── clubs/
│   ├── players/
│   ├── matching/
│   ├── messaging/
│   └── ...
├── common/         # Guards, decorators, filters, interceptors
└── main.ts
```

### State Management
- **Flutter:** BLoC/Cubit (predictable, testable, scalable)

### Data Flow
- Repository Pattern — clean separation between data sources and business logic
- DTOs for API communication
- Entities for domain layer

## Naming Conventions

| Context | Convention | Example |
|---------|-----------|---------|
| Dart files | snake_case | `player_profile_screen.dart` |
| Dart classes | PascalCase | `PlayerProfileBloc` |
| Dart variables | camelCase | `preferredFoot` |
| TypeScript files | kebab-case | `player-profile.service.ts` |
| TypeScript classes | PascalCase | `PlayerProfileService` |
| DB tables | snake_case plural | `player_profiles` |
| API routes | kebab-case | `/api/player-profiles` |

## Documentation Rules

- Important decisions → `docs/decisions.md`
- API endpoints → `docs/api.md`
- Architecture changes → `docs/architecture.md`
- Requirements → `docs/requirements.md`
- Roadmap → `docs/roadmap.md`

## Testing Requirements

- **Unit tests** for all business logic (BLoC, services, use cases)
- **Widget tests** for critical UI components
- **Integration tests** for key user flows
- **Backend:** Jest with Supertest for e2e
- Coverage target: 80%+

## Logging Requirements

- Work logs: `logs/work/YYYY-MM-DD.md`
- Change logs: `logs/changes/YYYY-MM-DD.md`
- Backend: structured logging (Pino/Winston)
- Mobile: Crashlytics in production

## Temporary Folder Rules

- `temp/` is AI working memory only
- No production code, docs, or release assets in `temp/`
- Clean periodically

## Deployment Notes

- Docker Compose for local dev
- Kubernetes for production
- CI/CD via GitHub Actions
- App distribution via App Store Connect + Google Play Console

## Files That Should Not Be Modified Without Instruction

- `AGENT.md`
- `INDEX.md` structure
- `logs/` entries (append only)

## Future Roadmap

See `docs/roadmap.md`

## Known Risks

- Video storage costs at scale — plan CDN/caching early
- Real-time messaging at scale — load-test Socket.IO
- GDPR compliance for user data — legal review before production
- App Store review for user-generated content — moderation tools needed
