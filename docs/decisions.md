# Design Decisions — PlayerPath

| Date | Decision | Rationale |
|------|----------|-----------|
| 2025-07-16 | Project created as 004 | Next available workspace number |
| 2025-07-16 | Flutter over React Native | Better performance, single-codebase maturity, strong iOS/Android parity, excellent animation support needed for the UI quality target |
| 2025-07-16 | NestJS over Express | Built-in modularity, decorators, DI — cleaner architecture for a large project. TypeScript-first. |
| 2025-07-16 | BLoC over Riverpod/Provider | Predictable state management, strong testing story, scales well with large feature sets, widely adopted in production Flutter apps |
| 2025-07-16 | PostgreSQL over MongoDB | Relational data (profiles, statistics, club history) benefits from relational DB. JSONB available for flexible fields. |
| 2025-07-16 | Elasticsearch for search | Full-text search, geospatial queries, faceted filtering — ideal for player/club discovery with many filter dimensions |
| 2025-07-16 | Redis for caching + pub/sub | Industry standard. Handles session caching, rate limiting, and real-time pub/sub for messaging/notifications |
| 2025-07-16 | Invite-accept messaging model | Prevents spam. Clubs must request connection, players must accept before messaging opens. Protects players. |
| 2025-07-16 | Phased delivery (MVP → Beta → Production) | De-risk delivery. Get core value into testers' hands fast, iterate based on feedback, avoid building unused features |
| 2025-07-16 | Feature-based folder structure | Each feature (auth, profile, search, etc.) is self-contained with its own data/domain/presentation layers. Scales with team size. |
| 2025-07-16 | Clean Architecture (data/domain/presentation) | Separation of concerns, testability, framework independence. Industry standard for production Flutter apps. |
| 2025-07-16 | UUIDs for primary keys | Avoids sequential ID enumeration, better for distributed systems, no collision risk when sharding |
| 2025-07-16 | Docker + Kubernetes from day one | Consistent environments, easy scaling, standard for production deployments. Docker Compose for local dev. |
