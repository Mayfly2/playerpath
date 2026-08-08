#!/usr/bin/env python3
"""
Scrape club emails directly from league websites.
Each league has a clubs/teams directory with contact info.

Usage:
  pip install requests beautifulsoup4
  python scrape_clubs.py
"""

import csv
import re
import time
import sys
from urllib.parse import urljoin

try:
    import requests
    from bs4 import BeautifulSoup
except ImportError:
    sys.exit("Run: pip install requests beautifulsoup4")

HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml',
    'Accept-Language': 'en-GB,en;q=0.9',
}

# Each entry: (league_name, clubs_directory_url)
# These are the ACTUAL league websites with club listings
LEAGUE_SITES = [
    # Step 3 — Premier Divisions
    ("Northern Premier League", "https://www.thenpl.co.uk/clubs"),
    ("Southern League Central", "https://southern-football-league.co.uk/league-table/premier-central/"),
    ("Southern League South", "https://southern-football-league.co.uk/league-table/premier-south/"),
    ("Isthmian Premier", "https://www.isthmian.co.uk/clubs"),

    # Step 4 — Division 1
    ("NPL Division 1 West", "https://www.thenpl.co.uk/league-table/west-division/"),
    ("NPL Division 1 East", "https://www.thenpl.co.uk/league-table/east-division/"),
    ("NPL Division 1 Midlands", "https://www.thenpl.co.uk/league-table/midlands-division/"),
    ("Isthmian North", "https://www.isthmian.co.uk/league-table/north-division/"),
    ("Isthmian South Central", "https://www.isthmian.co.uk/league-table/south-central-division/"),
    ("Isthmian South East", "https://www.isthmian.co.uk/league-table/south-east-division/"),

    # Step 5 — Regional Premier leagues (own websites)
    ("North West Counties Premier", "https://www.nwcfl.com/clubs.php"),
    ("North West Counties Div 1 North", "https://www.nwcfl.com/clubs-division.php?div=1N"),
    ("North West Counties Div 1 South", "https://www.nwcfl.com/clubs-division.php?div=1S"),
    ("Northern Counties East Premier", "https://www.ncefl.org.uk/clubs/"),
    ("Northern Counties East Div 1", "https://www.ncefl.org.uk/clubs/division1/"),
    ("Midland League Premier", "https://fulltime.thefa.com/league.html?league=9913209"),
    ("Hellenic League Premier", "https://www.hellenicleague.co.uk/clubs"),
    ("Western League Premier", "https://www.westernleague.co.uk/clubs"),
    ("Western League Div 1", "https://www.westernleague.co.uk/clubs-div1"),
    ("Wessex League Premier", "https://www.wessexleague.co.uk/clubs"),
    ("Wessex League Div 1", "https://www.wessexleague.co.uk/clubs-div1"),
    ("Eastern Counties Premier", "https://ecl.leaguerepublic.com/index.html"),
    ("Essex Senior League", "https://essexseniorleague.co.uk/clubs/"),
    ("Southern Counties East Premier", "https://scefl.com/clubs.php"),
    ("Combined Counties Premier North", "https://combinedcounties.com/clubs"),
    ("Combined Counties Premier South", "https://combinedcounties.com/clubs-south"),
    ("Spartan South Midlands Premier", "https://www.spartansouthmidlandsleague.co.uk/clubs"),
    ("United Counties Premier North", "https://www.uhlsportunitedcountiesleague.co.uk/clubs"),
    ("United Counties Premier South", "https://www.uhlsportunitedcountiesleague.co.uk/clubs-south"),
    ("Northern League Div 1", "https://www.northernfootballleague.org/clubs/"),

    # Step 6-7 — Local leagues
    ("Cheshire League", "https://www.cheshireleague.co.uk/clubs"),
    ("Manchester League", "https://www.manchesterleague.co.uk/clubs"),
    ("Staffordshire County Senior", "https://www.staffscounty-senior-league.co.uk/clubs"),
    ("West Lancashire League", "https://www.westlancashireleague.co.uk/clubs"),
    ("West Cheshire League", "https://www.westcheshireleague.co.uk/clubs"),
    ("Liverpool County Premier", "https://www.liverpoolcountypremierleague.co.uk/clubs"),
    ("West Yorkshire League", "https://www.westyorkshireleague.co.uk/clubs"),
    ("York League", "https://www.yorkleague.co.uk/clubs"),
    ("Hampshire Premier", "https://www.hampshirepremierleague.co.uk/clubs"),
    ("Dorset Premier", "https://www.dorsetpremierleague.co.uk/clubs"),
    ("Gloucestershire County", "https://www.gloscl.org.uk/clubs"),
    ("Somerset County", "https://www.somersetcountyleague.co.uk/clubs"),
    ("Devon League", "https://www.devonfootballleague.co.uk/clubs"),
    ("Cornwall Combination", "https://www.cornwallcombinationleague.co.uk/clubs"),
    ("Kent County", "https://www.kentcountyfootballleague.co.uk/clubs"),
    ("Essex Olympian", "https://www.essexolympianleague.co.uk/clubs"),
    ("Essex & Suffolk Border", "https://www.esblfootball.com/clubs"),
    ("Suffolk & Ipswich", "https://www.suffolkipswichleague.co.uk/clubs"),
    ("Cambridgeshire County", "https://www.cambscountyfa.com/leagues"),
    ("Herts Senior County", "https://www.hertsseniorcountyleague.co.uk/clubs"),
    ("Bedfordshire County", "https://www.bedfordshirecountyleague.co.uk/clubs"),
    ("Northamptonshire Combination", "https://www.northantscombination.co.uk/clubs"),
    ("Leicestershire Senior", "https://www.leicestershireseniorleague.co.uk/clubs"),
    ("Nottinghamshire Senior", "https://www.nottinghamshireseniorleague.co.uk/clubs"),
    ("Lincolnshire League", "https://www.lincolnshirefootballleague.co.uk/clubs"),
    ("Central Midlands", "https://www.centralmidlandsleague.co.uk/clubs"),
    ("Shropshire County", "https://www.shropshirecountyfootballleague.co.uk/clubs"),
    ("Herefordshire League", "https://www.herefordshireleague.co.uk/clubs"),
    ("West Midlands Regional", "https://www.westmidlandsregionalleague.co.uk/clubs"),
    ("Mid-Sussex League", "https://www.midsussexfootballleague.co.uk/clubs"),
    ("West Sussex League", "https://www.westsussexleague.co.uk/clubs"),
    ("East Sussex League", "https://www.east-sussex-league.co.uk/clubs"),
    ("Thames Valley Premier", "https://www.thamesvalleypremierleague.co.uk/clubs"),
    ("Surrey Elite Intermediate", "https://www.surreyeliteleague.co.uk/clubs"),
    ("Peterborough & District", "https://www.peterboroughleague.co.uk/clubs"),
    ("Anglian Combination", "https://www.angliancombination.co.uk/clubs"),
    ("North Riding League", "https://www.northridingleague.co.uk/clubs"),
    ("Sheffield & Hallamshire", "https://www.sheffieldandhallamshireleague.co.uk/clubs"),
    ("Wearside League", "https://www.wearside-football-league.org.uk/clubs"),
    ("Wiltshire Senior", "https://www.wiltshireseniorleague.co.uk/clubs"),
    ("Oxfordshire Senior", "https://www.oxfordshireseniorleague.co.uk/clubs"),
]


