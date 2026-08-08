"""
Club Scout — English Non-League Football Club Contact Database
Configuration: league definitions, file paths, search rules
"""

import os
from pathlib import Path

# ── Paths ──
BASE_DIR = Path(__file__).parent
DATA_DIR = BASE_DIR / "data"
DATA_DIR.mkdir(exist_ok=True)

DB_PATH = DATA_DIR / "clubs_database.csv"
AUDIT_PATH = DATA_DIR / "audit_report.json"
LOG_PATH = DATA_DIR / "scout.log"

# ── Request settings ──
REQUEST_DELAY = 1.5          # seconds between requests to same domain
REQUEST_TIMEOUT = 15         # seconds
MAX_RETRIES = 3
RETRY_BACKOFF = 5            # seconds base for exponential backoff
CACHE_ENABLED = True

# ── Headers ──
HEADERS = {
    'User-Agent': 'PlayerPath/1.0 Club Discovery Bot (+https://playerpath.app; compliance@playerpath.app)',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language': 'en-GB,en;q=0.9',
}

# ═══════════════════════════════════════════
# ENGLISH FOOTBALL PYRAMID — STEPS 1-7
# Structure from The FA National League System 2024/25
# Updated for 2026/27 projections
# ═══════════════════════════════════════════

STEPS = {
    1: {
        "name": "Step 1",
        "level": "National League",
        "leagues": [
            {"name": "National League", "teams": 24, "region": "National"},
        ]
    },
    2: {
        "name": "Step 2",
        "level": "National League North & South",
        "leagues": [
            {"name": "National League North", "teams": 24, "region": "North"},
            {"name": "National League South", "teams": 24, "region": "South"},
        ]
    },
    3: {
        "name": "Step 3",
        "level": "Premier Divisions",
        "leagues": [
            {"name": "Northern Premier League", "teams": 22, "region": "North", "abbr": "NPL"},
            {"name": "Southern League Premier Central", "teams": 22, "region": "Midlands", "abbr": "SLPC"},
            {"name": "Southern League Premier South", "teams": 22, "region": "South", "abbr": "SLPS"},
            {"name": "Isthmian League Premier", "teams": 22, "region": "South East", "abbr": "ILP"},
        ]
    },
    4: {
        "name": "Step 4",
        "level": "Division 1",
        "leagues": [
            {"name": "NPL Division 1 West", "teams": 22, "region": "North West", "abbr": "NPL1W"},
            {"name": "NPL Division 1 East", "teams": 22, "region": "North East", "abbr": "NPL1E"},
            {"name": "NPL Division 1 Midlands", "teams": 22, "region": "Midlands", "abbr": "NPL1M"},
            {"name": "Southern League Division 1 Central", "teams": 22, "region": "Central", "abbr": "SL1C"},
            {"name": "Southern League Division 1 South", "teams": 22, "region": "South", "abbr": "SL1S"},
            {"name": "Isthmian League Division 1 North", "teams": 22, "region": "East", "abbr": "IL1N"},
            {"name": "Isthmian League Division 1 South Central", "teams": 22, "region": "South East", "abbr": "IL1SC"},
            {"name": "Isthmian League Division 1 South East", "teams": 22, "region": "South East", "abbr": "IL1SE"},
        ]
    },
    5: {
        "name": "Step 5",
        "level": "Regional Premier",
        "leagues": [
            {"name": "Northern League Division 1", "teams": 22, "region": "North East"},
            {"name": "Northern Counties East League Premier", "teams": 22, "region": "Yorkshire"},
            {"name": "North West Counties League Premier", "teams": 24, "region": "North West"},
            {"name": "Midland League Premier", "teams": 18, "region": "Midlands"},
            {"name": "United Counties League Premier North", "teams": 20, "region": "East Midlands"},
            {"name": "United Counties League Premier South", "teams": 20, "region": "East"},
            {"name": "Hellenic League Premier", "teams": 20, "region": "South Central"},
            {"name": "Spartan South Midlands League Premier", "teams": 18, "region": "East"},
            {"name": "Eastern Counties League Premier", "teams": 20, "region": "East"},
            {"name": "Essex Senior League", "teams": 20, "region": "East"},
            {"name": "Southern Counties East League Premier", "teams": 20, "region": "South East"},
            {"name": "Combined Counties League Premier North", "teams": 20, "region": "South East"},
            {"name": "Combined Counties League Premier South", "teams": 20, "region": "South East"},
            {"name": "Western League Premier", "teams": 18, "region": "South West"},
            {"name": "Wessex League Premier", "teams": 20, "region": "South"},
            {"name": "Southern Combination League Premier", "teams": 20, "region": "South East"},
        ]
    },
    6: {
        "name": "Step 6",
        "level": "Regional Division 1",
        "leagues": [
            {"name": "Northern League Division 2", "teams": 22, "region": "North East"},
            {"name": "Northern Counties East League Division 1", "teams": 22, "region": "Yorkshire"},
            {"name": "North West Counties League Division 1 North", "teams": 18, "region": "North West"},
            {"name": "North West Counties League Division 1 South", "teams": 18, "region": "North West"},
            {"name": "Midland League Division 1", "teams": 20, "region": "Midlands"},
            {"name": "United Counties League Division 1", "teams": 20, "region": "East"},
            {"name": "Hellenic League Division 1", "teams": 20, "region": "South"},
            {"name": "Spartan South Midlands League Division 1", "teams": 20, "region": "East"},
            {"name": "Eastern Counties League Division 1 North", "teams": 20, "region": "East"},
            {"name": "Eastern Counties League Division 1 South", "teams": 20, "region": "East"},
            {"name": "Southern Counties East League Division 1", "teams": 18, "region": "South East"},
            {"name": "Combined Counties League Division 1", "teams": 22, "region": "South East"},
            {"name": "Western League Division 1", "teams": 22, "region": "South West"},
            {"name": "Wessex League Division 1", "teams": 20, "region": "South"},
            {"name": "Southern Combination League Division 1", "teams": 20, "region": "South East"},
            {"name": "South West Peninsula League Premier East", "teams": 18, "region": "South West"},
            {"name": "South West Peninsula League Premier West", "teams": 18, "region": "South West"},
        ]
    },
    7: {
        "name": "Step 7",
        "level": "Feeder Leagues",
        "leagues": [
            {"name": "Anglian Combination Premier", "teams": 16, "region": "East"},
            {"name": "Bedfordshire County League Premier", "teams": 16, "region": "East"},
            {"name": "Cambridgeshire County League Premier", "teams": 16, "region": "East"},
            {"name": "Central Midlands League North", "teams": 18, "region": "Midlands"},
            {"name": "Central Midlands League South", "teams": 18, "region": "Midlands"},
            {"name": "Cheshire League Premier", "teams": 16, "region": "North West"},
            {"name": "Dorset Premier League", "teams": 16, "region": "South"},
            {"name": "Essex & Suffolk Border League Premier", "teams": 16, "region": "East"},
            {"name": "Essex Olympian League Premier", "teams": 16, "region": "East"},
            {"name": "Gloucestershire County League", "teams": 16, "region": "South West"},
            {"name": "Hampshire Premier League Senior", "teams": 16, "region": "South"},
            {"name": "Herefordshire League Premier", "teams": 16, "region": "Midlands"},
            {"name": "Hertfordshire Senior County League Premier", "teams": 16, "region": "East"},
            {"name": "Kent County League Premier", "teams": 16, "region": "South East"},
            {"name": "Leicestershire Senior League Premier", "teams": 16, "region": "Midlands"},
            {"name": "Lincolnshire League", "teams": 16, "region": "East Midlands"},
            {"name": "Liverpool County Premier League", "teams": 16, "region": "North West"},
            {"name": "Manchester League Premier", "teams": 16, "region": "North West"},
            {"name": "Mid-Sussex League Premier", "teams": 16, "region": "South East"},
            {"name": "Middlesex County League Premier", "teams": 16, "region": "South East"},
            {"name": "North Riding League Premier", "teams": 16, "region": "Yorkshire"},
            {"name": "Northamptonshire Combination Premier", "teams": 16, "region": "Midlands"},
            {"name": "Nottinghamshire Senior League Premier", "teams": 16, "region": "Midlands"},
            {"name": "Oxfordshire Senior League Premier", "teams": 16, "region": "South Central"},
            {"name": "Peterborough & District League Premier", "teams": 16, "region": "East"},
            {"name": "Sheffield & Hallamshire County Senior Premier", "teams": 16, "region": "Yorkshire"},
            {"name": "Shropshire County League Premier", "teams": 16, "region": "Midlands"},
            {"name": "Somerset County League Premier", "teams": 16, "region": "South West"},
            {"name": "Staffordshire County Senior League Premier", "teams": 16, "region": "Midlands"},
            {"name": "Suffolk & Ipswich League Senior", "teams": 16, "region": "East"},
            {"name": "Surrey County Intermediate League Western Premier", "teams": 16, "region": "South East"},
            {"name": "Thames Valley Premier League", "teams": 16, "region": "South East"},
            {"name": "Wearside League Premier", "teams": 16, "region": "North East"},
            {"name": "West Cheshire League Division 1", "teams": 16, "region": "North West"},
            {"name": "West Lancashire League Premier", "teams": 16, "region": "North West"},
            {"name": "West Midlands Regional League Premier", "teams": 16, "region": "Midlands"},
            {"name": "West Riding County Amateur League Premier", "teams": 16, "region": "Yorkshire"},
            {"name": "West Sussex League Premier", "teams": 16, "region": "South East"},
            {"name": "West Yorkshire League Premier", "teams": 16, "region": "Yorkshire"},
            {"name": "Wiltshire Senior League Premier", "teams": 16, "region": "South West"},
            {"name": "York League Premier", "teams": 16, "region": "Yorkshire"},
            {"name": "Yorkshire Amateur League Supreme", "teams": 16, "region": "Yorkshire"},
            {"name": "Aldershot & District League Premier", "teams": 16, "region": "South East"},
        ]
    }
}

