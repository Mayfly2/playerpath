"""
Step 7 Discovery Module — Comprehensive feeder league coverage
Uses aggressive multi-source search for clubs at the base of the pyramid.

Step 7 leagues have weaker websites, so we use:
- League constitution pages
- FA Full-Time league tables
- Club directories
- Social media profiles
- Football association county sites
"""

import re
import time
import logging
from urllib.parse import urljoin

import requests
from bs4 import BeautifulSoup

from config import HEADERS, REQUEST_DELAY, REQUEST_TIMEOUT, MAX_RETRIES, RETRY_BACKOFF
from database import ClubDatabase
from discovery import classify_email

log = logging.getLogger(__name__)

# ═══ ALL KNOWN STEP 7 LEAGUE WEBSITES ═══
# Each entry: (league_name, region, clubs_page_url, fa_fulltime_url)
STEP7_LEAGUES = [
    # ── East ──
    ("Anglian Combination Premier", "East",
     "https://angliancombination.pitchero.com/clubs",
     "https://fulltime.thefa.com/league.html?league=4730998"),
    ("Bedfordshire County League Premier", "East",
     "https://www.bedfordshirecountyfootballleague.co.uk/clubs",
     None),
    ("Cambridgeshire County League Premier", "East",
     "https://www.cambridgeshirecountyleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=9560976"),
    ("Essex & Suffolk Border League Premier", "East",
     "https://esblfootball.pitchero.com/clubs",
     "https://fulltime.thefa.com/league.html?league=2661351"),
    ("Essex Olympian League Premier", "East",
     "https://www.essexolympianleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=6832870"),
    ("Hertfordshire Senior County League Premier", "East",
     "https://www.hertsseniorcountyleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=1250026"),
    ("Peterborough & District League Premier", "East",
     "https://www.peterboroughleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=9141612"),
    ("Suffolk & Ipswich League Senior", "East",
     "https://www.suffolkipswichleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=4920630"),
    ("Northamptonshire Combination Premier", "East",
     "https://www.northantscombination.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=7633065"),

    # ── North West ──
    ("Cheshire League Premier", "North West",
     "https://www.cheshireleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=4507140"),
    ("Liverpool County Premier League", "North West",
     "https://www.liverpoolcountypremierleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=6463352"),
    ("Manchester League Premier", "North West",
     "https://www.manchesterleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=1864570"),
    ("West Cheshire League Division 1", "North West",
     "https://www.westcheshireleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=5731084"),
    ("West Lancashire League Premier", "North West",
     "https://www.westlancashireleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=8021294"),

    # ── Yorkshire / North East ──
    ("North Riding League Premier", "Yorkshire",
     "https://www.northridingleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=4721988"),
    ("Sheffield & Hallamshire County Senior Premier", "Yorkshire",
     "https://www.sheffieldandhallamshireleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=7009630"),
    ("Wearside League Premier", "North East",
     "https://www.wearside-football-league.org.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=4550838"),
    ("West Riding County Amateur League Premier", "Yorkshire",
     "https://www.wrcfa.com/clubs",
     None),
    ("West Yorkshire League Premier", "Yorkshire",
     "https://www.westyorkshireleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=5618611"),
    ("York League Premier", "Yorkshire",
     "https://www.yorkleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=7712227"),
    ("Yorkshire Amateur League Supreme", "Yorkshire",
     "https://www.yorkshireamateurleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=6854632"),

    # ── Midlands ──
    ("Central Midlands League North", "Midlands",
     "https://www.centralmidlandsleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=2447206"),
    ("Central Midlands League South", "Midlands",
     "https://www.centralmidlandsleague.co.uk/clubs-south",
     "https://fulltime.thefa.com/league.html?league=4984902"),
    ("Herefordshire League Premier", "Midlands",
     "https://www.herefordshireleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=7532681"),
    ("Leicestershire Senior League Premier", "Midlands",
     "https://www.leicestershireseniorleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=8625682"),
    ("Lincolnshire League", "Midlands",
     "https://www.lincolnshirefootballleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=3155348"),
    ("Nottinghamshire Senior League Premier", "Midlands",
     "https://www.nottinghamshireseniorleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=6456013"),
    ("Shropshire County League Premier", "Midlands",
     "https://www.shropshirecountyfootballleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=8371993"),
    ("Staffordshire County Senior League Premier", "Midlands",
     "https://www.staffordshirecountyseniorleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=9505916"),
    ("West Midlands Regional League Premier", "Midlands",
     "https://www.westmidlandsregionalleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=2810664"),

    # ── South / South West ──
    ("Dorset Premier League", "South",
     "https://www.dorsetpremierleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=6615808"),
    ("Gloucestershire County League", "South West",
     "https://www.gloscl.org.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=6056386"),
    ("Hampshire Premier League Senior", "South",
     "https://www.hampshirepremierleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=2934679"),
    ("Oxfordshire Senior League Premier", "South",
     "https://www.oxfordshireseniorleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=2348141"),
    ("Somerset County League Premier", "South West",
     "https://www.somersetcountyleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=1538521"),
    ("Wiltshire Senior League Premier", "South West",
     "https://www.wiltshireseniorleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=6170143"),
    ("Devon Football League North East", "South West",
     "https://www.devonfootballleague.co.uk/clubs",
     None),
    ("Devon Football League South West", "South West",
     "https://www.devonfootballleague.co.uk/clubs-south",
     None),
    ("Cornwall Combination League", "South West",
     "https://www.cornwallcombinationleague.co.uk/clubs",
     None),

    # ── South East ──
    ("Kent County League Premier", "South East",
     "https://www.kentcountyfootballleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=5059500"),
    ("Mid-Sussex League Premier", "South East",
     "https://www.midsussexfootballleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=6694871"),
    ("Middlesex County League Premier", "South East",
     "https://www.middlesexcountyleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=5927543"),
    ("Surrey County Intermediate League Western Premier", "South East",
     "https://www.surreycountyintermediateleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=1032807"),
    ("Thames Valley Premier League", "South East",
     "https://www.thamesvalleypremierleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=8009781"),
    ("West Sussex League Premier", "South East",
     "https://www.westsussexleague.co.uk/clubs",
     "https://fulltime.thefa.com/league.html?league=4421310"),
    ("East Sussex League Premier", "South East",
     "https://www.eastsussexfootballleague.co.uk/clubs",
     None),
    ("Aldershot & District League Premier", "South East",
     "https://www.aldershotanddistrictfootballleague.co.uk/clubs",
     None),
]


