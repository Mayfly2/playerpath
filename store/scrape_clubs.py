#!/usr/bin/env python3
"""
Scrape non-league club names from FA Full-Time league pages.

Outputs clubs.csv with club names. Then use Hunter.io to find emails.

Usage:
  pip install requests beautifulsoup4
  python scrape_clubs.py

Requires: Python 3.8+, requests, beautifulsoup4
"""

import csv
import re
import time
import sys

try:
    import requests
    from bs4 import BeautifulSoup
except ImportError:
    print("Missing dependencies. Run: pip install requests beautifulsoup4")
    sys.exit(1)

# ── FA Full-Time league URLs (Steps 1-7) ──
# League IDs may change — update from https://fulltime.thefa.com
LEAGUES = [
    # ═══ STEP 1 — National League ═══
    ("https://fulltime.thefa.com/league.html?league=1621353", "Vanarama National League"),

    # ═══ STEP 2 — National League North & South ═══
    ("https://fulltime.thefa.com/league.html?league=1687544", "National League North"),
    ("https://fulltime.thefa.com/league.html?league=1998475", "National League South"),

    # ═══ STEP 3 — Premier Divisions ═══
    ("https://fulltime.thefa.com/league.html?league=8704859", "Northern Premier League"),
    ("https://fulltime.thefa.com/league.html?league=9128498", "Southern League Central"),
    ("https://fulltime.thefa.com/league.html?league=1408626", "Southern League South"),
    ("https://fulltime.thefa.com/league.html?league=4831636", "Isthmian League"),

    # ═══ STEP 4 — Division 1 ═══
    ("https://fulltime.thefa.com/league.html?league=2618593", "NPL Division 1 West"),
    ("https://fulltime.thefa.com/league.html?league=5007160", "NPL Division 1 East"),
    ("https://fulltime.thefa.com/league.html?league=4251625", "NPL Division 1 Midlands"),
    ("https://fulltime.thefa.com/league.html?league=7883260", "Southern Div 1 Central"),
    ("https://fulltime.thefa.com/league.html?league=7419214", "Southern Div 1 South"),
    ("https://fulltime.thefa.com/league.html?league=3455392", "Isthmian Div 1 North"),
    ("https://fulltime.thefa.com/league.html?league=8300427", "Isthmian Div 1 South Central"),
    ("https://fulltime.thefa.com/league.html?league=6578459", "Isthmian Div 1 South East"),

    # ═══ STEP 5 — Regional Premier ═══
    ("https://fulltime.thefa.com/league.html?league=6060059", "North West Counties Premier"),
    ("https://fulltime.thefa.com/league.html?league=4310821", "Northern Counties East Premier"),
    ("https://fulltime.thefa.com/league.html?league=9913209", "Midland League Premier"),
    ("https://fulltime.thefa.com/league.html?league=7244229", "United Counties Premier North"),
    ("https://fulltime.thefa.com/league.html?league=6946576", "Hellenic League Premier"),
    ("https://fulltime.thefa.com/league.html?league=2143372", "Western League Premier"),
    ("https://fulltime.thefa.com/league.html?league=9560199", "Wessex League Premier"),
    ("https://fulltime.thefa.com/league.html?league=4705734", "Eastern Counties Premier"),
    ("https://fulltime.thefa.com/league.html?league=9708130", "Essex Senior League"),
    ("https://fulltime.thefa.com/league.html?league=4806134", "Southern Counties East Premier"),
    ("https://fulltime.thefa.com/league.html?league=3801074", "Combined Counties Premier North"),
    ("https://fulltime.thefa.com/league.html?league=6098435", "Spartan South Midlands Premier"),
    ("https://fulltime.thefa.com/league.html?league=4935177", "United Counties Premier South"),
    ("https://fulltime.thefa.com/league.html?league=5010473", "Combined Counties Premier South"),

    # ═══ STEP 6 — Division 1 (20 leagues) ═══
    ("https://fulltime.thefa.com/league.html?league=2351883", "Northern League Div 1"),
    ("https://fulltime.thefa.com/league.html?league=8502307", "NW Counties Div 1 North"),
    ("https://fulltime.thefa.com/league.html?league=9679587", "NW Counties Div 1 South"),
    ("https://fulltime.thefa.com/league.html?league=1556269", "NC East Div 1"),
    ("https://fulltime.thefa.com/league.html?league=7715944", "Midland League Div 1"),
    ("https://fulltime.thefa.com/league.html?league=3762178", "United Counties Div 1"),
    ("https://fulltime.thefa.com/league.html?league=8702558", "Hellenic League Div 1"),
    ("https://fulltime.thefa.com/league.html?league=3825083", "Western League Div 1"),
    ("https://fulltime.thefa.com/league.html?league=6343217", "Wessex League Div 1"),
    ("https://fulltime.thefa.com/league.html?league=1111856", "Eastern Counties Div 1 North"),
    ("https://fulltime.thefa.com/league.html?league=5331473", "Eastern Counties Div 1 South"),
    ("https://fulltime.thefa.com/league.html?league=6845077", "SC East Div 1"),
    ("https://fulltime.thefa.com/league.html?league=9645840", "Combined Counties Div 1"),
    ("https://fulltime.thefa.com/league.html?league=8269493", "Spartan SM Div 1"),
    ("https://fulltime.thefa.com/league.html?league=1705599", "Southern Combination Div 1"),

    # ═══ STEP 7 — Feeder Leagues ═══
    ("https://fulltime.thefa.com/league.html?league=4730998", "Anglian Combination Premier"),
    ("https://fulltime.thefa.com/league.html?league=2447206", "Central Midlands North"),
    ("https://fulltime.thefa.com/league.html?league=4984902", "Central Midlands South"),
    ("https://fulltime.thefa.com/league.html?league=4507140", "Cheshire League Premier"),
    ("https://fulltime.thefa.com/league.html?league=6615808", "Dorset Premier League"),
    ("https://fulltime.thefa.com/league.html?league=2661351", "Essex & Suffolk Border Premier"),
    ("https://fulltime.thefa.com/league.html?league=6832870", "Essex Olympian Premier"),
    ("https://fulltime.thefa.com/league.html?league=6056386", "Gloucestershire County"),
    ("https://fulltime.thefa.com/league.html?league=2934679", "Hampshire Premier Senior"),
    ("https://fulltime.thefa.com/league.html?league=7532681", "Herefordshire League Premier"),
    ("https://fulltime.thefa.com/league.html?league=1250026", "Herts Senior County Premier"),
    ("https://fulltime.thefa.com/league.html?league=5059500", "Kent County League Premier"),
    ("https://fulltime.thefa.com/league.html?league=8625682", "Leicestershire Senior Premier"),
    ("https://fulltime.thefa.com/league.html?league=3155348", "Lincolnshire League"),
    ("https://fulltime.thefa.com/league.html?league=6463352", "Liverpool County Premier"),
    ("https://fulltime.thefa.com/league.html?league=1864570", "Manchester League Premier"),
    ("https://fulltime.thefa.com/league.html?league=6694871", "Mid-Sussex League Premier"),
    ("https://fulltime.thefa.com/league.html?league=5927543", "Middlesex County Premier"),
    ("https://fulltime.thefa.com/league.html?league=4721988", "North Riding League Premier"),
    ("https://fulltime.thefa.com/league.html?league=6456013", "Nottinghamshire Senior Premier"),
    ("https://fulltime.thefa.com/league.html?league=2348141", "Oxfordshire Senior Premier"),
    ("https://fulltime.thefa.com/league.html?league=9141612", "Peterborough & District Premier"),
    ("https://fulltime.thefa.com/league.html?league=7009630", "Sheffield & Hallamshire Premier"),
    ("https://fulltime.thefa.com/league.html?league=8371993", "Shropshire County Premier"),
    ("https://fulltime.thefa.com/league.html?league=1538521", "Somerset County Premier"),
    ("https://fulltime.thefa.com/league.html?league=9505916", "Staffordshire County Senior"),
    ("https://fulltime.thefa.com/league.html?league=4920630", "Suffolk & Ipswich Senior"),
    ("https://fulltime.thefa.com/league.html?league=1032807", "Surrey County Intermediate Western"),
    ("https://fulltime.thefa.com/league.html?league=8009781", "Thames Valley Premier"),
    ("https://fulltime.thefa.com/league.html?league=4550838", "Wearside League Premier"),
    ("https://fulltime.thefa.com/league.html?league=5731084", "West Cheshire League Div 1"),
    ("https://fulltime.thefa.com/league.html?league=8021294", "West Lancashire Premier"),
    ("https://fulltime.thefa.com/league.html?league=2810664", "West Midlands Regional Premier"),
    ("https://fulltime.thefa.com/league.html?league=4531653", "West Riding County Premier"),
    ("https://fulltime.thefa.com/league.html?league=5618611", "West Yorkshire League Premier"),
    ("https://fulltime.thefa.com/league.html?league=6170143", "Wiltshire Senior Premier"),
    ("https://fulltime.thefa.com/league.html?league=7712227", "York League Premier"),
    ("https://fulltime.thefa.com/league.html?league=6854632", "Yorkshire Amateur Supreme"),
    ("https://fulltime.thefa.com/league.html?league=1069947", "Bedfordshire County Premier"),
    ("https://fulltime.thefa.com/league.html?league=9560976", "Cambridgeshire County Premier"),
    ("https://fulltime.thefa.com/league.html?league=3436985", "Devon League North East"),
    ("https://fulltime.thefa.com/league.html?league=5215564", "Devon League South West"),
    ("https://fulltime.thefa.com/league.html?league=6619535", "East Sussex League Premier"),
    ("https://fulltime.thefa.com/league.html?league=4421310", "West Sussex League Premier"),
    ("https://fulltime.thefa.com/league.html?league=7633065", "Northamptonshire Combination Premier"),
    ("https://fulltime.thefa.com/league.html?league=2981097", "Aldershot & District Premier"),
]

HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
}

# ── Fallback: FA Club Finder — scrape by county ──
# Use if league IDs above are outdated
FA_COUNTY_URLS = [
    "https://fulltime.thefa.com/index.html?selectedCounty=21052445",  # Bedfordshire
    "https://fulltime.thefa.com/index.html?selectedCounty=6093434",   # Berkshire
    "https://fulltime.thefa.com/index.html?selectedCounty=7591068",   # Buckinghamshire
    "https://fulltime.thefa.com/index.html?selectedCounty=5195970",   # Cambridgeshire
    "https://fulltime.thefa.com/index.html?selectedCounty=4745218",   # Cheshire
    "https://fulltime.thefa.com/index.html?selectedCounty=8375437",   # Cornwall
    "https://fulltime.thefa.com/index.html?selectedCounty=6604211",   # Cumbria
    "https://fulltime.thefa.com/index.html?selectedCounty=6762322",   # Derbyshire
    "https://fulltime.thefa.com/index.html?selectedCounty=4986162",   # Devon
    "https://fulltime.thefa.com/index.html?selectedCounty=9462283",   # Dorset
    "https://fulltime.thefa.com/index.html?selectedCounty=7223418",   # Durham
    "https://fulltime.thefa.com/index.html?selectedCounty=5412011",   # Essex
    "https://fulltime.thefa.com/index.html?selectedCounty=8967190",   # Gloucestershire
    "https://fulltime.thefa.com/index.html?selectedCounty=6491065",   # Hampshire
    "https://fulltime.thefa.com/index.html?selectedCounty=6696164",   # Herefordshire
    "https://fulltime.thefa.com/index.html?selectedCounty=4458893",   # Hertfordshire
    "https://fulltime.thefa.com/index.html?selectedCounty=2217637",   # Kent
    "https://fulltime.thefa.com/index.html?selectedCounty=6406070",   # Lancashire
    "https://fulltime.thefa.com/index.html?selectedCounty=6276788",   # Leicestershire
    "https://fulltime.thefa.com/index.html?selectedCounty=4540155",   # Lincolnshire
    "https://fulltime.thefa.com/index.html?selectedCounty=6056386",   # London
    "https://fulltime.thefa.com/index.html?selectedCounty=5306184",   # Manchester (Greater)
    "https://fulltime.thefa.com/index.html?selectedCounty=5969157",   # Merseyside
    "https://fulltime.thefa.com/index.html?selectedCounty=4021865",   # Norfolk
    "https://fulltime.thefa.com/index.html?selectedCounty=6955949",   # Northamptonshire
    "https://fulltime.thefa.com/index.html?selectedCounty=4328457",   # Northumberland
    "https://fulltime.thefa.com/index.html?selectedCounty=6124009",   # Nottinghamshire
    "https://fulltime.thefa.com/index.html?selectedCounty=3914197",   # Oxfordshire
    "https://fulltime.thefa.com/index.html?selectedCounty=7201060",   # Shropshire
    "https://fulltime.thefa.com/index.html?selectedCounty=8630474",   # Somerset
    "https://fulltime.thefa.com/index.html?selectedCounty=2044207",   # Staffordshire
    "https://fulltime.thefa.com/index.html?selectedCounty=7158586",   # Suffolk
    "https://fulltime.thefa.com/index.html?selectedCounty=9738576",   # Surrey
    "https://fulltime.thefa.com/index.html?selectedCounty=1435272",   # Sussex
    "https://fulltime.thefa.com/index.html?selectedCounty=2388564",   # Warwickshire
    "https://fulltime.thefa.com/index.html?selectedCounty=5776542",   # West Midlands
    "https://fulltime.thefa.com/index.html?selectedCounty=2810664",   # Wiltshire
    "https://fulltime.thefa.com/index.html?selectedCounty=6348932",   # Worcestershire
    "https://fulltime.thefa.com/index.html?selectedCounty=4113259",   # Yorkshire (various)
]


