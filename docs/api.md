# API Reference — PlayerPath

> Full endpoint specification. Organized by module.

---

## Base URL
```
Development: http://localhost:3000/api/v1
Production:  https://api.playerpath.app/v1
```

## Authentication
All protected endpoints require:
```
Authorization: Bearer <access_token>
```

---

## Auth Module

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/auth/signup` | No | Email + password registration |
| POST | `/auth/login` | No | Email + password login |
| POST | `/auth/google` | No | Google OAuth login |
| POST | `/auth/apple` | No | Apple OAuth login |
| POST | `/auth/verify-email` | No | Verify email with token |
| POST | `/auth/forgot-password` | No | Request password reset |
| POST | `/auth/reset-password` | No | Reset password with token |
| POST | `/auth/refresh` | No | Refresh access token |
| POST | `/auth/logout` | Yes | Invalidate current session |
| POST | `/auth/enable-2fa` | Yes | Enable two-factor auth |
| POST | `/auth/verify-2fa` | Yes | Verify 2FA code |

---

## Users Module

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/users/me` | Yes | Get current user |
| PATCH | `/users/me` | Yes | Update current user |
| DELETE | `/users/me` | Yes | Delete account (GDPR) |
| GET | `/users/me/export` | Yes | Export all data (GDPR) |
| POST | `/users/me/avatar` | Yes | Upload avatar |

---

## Players Module

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/players/profile` | Yes | Create player profile |
| GET | `/players/profile` | Yes | Get own profile |
| PATCH | `/players/profile` | Yes | Update profile |
| GET | `/players/:id` | Yes | Get public player profile |
| POST | `/players/:id/report` | Yes | Report a player |
| POST | `/players/profile/photos` | Yes | Upload profile/cover photos |
| POST | `/players/profile/videos` | Yes | Upload highlight videos |
| DELETE | `/players/profile/videos/:id` | Yes | Remove a video |
| PUT | `/players/profile/statistics` | Yes | Update season statistics |
| POST | `/players/profile/club-history` | Yes | Add club history entry |
| DELETE | `/players/profile/club-history/:id` | Yes | Remove club history entry |
| PUT | `/players/profile/positions` | Yes | Update playing positions |
| PUT | `/players/profile/preferences` | Yes | Update preferences (travel, availability, etc.) |

---

## Clubs Module

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/clubs/profile` | Yes | Create club profile |
| GET | `/clubs/profile` | Yes | Get own club profile |
| PATCH | `/clubs/profile` | Yes | Update club profile |
| GET | `/clubs/:id` | Yes | Get public club profile |
| POST | `/clubs/:id/report` | Yes | Report a club |
| POST | `/clubs/profile/badge` | Yes | Upload club badge |
| POST | `/clubs/profile/banner` | Yes | Upload club banner |

---

## Search Module

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/search/players` | Yes | Search/filter players |
| GET | `/search/clubs` | Yes | Search/filter clubs |
| POST | `/search/saved` | Yes | Save a search |
| GET | `/search/saved` | Yes | Get saved searches |
| DELETE | `/search/saved/:id` | Yes | Delete saved search |

### Player Search Query Parameters
```
?position=ST,CAM          # Comma-separated
&secondaryPosition=LW
&preferredFoot=right
&ageMin=18&ageMax=25
&heightMin=170&heightMax=190
&currentStep=4
&highestStep=3
&county=Greater+Manchester
&radius=50                # km from lat/lng
&lat=53.4808&lng=-2.2426
&availability=immediate
&hasVideo=true
&isVerified=true
&statGoals=5              # Minimum goals
&sort=newest|nearest|rating|experience
&page=1&limit=20
```

### Club Search Query Parameters
```
?league=Northern+Premier
&step=4
&teamType=first|reserve|youth|womens
&radius=50
&lat=53.4808&lng=-2.2426
&hasTrials=true
&trainingDays=monday,wednesday
&sort=newest|nearest
&page=1&limit=20
```

---

## Matching Module

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/matching/players/:clubId` | Yes | Get matched players for a club |
| GET | `/matching/clubs/:playerId` | Yes | Get matched clubs for a player |
| GET | `/matching/score` | Yes | Get compatibility score between player & club |

