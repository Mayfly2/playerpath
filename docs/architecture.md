# Architecture — PlayerPath

## System Overview

```
┌─────────────────────────────────────────────────┐
│                  Mobile Clients                   │
│         Flutter (iOS + Android)                  │
│         BLoC State Management                    │
└──────────────────┬──────────────────────────────┘
                   │ HTTPS + WSS
┌──────────────────▼──────────────────────────────┐
│               API Gateway / Load Balancer        │
└──────────────────┬──────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────┐
│              NestJS Backend (Docker)              │
│  ┌──────────┐ ┌──────────┐ ┌──────────────────┐ │
│  │ Auth     │ │ Players  │ │ Clubs            │ │
│  │ Module   │ │ Module   │ │ Module           │ │
│  ├──────────┤ ├──────────┤ ├──────────────────┤ │
│  │ Search   │ │ Matching │ │ Messaging        │ │
│  │ Module   │ │ Module   │ │ Module (WS)      │ │
│  ├──────────┤ ├──────────┤ ├──────────────────┤ │
│  │ Video    │ │ Trial    │ │ Notifications    │ │
│  │ Module   │ │ Module   │ │ Module           │ │
│  └──────────┘ └──────────┘ └──────────────────┘ │
└───┬─────────────┬─────────────┬─────────────────┘
    │             │             │
┌───▼───┐  ┌──────▼──────┐  ┌─▼──────────────┐
│Postgre│  │   Redis     │  │ Elasticsearch   │
│  SQL  │  │  (Cache +   │  │  (Full-text     │
│       │  │   Pub/Sub)  │  │   search)       │
└───────┘  └─────────────┘  └─────────────────┘
                   │
┌──────────────────▼──────────────────────────────┐
│           Cloud Object Storage                    │
│        (Images, Videos, Documents)                │
└─────────────────────────────────────────────────┘
```

---

## Mobile Architecture (Flutter)

### State Management: BLoC/Cubit

```
┌─────────────────────────────────────────┐
│              Presentation                │
│  Screens → Widgets → BLoC/Cubit         │
├─────────────────────────────────────────┤
│                Domain                    │
│  Entities → Use Cases → Repository IF   │
├─────────────────────────────────────────┤
│                 Data                     │
│  Repository Impl → Data Sources         │
│  (Remote API, Local DB, Cache)          │
└─────────────────────────────────────────┘
```

### Folder Structure
```
lib/
├── app/
│   ├── app.dart              # MaterialApp, theme, routes
│   ├── routes.dart           # Named routes
│   └── theme/
│       ├── app_theme.dart    # ThemeData
│       ├── colors.dart       # Color palette
│       └── typography.dart   # Text styles
├── core/
│   ├── network/
│   │   ├── api_client.dart       # Dio instance
│   │   ├── api_endpoints.dart    # Endpoint constants
│   │   └── api_exceptions.dart   # Error handling
│   ├── storage/
│   │   └── secure_storage.dart   # Token storage
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── date_formatter.dart
│   │   └── debouncer.dart
│   └── widgets/              # Shared widgets
│       ├── glass_card.dart
│       ├── app_button.dart
│       ├── avatar_with_badge.dart
│       └── shimmer_loading.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── repositories/auth_repository_impl.dart
│   │   │   ├── datasources/auth_remote_source.dart
│   │   │   └── models/ (DTOs)
│   │   ├── domain/
│   │   │   ├── entities/user.dart
│   │   │   ├── usecases/login.dart
│   │   │   ├── usecases/signup.dart
│   │   │   └── repositories/auth_repository.dart
│   │   └── presentation/
│   │       ├── screens/login_screen.dart
│   │       ├── screens/signup_screen.dart
│   │       ├── widgets/
│   │       └── cubit/auth_cubit.dart
│   ├── player_profile/
│   ├── club_profile/
│   ├── search/
│   ├── matching/
│   ├── messaging/
│   ├── video/
│   ├── trials/
│   ├── feed/
│   ├── notifications/
│   ├── premium/
│   └── settings/
└── l10n/                     # Localization
    └── app_en.arb
```