def scrape_club_page(league_name, url):
    """Scrape a league 'clubs' or 'teams' page for club names + emails."""
    clubs = []
    try:
        print(f"   Fetching {url}...")
        resp = requests.get(url, headers=HEADERS, timeout=20, allow_redirects=True)

        if resp.status_code != 200:
            print(f"   ⚠ HTTP {resp.status_code}")
            return []

        soup = BeautifulSoup(resp.text, 'html.parser')
        text = resp.text

        # ── Strategy 1: Find all email addresses on the page ──
        emails_found = re.findall(r'[\w\.-]+@[\w\.-]+\.\w{2,}', text)
        emails_found = [e.lower() for e in emails_found if not any(
            x in e.lower() for x in ['example', 'test', 'domain', 'wordpress', 'sentry', 'pixie', '@thefa.com', '@fulltime']
        )]
        emails_found = list(set(emails_found))

        # ── Strategy 2: Find club names in links or headings ──
        # Look for patterns: club links, h3/h4 headings, list items
        club_names = []

        # Check for club links (most league sites list clubs as links)
        for link in soup.find_all('a', href=True):
            text_content = link.get_text(strip=True)
            href = link.get('href', '').lower()

            if len(text_content) < 4:
                continue

            # Skip obvious non-club links
            skip_words = ['home', 'about', 'contact', 'news', 'fixtures', 'results',
                          'league', 'division', 'sponsor', 'login', 'register', 'twitter',
                          'facebook', 'instagram', 'youtube', 'privacy', 'terms', 'cookie',
                          'admin', 'referee', 'officials', 'history', 'search', 'fa ',
                          'full time', 'full-time']
            if any(w in text_content.lower() for w in skip_words):
                continue

            # Club links often have specific patterns
            useful = False
            if '/club' in href or '/team' in href:
                useful = True
            elif any(word in href for word in ['club-info', 'clubinfo', 'profile', 'detail']):
                useful = True
            # Generic link - check if it looks like a club name (proper noun, 5-40 chars)
            elif len(text_content) >= 5 and len(text_content) <= 50:
                # Must look like a name: starts with capital, contains common club name patterns
                if text_content[0].isupper() and re.search(r'[A-Z][a-z]+', text_content):
                    useful = True

            if useful:
                # Clean the name
                name = text_content.strip()
                name = re.sub(r'\s{2,}', ' ', name)
                name = re.sub(r'\s*\(.*?\)', '', name).strip()
                if name not in club_names and len(name) >= 5:
                    club_names.append(name)

        # Check for headings that might be club names
        for tag in ['h2', 'h3', 'h4', 'strong', 'b']:
            for el in soup.find_all(tag):
                text_content = el.get_text(strip=True)
                if 5 <= len(text_content) <= 50 and text_content[0].isupper():
                    if not any(w in text_content.lower() for w in skip_words):
                        if re.search(r'[A-Z][a-z]+', text_content):
                            if text_content not in club_names:
                                # Check if near an email in the DOM
                                parent = el.parent
                                if parent:
                                    parent_text = parent.get_text()
                                    if '@' in parent_text:
                                        club_names.append(text_content)

        # ── Strategy 3: Pair emails with nearby club names ──
        # Go through each email and find the closest club name in the DOM
        email_clubs = []
        remaining_emails = list(emails_found)
        remaining_names = list(club_names)

        # Try to match emails to names by proximity in HTML
        for email in emails_found:
            # Find the position of this email in the page
            pos = text.lower().find(email)
            if pos < 0:
                continue
            # Look at text before the email for club name hints
            chunk = text[max(0, pos-200):pos]
            best_name = None
            for name in remaining_names:
                if name.lower() in chunk.lower():
                    best_name = name
                    break
            email_clubs.append({'name': best_name or 'Unknown', 'email': email})

        # ── Build final list ──
        for ec in email_clubs:
            clubs.append({
                'name': ec['name'],
                'email': ec['email'],
                'league': league_name,
            })

        # If no email-matched clubs, at least output club names
        if not clubs:
            for name in club_names[:50]:
                clubs.append({
                    'name': name,
                    'email': '',
                    'league': league_name,
                })

        # Try to find a few emails for club-name-only entries by matching
        email_idx = 0
        for club in clubs:
            if not club['email'] and email_idx < len(emails_found):
                club['email'] = emails_found[email_idx]
                email_idx += 1

        print(f"      → {len(clubs)} clubs, {len(emails_found)} emails found")
        return clubs

    except Exception as e:
        print(f"   ⚠ {league_name}: {e}")
        return []


