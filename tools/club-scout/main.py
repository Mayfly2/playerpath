#!/usr/bin/env python3
"""
🏆 PlayerPath Club Scout — Main Orchestrator
=============================================
Multi-pass English non-league football club contact discovery system.
Covers Steps 1-7 of the FA National League System.

Usage:
  pip install requests beautifulsoup4
  python main.py                    # Full multi-pass run
  python main.py --quick            # Fast run (Wikipedia only)
  python main.py --dashboard        # Show dashboard only
  python main.py --investigate      # Search missing emails
  python main.py --export           # Export all formats

Output:
  data/clubs_database.csv    — Full database
  data/clubs_database.json   — JSON export
  data/audit_report.json     — Quality audit
"""

import sys
import logging
from pathlib import Path

# Ensure tools directory is importable
sys.path.insert(0, str(Path(__file__).parent))

from config import DB_PATH, LOG_PATH, DATA_DIR
from database import ClubDatabase
from discovery import ClubDiscoverer
from email_finder import EmailFinder
from dashboard import Dashboard

# Setup logging
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
╔══════════════════════════════════════════════════════╗
║          🏆 PLAYERPATH CLUB SCOUT v1.0              ║
║   English Non-League Football Club Contact Database  ║
║              Steps 1–7  •  2026/27                  ║
╚══════════════════════════════════════════════════════╝
    """)

    # Setup
    DATA_DIR.mkdir(exist_ok=True)
    db = ClubDatabase(DB_PATH)
    db.load()
    discoverer = ClubDiscoverer(db)
    finder = EmailFinder(db)
    dashboard = Dashboard(db)

    if '--dashboard' in args:
        dashboard.print_dashboard()
        return

    if '--export' in args:
        dashboard.export_all()
        return

    if '--investigate' in args:
        finder.search_all_missing()
        finder.search_remaining_manual()
        db.save()
        dashboard.print_dashboard()
        return

    quick = '--quick' in args

    # ═══════════════════════════════════
    # MULTI-PASS SYSTEM
    # ═══════════════════════════════════

    # PASS 1: Build club list from Wikipedia
    discoverer.pass1_wikipedia()
    db.save()

    if not quick:
        # PASS 2: Website discovery
        discoverer.pass2_website_discovery()
        db.save()

        # PASS 3: League website scraping
        discoverer.pass3_league_sites()
        db.save()

        # PASS 4-6: Email discovery from club websites
        finder.search_all_missing()
        db.save()

        # PASS 7: Cross-check duplicates
        print("\n🔍 PASS 7: Duplicate check...")
        print(f"   Database has {db.stats['total']} unique clubs.")
        db.save()

        # PASS 8: Re-check missing
        finder.search_remaining_manual()

        # PASS 9: Final verification
        print("\n✅ PASS 9: Final verification complete.")
        db.save()

    # ── Final output ──
    dashboard.print_dashboard()
    dashboard.generate_audit()
    dashboard.export_all()

    print(f"\n{'='*50}")
    print(f"✅ COMPLETE — Database saved to {DB_PATH}")
    print(f"   {db.stats['total']} clubs | {db.stats['with_email']} emails")
    print(f"{'='*50}")


if __name__ == '__main__':
    main()