---

## Backend Architecture (NestJS)

### Folder Structure
```
src/
├── main.ts
├── app.module.ts
├── config/
│   ├── database.config.ts
│   ├── redis.config.ts
│   ├── elasticsearch.config.ts
│   ├── jwt.config.ts
│   └── storage.config.ts
├── common/
│   ├── guards/
│   │   ├── jwt-auth.guard.ts
│   │   ├── roles.guard.ts
│   │   └── verified.guard.ts
│   ├── decorators/
│   │   ├── current-user.decorator.ts
│   │   └── roles.decorator.ts
│   ├── filters/
│   │   └── http-exception.filter.ts
│   ├── interceptors/
│   │   ├── transform.interceptor.ts
│   │   └── logging.interceptor.ts
│   └── pipes/
│       └── validation.pipe.ts
├── modules/
│   ├── auth/
│   │   ├── auth.module.ts
│   │   ├── auth.controller.ts
│   │   ├── auth.service.ts
│   │   ├── strategies/
│   │   │   ├── jwt.strategy.ts
│   │   │   ├── google.strategy.ts
│   │   │   └── apple.strategy.ts
│   │   └── dto/
│   ├── users/
│   │   ├── users.module.ts
│   │   ├── users.service.ts
│   │   ├── users.controller.ts
│   │   ├── entities/user.entity.ts
│   │   └── dto/
│   ├── players/
│   │   ├── players.module.ts
│   │   ├── players.service.ts
│   │   ├── players.controller.ts
│   │   ├── entities/
│   │   │   ├── player-profile.entity.ts
│   │   │   ├── player-statistics.entity.ts
│   │   │   └── player-video.entity.ts
│   │   └── dto/
│   ├── clubs/
│   ├── search/
│   ├── matching/
│   ├── messaging/
│   ├── video/
│   ├── trials/
│   ├── notifications/
│   ├── feed/
│   ├── premium/
│   └── admin/
└── database/
    ├── migrations/
    └── seeds/
```

---

## Database Schema (Core Entities)

### users
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK |
| email | VARCHAR(255) | UNIQUE |
| password_hash | VARCHAR(255) | nullable (OAuth) |
| user_type | ENUM | 'player', 'club', 'scout', 'agent', 'coach', 'referee' |
| is_verified | BOOLEAN | default false |
| is_premium | BOOLEAN | default false |
| auth_provider | ENUM | 'email', 'google', 'apple' |
| created_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |
| last_login | TIMESTAMP | |

### player_profiles
| Column | Type | Notes |
|--------|------|-------|
| id | UUID | PK, FK → users.id |
| profile_photo_url | TEXT | |
| cover_photo_url | TEXT | |
| full_name | VARCHAR(255) | |
| date_of_birth | DATE | |
| height_cm | INT | |
| weight_kg | DECIMAL | |
| preferred_foot | ENUM | 'left', 'right', 'both' |
| nationality | VARCHAR(100) | |
| bio | TEXT | |
| location_lat | DECIMAL | |
| location_lng | DECIMAL | |
| travel_radius_km | INT | |
| current_step | INT | 1–7, null for county |
| highest_step | INT | |
| county | VARCHAR(100) | |
| availability | ENUM | 'immediate', 'negotiable', 'not_available' |
| contract_status | VARCHAR(100) | |
| work_status | VARCHAR(100) | |
| has_driving_licence | BOOLEAN | |
| has_own_transport | BOOLEAN | |
| open_to_trials | BOOLEAN | |
| open_to_messages | BOOLEAN | |
| open_to_agents | BOOLEAN | |
| created_at | TIMESTAMP | |
| updated_at | TIMESTAMP | |

