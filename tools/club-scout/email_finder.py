"""
Email Finder — Systematic email discovery from club websites (Pass 3-6)
"""

import re
import time
import logging
from urllib.parse import urljoin, urlparse

import requests
from bs4 import BeautifulSoup

from config import (
    HEADERS, REQUEST_DELAY, REQUEST_TIMEOUT, MAX_RETRIES, RETRY_BACKOFF,
    CONTACT_PATHS,
)
from database import ClubDatabase
from discovery import classify_email

log = logging.getLogger(__name__)


class EmailFinder:
    def __init__(self, db: ClubDatabase):
        self.db = db
        self.session = requests.Session()
        self.session.headers.update(HEADERS)

    def search_club_website(self, club: dict) -> list[dict]:
        """
        Search a club's website for contact emails.
        Tries contact page paths and scans for email patterns.
        Returns list of email findings.
        """
        website = club.get('website', '').strip()
        if not website or not website.startswith('http'):
            return []

        website = website.rstrip('/')
        findings = []
        visited = set()

        def visit(url: str, page_type: str = 'home'):
            nonlocal findings
            if url in visited:
                return
            visited.add(url)

            try:
                resp = self.session.get(url, timeout=REQUEST_TIMEOUT, allow_redirects=True)
                if resp.status_code != 200:
                    return

                text = resp.text
                soup = BeautifulSoup(text, 'html.parser')

                # Extract emails from this page
                emails = re.findall(r'[\w\.-]+@[\w\.-]+\.\w{2,}', text)
                for email in emails:
                    el = email.lower()
                    if any(x in el for x in ['example', 'test', 'domain', 'wordpress', 'sentry', 'pixie']):
                        continue
                    if el.endswith(('.com', '.co.uk', '.org', '.net', '.gov.uk', '.uk')):
                        email_type = classify_email(email)
                        # Check if email domain matches club domain
                        club_domain = urlparse(website).netloc.lower().lstrip('www.')
                        email_domain = el.split('@')[1]
                        confidence = 'High' if email_domain in club_domain or club_domain in email_domain else 'Medium'

                        findings.append({
                            'email': el,
                            'email_type': email_type,
                            'source_url': url,
                            'source_type': f'Club Website ({page_type})',
                            'confidence': confidence,
                            'verification_status': 'Found',
                        })

                # Check contact pages
                if page_type == 'home':
                    for path in CONTACT_PATHS:
                        contact_url = urljoin(url, path)
                        if contact_url not in visited:
                            time.sleep(0.3)
                            visit(contact_url, 'contact')

            except Exception:
                pass

        # Start with homepage
        time.sleep(0.5)
        visit(website, 'home')

        if findings:
            # Get best email (prioritise recruitment, then football, then general)
            priorities = ['Recruitment', 'Football Department', 'First Team',
                         'Club Secretary', 'Manager/Head Coach', 'General Club']
            best = None
            for p in priorities:
                for f in findings:
                    if f['email_type'] == p:
                        best = f
                        break
                if best:
                    break
            if not best and findings:
                best = findings[0]

            # Update club with best email
            self.db.upsert({
                'club_name': club['club_name'],
                'website': website,
                'email': best['email'],
                'email_type': best['email_type'],
                'source_url': best['source_url'],
                'source_type': best['source_type'],
                'confidence': best['confidence'],
                'verification_status': best['verification_status'],
            })

        return findings

    def search_all_missing(self):
        """PASS 4-6: Search all clubs that still don't have emails."""
        missing = self.db.get_clubs_without_email()
        if not missing:
            print("   ✅ All clubs have emails!")
            return

        print(f"\n📧 Searching {len(missing)} club websites for emails...")
        found = 0

        for i, club in enumerate(missing):
            if (i + 1) % 20 == 0:
                print(f"   {i+1}/{len(missing)}... ({found} found)")

            findings = self.search_club_website(club)
            if findings:
                found += 1
            time.sleep(REQUEST_DELAY)

        print(f"\n   ✅ Emails found for {found}/{len(missing)} clubs")
        return found

    def search_remaining_manual(self):
        """PASS 8: Re-check clubs still missing emails."""
        missing = self.db.get_clubs_without_email()
        if not missing:
            return

        print(f"\n🔎 PASS 8: {len(missing)} clubs still need emails.")
        print("   These clubs have no publicly discoverable email.")
        print("   Consider:")
        print("   1. Searching club social media (Facebook, X/Twitter) for listed contacts")
        print("   2. Checking club PDFs (match programmes, sponsorship packs)")
        print("   3. Contacting the league secretary for club contact details")
        print("   4. Visiting the club in person")

        for club in missing[:10]:
            print(f"   - {club['club_name']} ({club.get('league', '?')}) — {club.get('website', 'No website')}")

        if len(missing) > 10:
            print(f"   ... and {len(missing) - 10} more")
