# Requirements — PlayerPath

## Overview

A cross-platform mobile application (iOS & Android) connecting grassroots, semi-professional, and non-league football players with clubs, scouts, and managers across the UK.

---

## User Types

### Current (Phase 1)
1. **Player** — Grassroots/semi-pro footballer creating a CV and being discovered
2. **Club** — Manager/club official searching for players

### Future
- Scouts
- Agents
- Coaches
- Referees

---

## Functional Requirements

### FR-AUTH — Authentication
| ID | Requirement | Phase |
|----|-------------|-------|
| A1 | Email + password sign up with verification | 1 |
| A2 | Email + password login | 1 |
| A3 | Google OAuth login | 1 |
| A4 | Apple OAuth login | 1 |
| A5 | Password reset via email | 1 |
| A6 | Optional 2FA | 3 |

### FR-PLAYER — Player Profile
| ID | Requirement | Phase |
|----|-------------|-------|
| P1 | Profile photo upload | 1 |
| P2 | Cover photo upload | 1 |
| P3 | Personal details (name, age, DOB, height, weight, nationality, preferred foot) | 1 |
| P4 | Club history (current & previous clubs, years, steps played) | 1 |
| P5 | Playing positions (primary, secondary) and roles | 1 |
| P6 | Bio and playing style description | 1 |
| P7 | Availability & contract status | 1 |
| P8 | Looking for (Step 1–7, County League) | 1 |
| P9 | Location with radius willing to travel | 1 |
| P10 | Training & match day preferences | 1 |
| P11 | Work status, driving licence, own transport | 1 |
| P12 | Video highlights (upload multiple clips, highlight reels) | 2 |
| P13 | Photo gallery | 1 |
| P14 | Statistics (goals, assists, apps, clean sheets, mins, cards) | 1 |
| P15 | Awards & achievements | 1 |
| P16 | Coach & manager references | 2 |
| P17 | Languages spoken | 1 |
| P18 | Medical notes (optional) | 1 |
| P19 | Open to trials / messages / agents | 1 |

### FR-CLUB — Club Profile
| ID | Requirement | Phase |
|----|-------------|-------|
| C1 | Club badge & banner upload | 1 |
| C2 | Club details (name, league, step, location, ground) | 1 |
| C3 | Manager & assistant manager info | 1 |
| C4 | Club description & philosophy | 1 |
| C5 | Training & match days | 1 |
| C6 | Facilities description | 1 |
| C7 | Website & social media links | 1 |
| C8 | Contact information | 1 |
| C9 | Number of players wanted & budget | 1 |
| C10 | Open trials & upcoming fixtures | 2 |

### FR-SEARCH — Player Discovery (Club side)
| ID | Requirement | Phase |
|----|-------------|-------|
| S1 | Filter by age | 1 |
| S2 | Filter by position & secondary position | 1 |
| S3 | Filter by preferred foot | 1 |
| S4 | Filter by height | 1 |
| S5 | Filter by highest/current step played | 1 |
| S6 | Filter by county & distance/radius | 1 |
| S7 | Filter by availability | 1 |
| S8 | Filter by club history | 1 |
| S9 | Filter by statistics (goals, assists, apps) | 1 |
| S10 | Filter by video available | 2 |
| S11 | Filter by verified player | 2 |
| S12 | Sort options (newest, nearest, highest rated, most experienced) | 1 |
| S13 | AI-recommended sorting | 3 |