### player_positions (join table)
| Column | Type |
|--------|------|
| player_id | UUID FK |
| position | ENUM('GK','RB','CB','LB','RWB','LWB','CDM','CM','CAM','RM','LM','RW','LW','ST','CF') |
| is_primary | BOOLEAN |

### player_statistics
| Column | Type |
|--------|------|
| player_id | UUID FK |
| season | VARCHAR(20) |
| appearances | INT |
| goals | INT |
| assists | INT |
| clean_sheets | INT |
| minutes_played | INT |
| yellow_cards | INT |
| red_cards | INT |

### player_club_history
| Column | Type |
|--------|------|
| player_id | UUID FK |
| club_name | VARCHAR(255) |
| years | VARCHAR(50) |
| step | INT |

### player_videos
| Column | Type |
|--------|------|
| id | UUID PK |
| player_id | UUID FK |
| video_url | TEXT |
| thumbnail_url | TEXT |
| category | ENUM('goal','skill','passing','defending','goalkeeping','training','fitness') |
| title | VARCHAR(255) |

### club_profiles
| Column | Type |
|--------|------|
| id | UUID PK, FK → users.id |
| badge_url | TEXT |
| banner_url | TEXT |
| club_name | VARCHAR(255) |
| league | VARCHAR(255) |
| step | INT |
| ground | VARCHAR(255) |
| manager_name | VARCHAR(255) |
| location_lat | DECIMAL |
| location_lng | DECIMAL |
| description | TEXT |
| philosophy | TEXT |
| facilities | TEXT |
| website | VARCHAR(255) |
| training_days | VARCHAR(255) |
| match_days | VARCHAR(255) |
| players_wanted | INT |
| budget | VARCHAR(100) |

### messages
| Column | Type |
|--------|------|
| id | UUID PK |
| conversation_id | UUID FK |
| sender_id | UUID FK |
| content | TEXT |
| type | ENUM('text','image','video','pdf','trial_invite') |
| is_read | BOOLEAN |
| created_at | TIMESTAMP |

### conversations
| Column | Type |
|--------|------|
| id | UUID PK |
| player_id | UUID FK |
| club_id | UUID FK |
| status | ENUM('pending','accepted','rejected','blocked') |
| created_at | TIMESTAMP |

### trial_invitations
| Column | Type |
|--------|------|
| id | UUID PK |
| club_id | UUID FK |
| player_id | UUID FK |
| type | ENUM('training','trial','friendly') |
| proposed_date | DATE |
| status | ENUM('pending','accepted','declined','rescheduled') |
| notes | TEXT |

---

## API Design

See `docs/api.md` for detailed endpoint specifications.

---

## Security Architecture

- **Authentication:** JWT (access + refresh tokens), OAuth 2.0 (Google, Apple)
- **Authorization:** Role-based guards (Player, Club, Admin, etc.)
- **Rate Limiting:** Per-endpoint, per-user throttling
- **Encryption:** TLS in transit, AES-256 at rest for sensitive data
- **GDPR:** Data export, account deletion, consent management
- **Input Validation:** Class-validator DTOs, sanitization

---

## Deployment Architecture

```
┌─────────────────────────────────────────┐
│              GitHub Actions              │
│      CI: Lint → Test → Build → Push     │
└──────────────────┬──────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│           Docker Registry                │
└──────────────────┬──────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│        Kubernetes Cluster                │
│  ┌──────────┐  ┌──────────┐             │
│  │ Backend  │  │ Backend  │  (3 pods)   │
│  │ Pod 1    │  │ Pod 2    │             │
│  └──────────┘  └──────────┘             │
│  ┌──────────────────────────┐           │
│  │    PostgreSQL (RDS)      │           │
│  └──────────────────────────┘           │
│  ┌──────────┐  ┌──────────────────────┐ │
│  │  Redis   │  │ Elasticsearch (ES)   │ │
│  │ Elasti-  │  │ Service              │ │
│  │ Cache    │  │                      │ │
│  └──────────┘  └──────────────────────┘ │
└─────────────────────────────────────────┘
```
