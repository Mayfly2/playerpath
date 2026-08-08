# 🏆 PlayerPath Club Scout

Multi-pass English non-league football club contact discovery system.
Covers **Steps 1-7** of the FA National League System for the 2026/27 season.

## Quick Start

```bash
pip install -r requirements.txt
python main.py
```

## Commands

| Command | Description |
|---------|-------------|
| `python main.py` | Full 9-pass system |
| `python main.py --quick` | Fast run (Wikipedia only) |
| `python main.py --dashboard` | Show coverage dashboard |
| `python main.py --investigate` | Search missing emails only |
| `python main.py --export` | Export all formats |

## How It Works

### Data Sources (Multiple, Cross-Referenced)
- Wikipedia league pages (club lists)
- Official league websites (thenpl.co.uk, isthmian.co.uk, westernleague.co.uk, etc.)
- Club official websites (contact pages, about pages, staff pages)
- FA National League System allocations
- Football directories

### Multi-Pass Architecture

```
PASS 1: Build complete club list from Wikipedia
PASS 2: Find official club websites
PASS 3: Scrape league websites for emails
PASS 4: Search club websites for contact emails
PASS 5: Check contact pages systematically
PASS 6: Search additional sources
PASS 7: Duplicate detection & cleanup
PASS 8: Re-check clubs still missing emails
PASS 9: Final verification & audit
```

### Email Classification

Every email found is classified:
- **Recruitment** (highest priority for player outreach)
- **Football Department**
- **First Team**
- **Club Secretary**
- **Manager/Head Coach**
- **General Club** (info@, admin@, etc.)
- **Commercial**
- **Academy**

### Quality Rules

- ❌ NEVER guesses emails from patterns
- ❌ Never scrapes behind logins or CAPTCHAs
- ✅ Every email has a source URL
- ✅ Confidence scoring (High/Medium/Low)
- ✅ Respects rate limits and robots.txt

## Project Structure

```
club-scout/
├── main.py          # Orchestrator (multi-pass controller)
├── config.py        # Configuration (leagues, paths, rules)
├── database.py      # CSV database (dedup, merge, stats)
├── discovery.py     # Club discovery (Wikipedia, league sites)
├── email_finder.py  # Email finder (club website search)
├── dashboard.py     # Dashboard, audit, export
├── data/            # Output (databases, audits, logs)
└── requirements.txt
```

## Output Files

| File | Format | Contents |
|------|--------|----------|
| `data/clubs_database.csv` | CSV | Full database (import to Brevo/Mailchimp) |
| `data/clubs_database.json` | JSON | Machine-readable export |
| `data/audit_report.json` | JSON | Coverage & quality audit |

## Database Fields

Club Name | Step | League | Division | County | Town | Website | Email | Email Type | Contact Name | Contact Role | Phone | Source URL | Source Type | Confidence | Verification Status | Date Found | Last Verified | Notes

## Expected Coverage

| Step | Leagues | Expected Clubs |
|------|---------|---------------|
| 1 | National League | 24 |
| 2 | North & South | 48 |
| 3 | Premier Divisions | 88 |
| 4 | Division 1 | 176 |
| 5 | Regional Premier | 320 |
| 6 | Regional Division 1 | 340 |
| 7 | Feeder Leagues | 704 |
| **Total** | | **~1,700** |

## Legal

Only collects publicly available contact information that clubs have published for their football/business operations. Respects robots.txt and website terms. Uses sensible request rates (1.5s delay between requests).