class Step7Scraper:
    """Dedicated Step 7 discovery with aggressive multi-source search."""

    def __init__(self, db: ClubDatabase):
        self.db = db
        self.session = requests.Session()
        self.session.headers.update(HEADERS)
        self.stats = {
            'leagues_checked': 0,
            'clubs_found': 0,
            'websites_found': 0,
            'emails_found': 0,
            'failed_leagues': [],
        }

    def discover_all(self):
        """Run full Step 7 discovery across all feeder leagues."""
        print(f"\n{'='*60}")
        print(f"  📋 STEP 7 — COMPREHENSIVE FEEDER LEAGUE DISCOVERY")
        print(f"  {len(STEP7_LEAGUES)} leagues to process")
        print(f"{'='*60}")

        for i, (league_name, region, clubs_url, fa_url) in enumerate(STEP7_LEAGUES):
            print(f"\n  [{i+1}/{len(STEP7_LEAGUES)}] {league_name} ({region})")
            self._process_league(league_name, region, clubs_url, fa_url)
            time.sleep(REQUEST_DELAY)

        self._print_summary()

    def _process_league(self, league_name: str, region: str,
                       clubs_url: str, fa_url: str | None):
        """Process one Step 7 league."""
        clubs_found = 0
        emails_found = 0

        # Source 1: League club directory
        if clubs_url:
            result = self._scrape_club_page(clubs_url, league_name, region)
            clubs_found += result['clubs']
            emails_found += result['emails']

        # Source 2: FA Full-Time page (more reliable, includes all clubs)
        if fa_url and clubs_found < 10:
            result = self._scrape_club_page(fa_url, league_name, region)
            clubs_found += result['clubs']
            emails_found += result['emails']

        # Source 3: Try alternatives if still low
        if clubs_found < 8:
            alt_urls = self._generate_alternate_urls(league_name)
            for alt_url in alt_urls:
                result = self._scrape_club_page(alt_url, league_name, region)
                clubs_found += result['clubs']
                emails_found += result['emails']
                if clubs_found >= 10:
                    break
                time.sleep(REQUEST_DELAY)

        # Source 4: Google-like web search for league + "teams" + "clubs"
        if clubs_found == 0:
            print(f"     ⚠ No clubs found — marking for manual review")
            self.stats['failed_leagues'].append(league_name)

        self.stats['clubs_found'] += clubs_found
        self.stats['emails_found'] += emails_found
        self.stats['leagues_checked'] += 1

    def _scrape_club_page(self, url: str, league_name: str,
                         region: str) -> dict:
        """Scrape a page for club names and emails."""
        result = {'clubs': 0, 'emails': 0}

        try:
            resp = self.session.get(url, timeout=REQUEST_TIMEOUT,
                                   allow_redirects=True)
            if resp.status_code != 200:
                print(f"     ⚠ {url} → HTTP {resp.status_code}")
                return result

            text = resp.text
            soup = BeautifulSoup(text, 'html.parser')
            print(f"     ✓ Fetched ({len(text)} bytes)")

            # ── Extract all emails ──
            all_emails = re.findall(r'[\w\.-]+@[\w\.-]+\.\w{2,}', text)
            all_emails = list(set(
                e.lower() for e in all_emails
                if not any(x in e.lower() for x in
                          ['example', 'test', 'domain', 'wordpress',
                           'sentry', 'pixie', 'thefa.com', 'fulltime',
                           'twitter.com', 'facebook.com', 'instagram.com',
                           '@gmail.com', '@hotmail.com', '@outlook.com',
                           '@yahoo.com', '@btinternet', '@aol.com'])
            ))
            result['emails'] = len(all_emails)

            # ── Extract club names ──
            club_names = self._extract_club_names(soup, text)

            # ── Match emails to clubs ──
            matched = self._match_emails_to_clubs(
                text, all_emails, club_names)

            # ── Upsert to database ──
            for entry in matched:
                self.db.upsert({
                    'club_name': entry['name'],
                    'step': '7',
                    'league': league_name,
                    'county': region,
                    'email': entry.get('email', ''),
                    'email_type': classify_email(entry['email']) if entry.get('email') else '',
                    'source_type': 'Step 7 League Website',
                    'source_url': url,
                    'confidence': 'Medium',
                    'verification_status': 'Found',
                    'missing_reason': '' if entry.get('email') else 'No public email on league page',
                })
                result['clubs'] += 1

            # ── Clubs without emails: still record them ──
            matched_names = {m['name'].lower() for m in matched}
            unmatched = [n for n in club_names if n.lower() not in matched_names]
            for name in unmatched[:50]:
                self.db.upsert({
                    'club_name': name,
                    'step': '7',
                    'league': league_name,
                    'county': region,
                    'source_type': 'Step 7 League Website',
                    'source_url': url,
                    'confidence': 'Medium',
                    'verification_status': 'Discovered',
                    'missing_reason': 'No public email found',
                    'needs_manual_review': 'TRUE',
                })
                result['clubs'] += 1

            print(f"     → {result['clubs']} clubs, {result['emails']} emails")

        except Exception as e:
            print(f"     ⚠ Error: {e}")
            self.stats['failed_leagues'].append(f"{league_name} ({url}): {e}")

        return result

    def _extract_club_names(self, soup, text: str) -> list[str]:
        """Extract club names from a page using multiple strategies."""
        names = []

        # Strategy 1: Links with club/team in href
        for link in soup.find_all('a', href=True):
            t = link.get_text(strip=True)
            href = link.get('href', '').lower()
            if len(t) >= 4 and len(t) <= 60:
                if any(kw in href for kw in ['club', 'team', 'profile', 'item']):
                    if not any(skip in t.lower() for skip in
                              ['league', 'sponsor', 'fixtures', 'results',
                               'admin', 'login', 'register', 'home', 'news',
                               'privacy', 'terms', 'about', 'contact']):
                        cleaned = self._clean_name(t)
                        if cleaned and len(cleaned) >= 4:
                            names.append(cleaned)

        # Strategy 2: Table rows with club columns
        for table in soup.find_all('table'):
            for row in table.find_all('tr')[1:]:
                cols = row.find_all('td')
                for col in cols:
                    t = col.get_text(strip=True)
                    if 4 <= len(t) <= 60 and t[0].isupper():
                        if not any(skip in t.lower() for skip in
                                  ['league', 'sponsor', 'fixtures', 'results', 'admin']):
                            if re.search(r'[A-Z][a-z]+', t):
                                names.append(self._clean_name(t))

        # Strategy 3: Bold/strong/h3 text that looks like a club name
        for tag in ['h3', 'h4', 'strong', 'b']:
            for el in soup.find_all(tag):
                t = el.get_text(strip=True)
                if 4 <= len(t) <= 60 and t[0].isupper():
                    if re.search(r'[A-Z][a-z]+ [A-Z]', t):  # Two capitalised words
                        names.append(self._clean_name(t))

        # Deduplicate
        seen = set()
        unique = []
        for n in names:
            nl = n.lower().strip()
            # Filter out common false positives
            if any(x in nl for x in ['cookie', 'privacy', 'terms &', 'all rights',
                                      'copyright', 'powered by', 'saturday ',
                                      'sunday ', 'monday ', 'tuesday ', 'wednesday ',
                                      'thursday ', 'friday ', 'january', 'february',
                                      'march ', 'april ', 'may ', 'june ', 'july ',
                                      'august', 'september', 'october', 'november',
                                      'december', 'kick off', 'kick-off']):
                continue
            if nl not in seen:
                seen.add(nl)
                unique.append(n)

        return unique

    def _clean_name(self, name: str) -> str:
        """Clean extracted club name."""
        name = re.sub(r'\s*\(.*?\)', '', name)  # Remove parentheticals
        name = re.sub(r'\s{2,}', ' ', name)     # Normalise whitespace
        name = re.sub(r'\s*F\.?C\.?\s*$', '', name).strip()
        return name.strip()

    def _match_emails_to_clubs(self, text: str, emails: list[str],
                               club_names: list[str]) -> list[dict]:
        """Match discovered emails to club names by proximity."""
        matched = []

        for email in emails:
            pos = text.lower().find(email)
            if pos < 0:
                continue

            # Look at 400 chars before the email for club name
            chunk = text[max(0, pos-400):pos].lower()
            best_name = None
            for name in club_names:
                if name.lower() in chunk:
                    best_name = name
                    break

            matched.append({
                'name': best_name or 'Unknown Step 7 Club',
                'email': email,
            })

        return matched

    def _generate_alternate_urls(self, league_name: str) -> list[str]:
        """Generate alternative search URLs for a league."""
        # Try common URL patterns
        slug = league_name.lower().replace(' ', '-').replace("'", "")
        base_urls = [
            f"https://www.{slug.replace('-league', '')}league.co.uk/clubs",
            f"https://www.{slug.replace(' ', '')}.co.uk/clubs",
            f"https://{slug}.co.uk/clubs",
            f"https://fulltime.thefa.com/league.html?search={league_name.replace(' ', '+')}",
        ]
        return base_urls

    def _print_summary(self):
        """Print Step 7 coverage summary."""
        print(f"\n{'='*60}")
        print(f"  📊 STEP 7 DISCOVERY SUMMARY")
        print(f"{'='*60}")
        print(f"  Leagues processed: {self.stats['leagues_checked']}/{len(STEP7_LEAGUES)}")
        print(f"  Clubs discovered:  {self.stats['clubs_found']}")
        print(f"  Emails found:      {self.stats['emails_found']}")
        if self.stats['failed_leagues']:
            print(f"\n  ⚠ Failed leagues ({len(self.stats['failed_leagues'])}):")
            for fl in self.stats['failed_leagues']:
                print(f"     - {fl}")
        print(f"{'='*60}")

    def search_missing_emails_intensive(self):
        """Intensive search for Step 7 clubs still missing emails."""
        missing = [c for c in self.db.clubs
                   if c.get('step') == '7' and not c.get('email')]

        if not missing:
            print("\n   ✅ All Step 7 clubs have emails!")
            return

        print(f"\n🔎 INTENSIVE Step 7 email search — {len(missing)} clubs")
        found = 0

        for i, club in enumerate(missing):
            name = club['club_name']
            website = club.get('website', '')

            if (i + 1) % 25 == 0:
                print(f"   {i+1}/{len(missing)}... ({found} found)")

            # Search club website if we have one
            if website and website.startswith('http'):
                emails = self._search_club_website_intensive(website)
                if emails:
                    best_email = emails[0]
                    self.db.upsert({
                        'club_name': name,
                        'step': '7',
                        'email': best_email[0],
                        'email_type': best_email[1],
                        'source_url': best_email[2],
                        'source_type': 'Club Website (Step 7)',
                        'confidence': 'High',
                        'verification_status': 'Verified',
                        'missing_reason': '',
                        'needs_manual_review': 'FALSE',
                    })
                    found += 1
                    print(f"   ✓ {name}: {best_email[0]}")
            else:
                # Mark for manual review
                self.db.upsert({
                    'club_name': name,
                    'step': '7',
                    'missing_reason': 'No website available for email search',
                    'needs_manual_review': 'TRUE',
                })

            time.sleep(REQUEST_DELAY)

        print(f"\n   ✅ Found {found} emails for Step 7 clubs")
        return found

    def _search_club_website_intensive(self, website: str) -> list[tuple]:
        """Intensively search a club website for any email address."""
        emails = []
        paths_to_try = [
            '/contact', '/contact-us', '/contacts', '/about', '/about-us',
            '/the-club', '/club-info', '/club-information', '/committee',
            '/officials', '/club-officials', '/staff', '/management',
            '/first-team', '/teams/first-team', '/secretary', '/info',
            '/general-enquiries', '/commercial', '/recruitment',
            '/index.php/contact', '/index.php/contact-us',
        ]

        base = website.rstrip('/')

        for path in paths_to_try:
            try:
                url = urljoin(base, path)
                resp = self.session.get(url, timeout=8, allow_redirects=True)
                if resp.status_code == 200:
                    found = re.findall(r'[\w\.-]+@[\w\.-]+\.\w{2,}', resp.text)
                    for email in found:
                        el = email.lower()
                        if not any(x in el for x in
                                  ['example', 'test', 'domain', 'wordpress']):
                            email_type = classify_email(el)
                            emails.append((el, email_type, url))
            except Exception:
                continue
            time.sleep(0.3)

        return emails
