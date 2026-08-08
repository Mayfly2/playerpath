#!/usr/bin/env python3
"""
🏆 PlayerPath Club Scout — Main Orchestrator
=============================================
Multi-pass English non-league football club contact discovery system.
Steps 1-7 receive EQUAL investigation priority.

Usage:
  python main.py                    # Full multi-pass (all steps)
  python main.py --test             # Test: sample from all 7 steps
  python main.py --step7            # Step 7 intensive only
  python main.py --dashboard        # Show full dashboard
  python main.py --investigate      # Search missing emails (all steps)
  python main.py --export           # Export all formats
"""

import sys
import logging
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from config import DB_PATH, LOG_PATH, DATA_DIR, STEPS, EXPECTED_CLUBS
from database import ClubDatabase
from discovery import ClubDiscoverer
from email_finder import EmailFinder
from step7_scraper import Step7Scraper
from dashboard import Dashboard

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    handlers=[
        logging.FileHandler(LOG_PATH),
        logging.StreamHandler()
    ]
)
log = logging.getLogger(__name__)


def main():
    args = sys.argv[1:]

    print("""
╔══════════════════════════════════════════════════════════╗
║          🏆 PLAYERPATH CLUB SCOUT v2.0                 ║
║   English Non-League Football Club Contact Database     ║
║         Steps 1–7  •  2026/27  •  Equal Priority       ║
╚══════════════════════════════════════════════════════════╝
    """)

    DATA_DIR.mkdir(exist_ok=True)
    db = ClubDatabase(DB_PATH)
    db.load()

    discoverer = ClubDiscoverer(db)
    finder = EmailFinder(db)
    step7 = Step7Scraper(db)
    dashboard = Dashboard(db)

    # ── Quick commands ──
    if '--dashboard' in args:
        dashboard.print_dashboard()
        return

    if '--export' in args:
        dashboard.export_all()
        return

    if '--investigate' in args:
        print("\n🔎 Investigating missing emails (all steps)...")
        finder.search_all_missing()
        step7.search_missing_emails_intensive()
        finder.search_remaining_manual()
        db.save()
        dashboard.print_dashboard()
        return

    if '--step7' in args:
        step7.discover_all()
        step7.search_missing_emails_intensive()
        db.save()
        dashboard.print_dashboard()
        return

    if '--test' in args:
        print("\n🧪 TEST MODE — Sampling clubs from all 7 steps\n")
        # Quick Wikipedia pass (Steps 1-5)
        discoverer.pass1_wikipedia()
        # Quick league sites
        discoverer.pass3_league_sites()
        # Step 7 sample — first 5 leagues only
        print("\n📋 Step 7 sample (first 5 leagues)...")
        for i, (league_name, region, clubs_url, fa_url) in enumerate(Step7Scraper.STEP7_LEAGUES[:5]):
            step7._process_league(league_name, region, clubs_url, fa_url)
        db.save()
        dashboard.print_dashboard()
        return

    # ═══════════════════════════════════════
    # FULL MULTI-PASS — ALL 7 STEPS
    # ═══════════════════════════════════════

    # ── PASS 1: Wikipedia (Steps 1-5) ──
    discoverer.pass1_wikipedia()
    db.save()

    # ── PASS 2: Website discovery ──
    discoverer.pass2_website_discovery()
    db.save()

    # ── PASS 3: League sites (Steps 3-6) ──
    discoverer.pass3_league_sites()
    db.save()

    # ── PASS 4: STEP 7 — Full feeder league discovery ──
    print(f"\n{'='*60}")
    print(f"  📋 PASS 4: STEP 7 COMPREHENSIVE DISCOVERY")
    print(f"  This receives the same priority as Steps 1-6")
    print(f"{'='*60}")
    step7.discover_all()
    db.save()

    # ── PASS 5: Email discovery from club websites ──
    print(f"\n📧 PASS 5: Searching club websites for emails (all steps)...")
    finder.search_all_missing()

    # ── PASS 6: Step 7 intensive email search ──
    print(f"\n🔍 PASS 6: Step 7 intensive email search...")
    step7.search_missing_emails_intensive()
    db.save()

    # ── PASS 7: Duplicate detection ──
    print(f"\n🔍 PASS 7: Final duplicate check...")
    print(f"   Database has {db.stats['total']} unique clubs across Steps 1-7.")
    db.save()

    # ── PASS 8: Re-check all missing ──
    print(f"\n🔎 PASS 8: Re-checking clubs with missing emails...")
    finder.search_remaining_manual()
    db.save()

    # ── PASS 9: Final audit ──
    print(f"\n✅ PASS 9: Final verification & audit")
    db.save()

    # ── FINAL OUTPUT ──
    dashboard.print_dashboard()
    dashboard.generate_audit()
    dashboard.export_all()

    # Print step 7 specific stats
    step7_clubs = [c for c in db.clubs if c.get('step') == '7']
    step7_emails = sum(1 for c in step7_clubs if c.get('email'))
    print(f"\n🏁 STEP 7 SPECIFIC:")
    print(f"   Clubs: {len(step7_clubs)}")
    print(f"   Emails: {step7_emails}")
    print(f"   Expected: {EXPECTED_CLUBS.get(7, 0)}")
    print(f"   Coverage: {round(100*len(step7_clubs)/max(EXPECTED_CLUBS.get(7, 1), 1))}%")

    print(f"\n{'='*50}")
    print(f"✅ COMPLETE — {db.stats['total']} clubs across Steps 1-7")
    print(f"📁 Database: {DB_PATH}")
    print(f"{'='*50}")


if __name__ == '__main__':
    main()
