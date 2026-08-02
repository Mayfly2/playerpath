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
LEAGUES = [
    # Step 1 — National League
    ("https://fulltime.thefa.com/league.html?league=1621353", "National League"),
    # Step 2 — National League North
    ("https://fulltime.thefa.com/league.html?league=1687544", "National League North"),
    # Step 2 — National League South
    ("https://fulltime.thefa.com/league.html?league=1998475", "National League South"),
    # Step 3 — Northern Premier League
    ("https://fulltime.thefa.com/league.html?league=8704859", "Northern Premier"),
    # Step 3 — Southern League Central
    ("https://fulltime.thefa.com/league.html?league=9128498", "Southern Central"),
    # Step 3 — Southern League South
    ("https://fulltime.thefa.com/league.html?league=1408626", "Southern South"),
    # Step 3 — Isthmian League
    ("https://fulltime.thefa.com/league.html?league=4831636", "Isthmian"),
    # Step 4 — NPL Division 1 West
    ("https://fulltime.thefa.com/league.html?league=2618593", "NPL Div 1 West"),
    # Step 4 — NPL Division 1 East
    ("https://fulltime.thefa.com/league.html?league=5007160", "NPL Div 1 East"),
    # Step 4 — NPL Division 1 Midlands
    ("https://fulltime.thefa.com/league.html?league=4251625", "NPL Div 1 Midlands"),
    # Step 4 — Southern Division 1 Central
    ("https://fulltime.thefa.com/league.html?league=7883260", "Southern Div 1 Central"),
    # Step 4 — Southern Division 1 South
    ("https://fulltime.thefa.com/league.html?league=7419214", "Southern Div 1 South"),
    # Step 4 — Isthmian Division 1 North
    ("https://fulltime.thefa.com/league.html?league=3455392", "Isthmian Div 1 North"),
    # Step 4 — Isthmian Division 1 South Central
    ("https://fulltime.thefa.com/league.html?league=8300427", "Isthmian Div 1 South Central"),
    # Step 4 — Isthmian Division 1 South East
    ("https://fulltime.thefa.com/league.html?league=6578459", "Isthmian Div 1 South East"),
    # Step 5 — North West Counties League
    ("https://fulltime.thefa.com/league.html?league=6060059", "NW Counties Premier"),
    # Step 5 — Northern Counties East
    ("https://fulltime.thefa.com/league.html?league=4310821", "NC East Premier"),
    # Step 5 — Midland League
    ("https://fulltime.thefa.com/league.html?league=9913209", "Midland Premier"),
    # Step 5 — United Counties League
    ("https://fulltime.thefa.com/league.html?league=7244229", "United Counties Premier"),
    # Step 5 — Hellenic League
    ("https://fulltime.thefa.com/league.html?league=6946576", "Hellenic Premier"),
    # Step 5 — Western League
    ("https://fulltime.thefa.com/league.html?league=2143372", "Western Premier"),
    # Step 5 — Wessex League
    ("https://fulltime.thefa.com/league.html?league=9560199", "Wessex Premier"),
    # Step 5 — Eastern Counties
    ("https://fulltime.thefa.com/league.html?league=4705734", "Eastern Counties Premier"),
    # Step 5 — Essex Senior League
    ("https://fulltime.thefa.com/league.html?league=9708130", "Essex Senior"),
    # Step 5 — Southern Counties East
    ("https://fulltime.thefa.com/league.html?league=4806134", "SC East Premier"),
    # Step 5 — Combined Counties
    ("https://fulltime.thefa.com/league.html?league=3801074", "Combined Counties Premier"),
    # Step 5 — Spartan South Midlands
    ("https://fulltime.thefa.com/league.html?league=6098435", "Spartan SM Premier"),
]

HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
}


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