### FR-CLUB-SEARCH — Club Discovery (Player side)
| ID | Requirement | Phase |
|----|-------------|-------|
| CS1 | Filter by location & distance | 1 |
| CS2 | Filter by league & step | 1 |
| CS3 | Filter by facilities | 1 |
| CS4 | Filter by training days & trial dates | 2 |
| CS5 | Filter by team type (youth, reserve, first, women's) | 1 |

### FR-MATCHING — AI Matching Engine
| ID | Requirement | Phase |
|----|-------------|-------|
| M1 | Match on location, position, experience, step | 1 (basic) |
| M2 | Match on age, travel distance, availability, stats | 2 |
| M3 | Match on formation & manager preferences | 3 |
| M4 | Compatibility percentage display | 1 (basic) |
| M5 | Match tiers: Excellent (90%+), Good (75%+), Potential (60%+) | 1 (basic) |

### FR-MESSAGING — Messaging Platform
| ID | Requirement | Phase |
|----|-------------|-------|
| MSG1 | Club sends connection invite | 2 |
| MSG2 | Player accepts/rejects invite | 2 |
| MSG3 | Messaging enabled only after mutual acceptance | 2 |
| MSG4 | Read receipts | 2 |
| MSG5 | Typing indicator | 2 |
| MSG6 | Image sharing | 2 |
| MSG7 | Video & PDF sharing | 2 |
| MSG8 | Trial match invitations via chat | 2 |
| MSG9 | Push notifications for new messages | 2 |
| MSG10 | Online status | 2 |
| MSG11 | Archive, mute, block, report | 2 |

### FR-TRIALS — Trial System
| ID | Requirement | Phase |
|----|-------------|-------|
| T1 | Manager sends training/trial/friendly invitation | 2 |
| T2 | Medical or document request | 2 |
| T3 | Player accept/decline/suggest alternative date | 2 |
| T4 | Calendar integration | 3 |
| T5 | Reminder notifications | 2 |

### FR-VIDEO — Video Platform
| ID | Requirement | Phase |
|----|-------------|-------|
| V1 | Upload clips (goals, skills, passing, defending, GK, training, fitness) | 2 |
| V2 | Auto-generate thumbnails | 2 |
| V3 | HD streaming | 2 |
| V4 | Bookmark/save videos | 2 |

### FR-SAVED — Saved Lists
| ID | Requirement | Phase |
|----|-------------|-------|
| SL1 | Favourite/bookmark players | 2 |
| SL2 | Create named shortlists | 2 |
| SL3 | Private notes & ratings on saved players | 2 |
| SL4 | Export shortlists | 3 |

### FR-NOTIFICATIONS
| ID | Requirement | Phase |
|----|-------------|-------|
| N1 | Push notifications for new messages | 2 |
| N2 | Profile view notifications | 2 |
| N3 | Trial invite notifications | 2 |
| N4 | New clubs/players matching saved searches | 2 |
| N5 | Application accepted/rejected | 2 |

### FR-FEED — Home Feed
| ID | Requirement | Phase |
|----|-------------|-------|
| F1 | Player view: nearby clubs, open trials, suggested clubs, recent signings | 2 |
| F2 | Club view: recommended players, nearby players, recent highlights, trending | 2 |

### FR-ADMIN — Admin Panel
| ID | Requirement | Phase |
|----|-------------|-------|
| AD1 | User & club management dashboard | 3 |
| AD2 | Content moderation tools | 3 |
| AD3 | Analytics dashboard | 3 |
| AD4 | User verification system | 3 |
| AD5 | System health monitoring | 3 |

### FR-PREMIUM — Premium Features
| ID | Requirement | Phase |
|----|-------------|-------|
| PR1 | Player Pro: unlimited video, profile boost, advanced analytics | 3 |
| PR2 | AI CV review | 3 |
| PR3 | Priority search ranking | 3 |
| PR4 | Who viewed my profile | 3 |
| PR5 | Club Pro: unlimited searches/messages, advanced filters | 3 |
| PR6 | AI recruitment suggestions | 3 |
| PR7 | Scout dashboard & recruitment analytics | 3 |

---

## Non-Functional Requirements

| ID | Requirement |
|----|-------------|
| NF1 | Dark mode & light mode support |
| NF2 | Responsive on all screen sizes |
| NF3 | Glassmorphism UI elements where appropriate |
| NF4 | Smooth animations (page transitions, micro-interactions) |
| NF5 | Apple-quality UI polish |
| NF6 | GDPR compliant |
| NF7 | Encrypted messaging (E2E where possible) |
| NF8 | Rate limiting on all endpoints |
| NF9 | Content moderation & abuse reporting |
| NF10 | Verification badges for trusted users |
| NF11 | Scalable to 100K+ users |
| NF12 | 99.9% uptime target |
| NF13 | Accessibility (WCAG 2.1 AA) |
| NF14 | Offline support for core features |