def main():
    all_clubs = []
    seen = set()
    total_emails = 0

    print("⚽ PlayerPath Club Scraper — Direct League Websites\n")
    print(f"Scanning {len(LEAGUE_SITES)} league websites...\n")

    for league_name, url in LEAGUE_SITES:
        print(f"📋 {league_name}")
        clubs = scrape_club_page(league_name, url)

        new = 0
        for club in clubs:
            key = (club['name'].lower(), club.get('email', ''))
            if key not in seen:
                seen.add(key)
                all_clubs.append(club)
                if club.get('email'):
                    total_emails += 1
                new += 1
        print(f"   ✅ {new} new clubs (total: {len(all_clubs)}, emails: {total_emails})")
        time.sleep(1.5)

    # ── Also try the Wikipedia scraper for remaining leagues ──
    print(f"\n📚 Supplementing with Wikipedia...")
    wiki_clubs = scrape_wikipedia_fallback()
    for club in wiki_clubs:
        key = club['name'].lower()
        if key not in {c['name'].lower() for c in all_clubs}:
            all_clubs.append(club)
    print(f"   Added {len(wiki_clubs)} from Wikipedia")

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

    with_email = [c for c in all_clubs if c.get('email')]
    print(f"\n{'='*50}")
    print(f"✅ COMPLETE: {len(all_clubs)} clubs total")
    print(f"📧 With emails: {len(with_email)} ({100*len(with_email)//max(len(all_clubs),1)}%)")
    print(f"💾 Saved to clubs.csv")
    print(f"\nNext: python generate_emails.py → outreach_emails.csv → Brevo/Mailchimp")
    print(f"💡 Use Hunter.io to enrich {len(all_clubs) - len(with_email)} remaining clubs")


def scrape_wikipedia_fallback():
    """Quick Wikipedia fallback for any missed clubs."""
    clubs = []
    wiki_urls = [
        "https://en.wikipedia.org/wiki/National_League_(division)",
        "https://en.wikipedia.org/wiki/National_League_North",
        "https://en.wikipedia.org/wiki/National_League_South",
        "https://en.wikipedia.org/wiki/English_football_league_system",
    ]
    for url in wiki_urls:
        try:
            resp = requests.get(url, headers=HEADERS, timeout=15)
            soup = BeautifulSoup(resp.text, 'html.parser')
            for table in soup.find_all('table', class_='wikitable'):
                for row in table.find_all('tr')[1:]:
                    cols = row.find_all('td')
                    if cols:
                        link = cols[0].find('a')
                        if link and len(link.get_text(strip=True)) > 4:
                            clubs.append({
                                'name': link.get_text(strip=True),
                                'email': '',
                                'website': '',
                                'league': 'Various',
                            })
        except Exception:
            continue
    return clubs


if __name__ == '__main__':
    main()
