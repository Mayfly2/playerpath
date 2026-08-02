#!/usr/bin/env python3
"""
Scrape English football clubs from Wikipedia (Steps 1-7).
Wikipedia is always accessible and has comprehensive lists.

Usage:
  pip install requests beautifulsoup4
  python scrape_clubs.py
"""

import csv
import re
import time
import sys

try:
    import requests
    from bs4 import BeautifulSoup
except ImportError:
    sys.exit("Run: pip install requests beautifulsoup4")

HEADERS = {
    'User-Agent': 'PlayerPath/1.0 (club outreach; contact@playerpath.app)'
}

# Wikipedia pages with club tables
WIKI_URLS = [
    # Step 1-2
    ("https://en.wikipedia.org/wiki/National_League_(division)", "National League"),
    ("https://en.wikipedia.org/wiki/National_League_North", "National League North"),
    ("https://en.wikipedia.org/wiki/National_League_South", "National League South"),
    # Step 3
    ("https://en.wikipedia.org/wiki/Northern_Premier_League", "Northern Premier League"),
    ("https://en.wikipedia.org/wiki/Southern_Football_League", "Southern League"),
    ("https://en.wikipedia.org/wiki/Isthmian_League", "Isthmian League"),
    # Step 5-6 (feeder leagues)
    ("https://en.wikipedia.org/wiki/English_football_league_system", "All Steps"),
    ("https://en.wikipedia.org/wiki/List_of_football_clubs_in_England", "All England"),
    # Regional Step 5-6 leagues
    ("https://en.wikipedia.org/wiki/Northern_Counties_East_Football_League", "NC East League"),
    ("https://en.wikipedia.org/wiki/North_West_Counties_Football_League", "NW Counties League"),
    ("https://en.wikipedia.org/wiki/Midland_Football_League", "Midland League"),
    ("https://en.wikipedia.org/wiki/United_Counties_League", "United Counties"),
    ("https://en.wikipedia.org/wiki/Hellenic_Football_League", "Hellenic League"),
    ("https://en.wikipedia.org/wiki/Western_Football_League", "Western League"),
    ("https://en.wikipedia.org/wiki/Wessex_Football_League", "Wessex League"),
    ("https://en.wikipedia.org/wiki/Eastern_Counties_Football_League", "Eastern Counties"),
    ("https://en.wikipedia.org/wiki/Essex_Senior_Football_League", "Essex Senior"),
    ("https://en.wikipedia.org/wiki/Southern_Counties_East_Football_League", "SC East"),
    ("https://en.wikipedia.org/wiki/Combined_Counties_Football_League", "Combined Counties"),
    ("https://en.wikipedia.org/wiki/Spartan_South_Midlands_Football_League", "Spartan SM"),
    ("https://en.wikipedia.org/wiki/Northern_Football_League", "Northern League"),
    # Step 7+
    ("https://en.wikipedia.org/wiki/Anglian_Combination", "Anglian Combination"),
    ("https://en.wikipedia.org/wiki/Central_Midlands_Football_League", "Central Midlands"),
    ("https://en.wikipedia.org/wiki/Cheshire_Association_Football_League", "Cheshire League"),
    ("https://en.wikipedia.org/wiki/Dorset_Premier_Football_League", "Dorset Premier"),
    ("https://en.wikipedia.org/wiki/Essex_Olympian_Football_League", "Essex Olympian"),
    ("https://en.wikipedia.org/wiki/Gloucestershire_County_Football_League", "Gloucestershire"),
    ("https://en.wikipedia.org/wiki/Hampshire_Premier_Football_League", "Hampshire Premier"),
    ("https://en.wikipedia.org/wiki/Kent_County_Football_League", "Kent County"),
    ("https://en.wikipedia.org/wiki/Leicestershire_Senior_League", "Leicestershire"),
    ("https://en.wikipedia.org/wiki/Lincolnshire_Football_League", "Lincolnshire"),
    ("https://en.wikipedia.org/wiki/Manchester_Football_League", "Manchester League"),
    ("https://en.wikipedia.org/wiki/Mid-Sussex_Football_League", "Mid-Sussex"),
    ("https://en.wikipedia.org/wiki/Staffordshire_County_Senior_League", "Staffordshire"),
    ("https://en.wikipedia.org/wiki/Surrey_Elite_Intermediate_Football_League", "Surrey Elite"),
    ("https://en.wikipedia.org/wiki/Thames_Valley_Premier_Football_League", "Thames Valley"),
    ("https://en.wikipedia.org/wiki/West_Lancashire_Football_League", "West Lancashire"),
    ("https://en.wikipedia.org/wiki/West_Midlands_(Regional)_League", "West Midlands"),
    ("https://en.wikipedia.org/wiki/West_Yorkshire_Association_Football_League", "West Yorkshire"),
    ("https://en.wikipedia.org/wiki/York_Football_League", "York League"),
]