def extract_club_links(soup, base_url=""):
    """Extract club names and detail page links from a league page."""
    clubs = []

    # FA Full-Time uses various table structures
    # Look for club-related links
    for link in soup.find_all('a', href=True):
        href = link['href']
        text = link.get_text(strip=True)

        # Skip non-club links
        if not text or len(text) < 3:
            continue
        if any(skip in text.lower() for skip in ['league', 'fa ', 'the fa', 'admin', 'login', 'register', 'fixtures', 'results', 'tables']):
            continue

        # Club links typically have 'club' in the URL
        if 'club' in href.lower():
            clubs.append({
                'name': clean_club_name(text),
                'league_href': href if href.startswith('http') else f"https://fulltime.thefa.com{href}"
            })

    return clubs


def fetch_club_page(url):
    """Fetch a club detail page and extract contact info."""
    try:
        resp = requests.get(url, headers=HEADERS, timeout=10)
        soup = BeautifulSoup(resp.text, 'html.parser')

        # Extract website URL if available
        website = None
        for link in soup.find_all('a', href=True):
            href = link['href']
            if 'http' in href and 'fulltime.thefa.com' not in href and 'thefa.com' not in href:
                website = href
                break

        # Extract email if visible
        email = None
        email_match = re.search(r'[\w\.-]+@[\w\.-]+\.\w+', resp.text)
        if email_match:
            email = email_match.group(0)

        return {'website': website, 'email': email}

    except Exception:
        return {'website': None, 'email': None}