# Computed totals
EXPECTED_CLUBS = {}
for step, data in STEPS.items():
    total = sum(l["teams"] for l in data["leagues"])
    EXPECTED_CLUBS[step] = total

EXPECTED_TOTAL = sum(EXPECTED_CLUBS.values())

# ── League website patterns (for email discovery) ──
LEAGUE_WEBSITES = {
    3: {
        "Northern Premier League": "https://www.thenpl.co.uk",
        "Southern League": "https://southern-football-league.co.uk",
        "Isthmian League": "https://www.isthmian.co.uk",
    },
    5: {
        "Northern League": "https://www.northernfootballleague.org",
        "Northern Counties East": "https://www.ncefl.org.uk",
        "North West Counties": "https://www.nwcfl.com",
        "Midland League": "https://www.midlandfootballleague.co.uk",
        "United Counties": "https://www.uhlsportunitedcountiesleague.co.uk",
        "Hellenic League": "https://www.hellenicleague.co.uk",
        "Western League": "https://www.westernleague.co.uk",
        "Wessex League": "https://www.wessexleague.co.uk",
        "Eastern Counties": "https://ecl.leaguerepublic.com",
        "Essex Senior": "https://essexseniorleague.co.uk",
        "Southern Counties East": "https://scefl.com",
        "Combined Counties": "https://combinedcounties.com",
        "Spartan South Midlands": "https://www.spartansouthmidlandsleague.co.uk",
        "Southern Combination": "https://www.southerncombinationleague.co.uk",
    }
}