---

## Messaging Module

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/messaging/invite` | Yes | Club sends connection invite to player |
| POST | `/messaging/invite/:id/accept` | Yes | Player accepts invite |
| POST | `/messaging/invite/:id/reject` | Yes | Player rejects invite |
| GET | `/messaging/conversations` | Yes | List conversations |
| GET | `/messaging/conversations/:id` | Yes | Get conversation with messages |
| POST | `/messaging/conversations/:id/messages` | Yes | Send message (text/image/video/trial) |
| PATCH | `/messaging/conversations/:id/read` | Yes | Mark conversation as read |
| POST | `/messaging/conversations/:id/archive` | Yes | Archive conversation |
| POST | `/messaging/conversations/:id/mute` | Yes | Mute conversation |
| POST | `/messaging/conversations/:id/block` | Yes | Block user |
| POST | `/messaging/conversations/:id/report` | Yes | Report conversation |

### WebSocket Events
```
Client → Server:
  message:send       { conversationId, content, type }
  typing:start       { conversationId }
  typing:stop        { conversationId }

Server → Client:
  message:new         { message }
  typing:update       { conversationId, userId, isTyping }
  invite:received     { invite }
  invite:accepted     { invite }
  invite:rejected     { invite }
```

---

## Trials Module

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/trials/invitations` | Yes | Send trial/training invite |
| GET | `/trials/invitations/received` | Yes | Get received invitations |
| GET | `/trials/invitations/sent` | Yes | Get sent invitations |
| PATCH | `/trials/invitations/:id/accept` | Yes | Accept invitation |
| PATCH | `/trials/invitations/:id/decline` | Yes | Decline invitation |
| PATCH | `/trials/invitations/:id/reschedule` | Yes | Suggest new date |

---

## Notifications Module

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/notifications` | Yes | List notifications |
| PATCH | `/notifications/:id/read` | Yes | Mark as read |
| PATCH | `/notifications/read-all` | Yes | Mark all as read |
| PUT | `/notifications/preferences` | Yes | Update notification preferences |

---

## Feed Module

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/feed` | Yes | Get personalized home feed |

---

## Saved Lists Module

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/saved/players` | Yes | Save/favourite a player |
| DELETE | `/saved/players/:playerId` | Yes | Remove saved player |
| GET | `/saved/players` | Yes | List saved players |
| POST | `/saved/shortlists` | Yes | Create shortlist |
| GET | `/saved/shortlists` | Yes | List shortlists |
| PATCH | `/saved/shortlists/:id` | Yes | Update shortlist |
| DELETE | `/saved/shortlists/:id` | Yes | Delete shortlist |
| POST | `/saved/shortlists/:id/players` | Yes | Add player to shortlist |
| DELETE | `/saved/shortlists/:id/players/:playerId` | Yes | Remove from shortlist |
| PATCH | `/saved/players/:playerId/notes` | Yes | Update notes on saved player |

---

## Admin Module (Phase 3)

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/admin/dashboard` | Admin | Dashboard stats |
| GET | `/admin/users` | Admin | List/manage users |
| PATCH | `/admin/users/:id/verify` | Admin | Verify a user |
| PATCH | `/admin/users/:id/suspend` | Admin | Suspend a user |
| DELETE | `/admin/users/:id` | Admin | Delete a user |
| GET | `/admin/reports` | Admin | View reports |
| PATCH | `/admin/reports/:id/resolve` | Admin | Resolve a report |
| GET | `/admin/analytics` | Admin | Analytics data |
| GET | `/admin/health` | Admin | System health |

---

## Response Format

### Success
```json
{
  "success": true,
  "data": { ... },
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 142
  }
}
```

### Error
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email is already registered",
    "details": [...]
  }
}
```

---

## Rate Limits

| Tier | Limit |
|------|-------|
| Auth endpoints | 10 req/min |
| Standard API | 60 req/min |
| Premium API | 300 req/min |
| Search | 30 req/min |
| Video upload | 5 req/min |