def clean_club_name(name):
    """Clean up club names."""
    # Remove common suffixes
    for suffix in [' FC', ' AFC', ' CFC', ' Utd', ' United', ' Town', ' City', ' Rovers', ' Rangers', ' Athletic', ' Wanderers']:
        pass  # Keep full names
    # Remove league/division text
    name = re.sub(r'\s*(First|Second|Third|Premier|Division|Div).*$', '', name)
    return name.strip()


def main():
    all_clubs = []
    seen = set()

    for url, league_name in LEAGUES:
        print(f"\n📋 Scraping {league_name}...")
        try:
            resp = requests.get(url, headers=HEADERS, timeout=15)
            soup = BeautifulSoup(resp.text, 'html.parser')

            clubs = extract_club_links(soup)
            unique = 0
            for club in clubs:
                if club['name'] not in seen:
                    seen.add(club['name'])
                    club['league'] = league_name
                    all_clubs.append(club)
                    unique += 1

            print(f"   Found {unique} clubs ({len(seen)} total)")

        except Exception as e:
            print(f"   ⚠ Failed: {e}")

        time.sleep(1)  # Be respectful

    print(f"\n✅ Total unique clubs scraped: {len(all_clubs)}")

    # ── Optionally enrich with contact details ──
    print("\n🔍 Fetching club contact pages for emails...")
    enriched = 0
    for club in all_clubs:
        if club['league_href']:
            info = fetch_club_page(club['league_href'])
            club.update(info)
            if info['email']:
                enriched += 1
            print(f"   {club['name']}: {'✓ ' + info['email'] if info['email'] else 'no email found'}")
        time.sleep(0.3)

    print(f"\n📧 Clubs with emails found: {enriched}/{len(all_clubs)}")

    # ── Write CSV ──
    with open('clubs.csv', 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=['name', 'email', 'website', 'league'])
        writer.writeheader()
        for club in all_clubs:
            writer.writerow({
                'name': club['name'],
                'email': club.get('email', ''),
                'website': club.get('website', ''),
                'league': club['league'],
            })

    print(f"\n💾 Saved to clubs.csv")
    print("Next: python generate_emails.py  →  outreach_emails.csv  →  import to Brevo/Mailchimp")


if __name__ == '__main__':
    main()
