"""
Discovery module — Multi-source club list building (Pass 1-2)
"""

import re
import time
import logging
from urllib.parse import urljoin

import requests
from bs4 import BeautifulSoup

from config import (
    HEADERS, REQUEST_DELAY, REQUEST_TIMEOUT, MAX_RETRIES, RETRY_BACKOFF,
    WIKI_URLS, STEPS,
)
from database import ClubDatabase

log = logging.getLogger(__name__)


class ClubDiscoverer:
    def __init__(self, db: ClubDatabase):
        self.db = db
        self.session = requests.Session()
        self.session.headers.update(HEADERS)

    def pass1_wikipedia(self):
        """PASS 1: Extract clubs from Wikipedia league pages."""
        print("\n📚 PASS 1: Wikipedia club extraction...")
        clubs_found = 0

        for url, step, league_name in WIKI_URLS:
            try:
                print(f"   {league_name}...", end=" ")
                resp = self._get(url)
                if not resp:
                    print("⚠ failed")
                    continue

                soup = BeautifulSoup(resp.text, 'html.parser')
                extracted = []

                for table in soup.find_all('table', class_='wikitable'):
                    for row in table.find_all('tr')[1:]:
                        cols = row.find_all('td')
                        if cols:
                            link = cols[0].find('a')
                            if link:
                                name = link.get_text(strip=True)
                                if len(name) > 4 and not name[0].isdigit():
                                    extracted.append({
                                        'club_name': clean_club_name(name),
                                        'step': str(step) if step else '',
                                        'league': league_name if step else '',
                                        'source_type': 'Wikipedia',
                                        'source_url': url,
                                        'confidence': 'Medium',
                                    })

                # Dedup within batch
                seen = set()
                unique = []
                for c in extracted:
                    if c['club_name'].lower() not in seen:
                        seen.add(c['club_name'].lower())
                        unique.append(c)

                added, updated = self.db.upsert_batch(unique)
                clubs_found += added
                print(f"✓ {added} new")
                time.sleep(REQUEST_DELAY)

            except Exception as e:
                print(f"⚠ {e}")
                continue

        print(f"\n   Wikipedia total: {clubs_found} new clubs")
        return clubs_found

    def pass2_website_discovery(self):
        """PASS 2: Find official club websites via Google search hints."""
        print("\n🔍 PASS 2: Website discovery...")
        websites_found = 0

        clubs_without_website = [
            c for c in self.db.clubs if not c.get('website')
        ]

        if not clubs_without_website:
            print("   All clubs already have websites.")
            return 0

        print(f"   {len(clubs_without_website)} clubs need websites.")
        print("   (Use manual search or Hunter.io for bulk discovery)")
        print("   💡 Tip: Upload clubs.csv to hunter.io/domain-search")

        return websites_found

    def pass3_league_sites(self):
        """PASS 3: Scrape league websites for club lists + emails."""
        print("\n🌐 PASS 3: League website scraping...")
        emails_found = 0

        league_urls = [
            ("Northern Premier League", "https://www.thenpl.co.uk/clubs"),
            ("Isthmian League", "https://www.isthmian.co.uk/clubs"),
            ("North West Counties", "https://www.nwcfl.com/clubs.php"),
            ("Northern Counties East", "https://www.ncefl.org.uk/clubs/"),
            ("Western League", "https://www.westernleague.co.uk/clubs"),
            ("Wessex League", "https://www.wessexleague.co.uk/clubs"),
            ("Hellenic League", "https://www.hellenicleague.co.uk/clubs"),
            ("Essex Senior", "https://essexseniorleague.co.uk/clubs/"),
            ("Southern Counties East", "https://scefl.com/clubs.php"),
            ("Combined Counties", "https://combinedcounties.com/clubs"),
            ("Spartan South Midlands", "https://www.spartansouthmidlandsleague.co.uk/clubs"),
            ("United Counties", "https://www.uhlsportunitedcountiesleague.co.uk/clubs"),
            ("Northern League", "https://www.northernfootballleague.org/clubs/"),
            ("Midland League", "https://www.midlandfootballleague.co.uk/clubs"),
        ]

        for league_name, url in league_urls:
            try:
                print(f"   {league_name}...", end=" ")
                resp = self._get(url)
                if not resp:
                    print("⚠ unreachable")
                    continue

                text = resp.text
                # Find all emails on the page
                emails = re.findall(r'[\w\.-]+@[\w\.-]+\.\w{2,}', text)
                emails = list(set(
                    e.lower() for e in emails
                    if not any(x in e.lower() for x in
                              ['example', 'test', 'domain', 'wordpress', 'sentry',
                               'pixie', 'thefa.com', 'fulltime', '@twitter', '@facebook'])
                ))

                # Find club names on the page
                soup = BeautifulSoup(text, 'html.parser')
                club_names = []
                for link in soup.find_all('a', href=True):
                    t = link.get_text(strip=True)
                    href = link.get('href', '').lower()
                    if len(t) >= 5 and len(t) <= 50 and t[0].isupper():
                        if any(w in href for w in ['club', 'team', 'profile']):
                            if not any(skip in t.lower() for skip in
                                      ['league', 'division', 'sponsor', 'fixtures', 'results', 'admin']):
                                club_names.append(t)

                # Try to match emails to clubs
                for email in emails:
                    # Find which club name appears near this email in the page
                    pos = text.lower().find(email)
                    chunk = text[max(0, pos-300):pos].lower() if pos >= 0 else ''

                    matched_club = None
                    for name in club_names:
                        if name.lower() in chunk:
                            matched_club = name
                            break

                    self.db.upsert({
                        'club_name': matched_club or 'Unknown Club',
                        'league': league_name,
                        'email': email,
                        'email_type': classify_email(email),
                        'source_type': 'League Website',
                        'source_url': url,
                        'confidence': 'Medium',
                        'verification_status': 'Found',
                        'notes': f'Found on {league_name} league website' if matched_club else 'Club name not matched',
                    })

                print(f"✓ {len(emails)} emails")
                emails_found += len(emails)
                time.sleep(REQUEST_DELAY)

            except Exception as e:
                print(f"⚠ {e}")
                continue

        print(f"\n   League sites total: {emails_found} emails found")
        return emails_found

    def _get(self, url: str, retries: int = 0) -> requests.Response | None:
        """GET with retry + backoff."""
        try:
            resp = self.session.get(url, timeout=REQUEST_TIMEOUT)
            if resp.status_code == 200:
                return resp
            elif resp.status_code in (403, 429) and retries < MAX_RETRIES:
                wait = RETRY_BACKOFF * (2 ** retries)
                time.sleep(wait)
                return self._get(url, retries + 1)
        except Exception:
            if retries < MAX_RETRIES:
                time.sleep(RETRY_BACKOFF * (2 ** retries))
                return self._get(url, retries + 1)
        return None


def clean_club_name(name: str) -> str:
    """Clean Wikipedia-style club names."""
    name = re.sub(r'\s*\(.*?\)', '', name)  # Remove (disambiguation)
    name = re.sub(r'\s*F\.?C\.?\s*$', '', name).strip()
    return name


def classify_email(email: str) -> str:
    """Classify an email address by its local part."""
    from config import EMAIL_CLASSIFICATIONS
    local = email.lower().split('@')[0]
    for classification, keywords in EMAIL_CLASSIFICATIONS.items():
        for kw in keywords:
            if kw in local:
                return classification
    return 'Other'