# ── Contact page paths to search on club websites ──
CONTACT_PATHS = [
    "/contact",
    "/contact-us",
    "/contacts",
    "/club-contacts",
    "/club-officials",
    "/committee",
    "/officials",
    "/staff",
    "/management",
    "/about",
    "/about-us",
    "/the-club",
    "/club-info",
    "/club-information",
    "/first-team",
    "/teams/first-team",
    "/football",
    "/football-department",
    "/secretary",
    "/info",
    "/general-enquiries",
    "/commercial",
    "/recruitment",
    "/academy",
    "/player-recruitment",
    "/club/contact",
]

# ── Email classification keywords ──
EMAIL_CLASSIFICATIONS = {
    "Club Secretary": ["secretary", "sec@", "secretary@", "clubsec"],
    "First Team": ["firstteam", "first-team", "1stteam", "first@", "team@", "manager@"],
    "Manager/Head Coach": ["manager", "headcoach", "head-coach", "coach@"],
    "Recruitment": ["recruitment", "recruit", "trial", "player-recruitment", "scout"],
    "Football Department": ["football@", "footballdept", "director-of-football", "dof@"],
    "General Club": ["info@", "admin@", "office@", "contact@", "enquiries@", "enquiries@", "club@"],
    "Commercial": ["commercial", "sponsor", "marketing"],
    "Academy": ["academy", "youth", "development"],
}

# ── Wikipedia league pages for club extraction ──
WIKI_URLS = [
    ("https://en.wikipedia.org/wiki/National_League_(division)", 1, "National League"),
    ("https://en.wikipedia.org/wiki/National_League_North", 2, "National League North"),
    ("https://en.wikipedia.org/wiki/National_League_South", 2, "National League South"),
    ("https://en.wikipedia.org/wiki/Northern_Premier_League", 3, "Northern Premier League"),
    ("https://en.wikipedia.org/wiki/Southern_Football_League", 3, "Southern League"),
    ("https://en.wikipedia.org/wiki/Isthmian_League", 3, "Isthmian League"),
    ("https://en.wikipedia.org/wiki/Northern_Counties_East_Football_League", 5, "NC East"),
    ("https://en.wikipedia.org/wiki/North_West_Counties_Football_League", 5, "NW Counties"),
    ("https://en.wikipedia.org/wiki/Midland_Football_League", 5, "Midland"),
    ("https://en.wikipedia.org/wiki/Hellenic_Football_League", 5, "Hellenic"),
    ("https://en.wikipedia.org/wiki/Western_Football_League", 5, "Western"),
    ("https://en.wikipedia.org/wiki/Wessex_Football_League", 5, "Wessex"),
    ("https://en.wikipedia.org/wiki/Essex_Senior_Football_League", 5, "Essex Senior"),
    ("https://en.wikipedia.org/wiki/Combined_Counties_Football_League", 5, "Combined Counties"),
    ("https://en.wikipedia.org/wiki/English_football_league_system", None, "All"),
]