def extract_clubs_from_page(url, league_name):
    """Extract club names from a Wikipedia page's league table."""
    clubs = []
    try:
        resp = requests.get(url, headers=HEADERS, timeout=15)
        soup = BeautifulSoup(resp.text, 'html.parser')

        # Find the main league table (usually the first wikitable)
        tables = soup.find_all('table', class_='wikitable')
        for table in tables:
            headers = [th.get_text(strip=True).lower() for th in table.find_all('th')]
            # Check if this is a club table (has "club" or "team" column)
            has_club_col = any('club' in h or 'team' in h for h in headers)

            for row in table.find_all('tr')[1:]:  # Skip header
                cols = row.find_all('td')
                if not cols:
                    continue

                # Try to find club name: first cell, or cell with link
                name = None
                website = None

                for col in cols:
                    link = col.find('a')
                    if link:
                        text = link.get_text(strip=True)
                        href = link.get('href', '')

                        # Is this a club link? (internal wiki link or external)
                        if text and len(text) > 3:
                            # Skip non-club rows
                            if any(skip in text.lower() for skip in
                                   ['league', 'division', 'promoted', 'relegated', 'winners', 'champions',
                                    'season', 'remaining', 'note', 'source', 'reference', 'qualification']):
                                continue
                            if text[0].isdigit():
                                continue  # Position numbers

                            if name is None and '/' in href and not href.startswith('#'):
                                # Likely a club Wikipedia page
                                if not any(x in href.lower() for x in
                                           ['/wiki/category:', '/wiki/template:', '/wiki/help:', '#cite']):
                                    name = text

                    # Check for external website link (class="external text" etc)
                    ext_link = col.find('a', class_='external')
                    if ext_link and not website:
                        website = ext_link.get('href')

                if name:
                    clubs.append({
                        'name': clean_name(name),
                        'league': league_name,
                        'website': website,
                    })

        # Deduplicate
        seen = set()
        unique = []
        for c in clubs:
            if c['name'].lower() not in seen:
                seen.add(c['name'].lower())
                unique.append(c)

        return unique

    except Exception as e:
        print(f"   ⚠ {e}")
        return []


def clean_name(name):
    """Clean Wikipedia club names."""
    # Remove "F.C." variations, just keep the name
    name = re.sub(r'\s*F\.?C\.?\s*$', '', name)
    name = re.sub(r'\s*A\.?F\.?C\.?\s*$', '', name)
    # Remove Wikipedia disambiguation
    name = re.sub(r'\s*\(.*?\)$', '', name)
    return name.strip()


def scrape_email_from_wiki_page(club_name):
    """Try to find club website/email from the Wikipedia club page."""
    # Try searching the club's Wikipedia page
    wiki_name = club_name.replace(' ', '_')
    url = f"https://en.wikipedia.org/wiki/{wiki_name}"
    try:
        resp = requests.get(url, headers=HEADERS, timeout=10)
        if resp.status_code != 200:
            return None, None

        soup = BeautifulSoup(resp.text, 'html.parser')
        # Find external website link in infobox
        infobox = soup.find('table', class_='infobox')
        website = None
        if infobox:
            for link in infobox.find_all('a', href=True):
                href = link['href']
                if href.startswith('http') and 'wikipedia' not in href:
                    website = href
                    break

        # Find email in page
        email = None
        if website:
            try:
                site_resp = requests.get(website, headers=HEADERS, timeout=8, allow_redirects=True)
                emails = re.findall(r'[\w\.-]+@[\w\.-]+\.\w{2,}', site_resp.text)
                for e in emails:
                    if not any(x in e.lower() for x in ['example', 'test', 'domain', 'wordpress', 'wix', 'squarespace']):
                        email = e
                        break
            except Exception:
                pass

        return website, email

    except Exception:
        return None, None


def main():
    all_clubs = []
    seen = set()

    print("⚽ PlayerPath Club Scraper — Wikipedia (Steps 1-7)\n")

    for url, league_name in WIKI_URLS:
        print(f"📋 {league_name}...", end=" ")
        clubs = extract_clubs_from_page(url, league_name)
        new = 0
        for c in clubs:
            key = c['name'].lower()
            if key not in seen and len(key) > 3:
                seen.add(key)
                all_clubs.append(c)
                new += 1
        print(f"{new} clubs (total: {len(all_clubs)})")
        time.sleep(0.5)

    print(f"\n✅ {len(all_clubs)} unique clubs scraped")

    # ── Try to find emails ──
    print("\n🔍 Looking for club emails (first 100 clubs)...")
    enriched = 0
    for i, club in enumerate(all_clubs[:100]):
        website, email = scrape_email_from_wiki_page(club['name'])
        if website:
            club['website'] = website
        if email:
            club['email'] = email
            enriched += 1
        if (i + 1) % 10 == 0:
            print(f"   {i+1}/100... ({enriched} emails)")
        time.sleep(1)

    print(f"   Found {enriched} emails from club websites")

    # ── Write CSV ──
    with open('clubs.csv', 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=['name', 'email', 'website', 'league'])
        writer.writeheader()
        for club in all_clubs:
            writer.writerow({
                'name': club['name'],
                'email': club.get('email') or '',
                'website': club.get('website') or '',
                'league': club['league'],
            })

    print(f"\n💾 Saved to clubs.csv")
    print("Next: python generate_emails.py → import to Brevo/Mailchimp")
    print("💡 For missing emails: sign up at hunter.io → upload clubs.csv → find emails in bulk")

    # Check how many have websites but no emails
    with_website = [c for c in all_clubs if c.get('website')]
    with_email = [c for c in all_clubs if c.get('email')]
    print(f"\n📊 Stats:")
    print(f"   With emails: {len(with_email)}")
    print(f"   With websites (use Hunter.io): {len(with_website)}")
    print(f"   Need manual search: {len(all_clubs) - len(with_website)}")
    print(f"\n💡 To find emails for {len(with_website)} clubs with websites:")
    print("   1. Sign up at https://hunter.io (free 25 searches)")
    print("   2. Paid plan: $49/month for 500 searches")
    print("   3. Upload clubs.csv → Hunter finds emails from domains")


if __name__ == '__main__':
    main()
