"""
Dashboard & Audit — Coverage tracker, quality reports, export
"""

import json
from datetime import date
from pathlib import Path

from config import STEPS, EXPECTED_CLUBS, EXPECTED_TOTAL, DATA_DIR
from database import ClubDatabase


class Dashboard:
    def __init__(self, db: ClubDatabase):
        self.db = db

    def print_dashboard(self):
        """Print admin dashboard."""
        db = self.db
        db._recalc_stats()

        print(f"\n{'='*70}")
        print(f"  🏆 PLAYERPATH CLUB SCOUT — ADMIN DASHBOARD")
        print(f"{'='*70}")
        print(f"  Report date: {date.today().isoformat()}")
        print(f"{'='*70}")
        print(f"  Total clubs expected: {EXPECTED_TOTAL}")
        print(f"  Clubs discovered:     {db.stats['total']}")
        cover = round(100 * db.stats['total'] / max(EXPECTED_TOTAL, 1), 1)
        print(f"  Coverage:             {cover}%")
        print(f"  With verified email:  {db.stats['with_email']}")
        email_pct = round(100 * db.stats['with_email'] / max(db.stats['total'], 1), 1)
        print(f"  Email coverage:       {email_pct}%")
        print(f"  High confidence:      {db.stats['high_conf']}")
        print(f"  Medium confidence:    {db.stats['medium_conf']}")
        print(f"  Low confidence:       {db.stats['low_conf']}")
        print(f"{'='*70}")
        print(f"\n  📊 BY STEP:")

        for step in range(1, 8):
            expected = EXPECTED_CLUBS.get(step, 0)
            step_data = db.stats['by_step'].get(str(step), {'total': 0, 'with_email': 0})
            actual = step_data['total']
            with_email = step_data['with_email']
            bar = '█' * min(int(30 * actual / max(expected, 1)), 30)
            print(f"  Step {step}: {bar} {actual}/{expected} clubs  ({with_email} emails)")

        print(f"\n{'='*70}")

    def generate_audit(self) -> dict:
        """Generate a full audit report."""
        db = self.db
        db._recalc_stats()

        missing = db.get_clubs_without_email()

        report = {
            'report_date': date.today().isoformat(),
            'expected_total_clubs': EXPECTED_TOTAL,
            'discovered_clubs': db.stats['total'],
            'coverage_pct': round(100 * db.stats['total'] / max(EXPECTED_TOTAL, 1), 1),
            'clubs_with_email': db.stats['with_email'],
            'email_coverage_pct': round(100 * db.stats['with_email'] / max(db.stats['total'], 1), 1),
            'verified_count': db.stats['verified'],
            'high_confidence': db.stats['high_conf'],
            'medium_confidence': db.stats['medium_conf'],
            'low_confidence': db.stats['low_conf'],
            'clubs_needing_investigation': len(missing),
            'by_step': {},
            'sources_used': list(set(
                s.strip() for c in db.clubs
                for s in c.get('source_type', '').split(';') if s.strip()
            )),
        }

        for step in range(1, 8):
            expected = EXPECTED_CLUBS.get(step, 0)
            step_str = str(step)
            step_data = db.stats['by_step'].get(step_str, {'total': 0, 'with_email': 0})
            report['by_step'][f'step_{step}'] = {
                'name': STEPS[step]['name'],
                'expected': expected,
                'discovered': step_data['total'],
                'with_email': step_data['with_email'],
                'pct_discovered': round(100 * step_data['total'] / max(expected, 1), 1),
            }

        # Save audit
        audit_path = DATA_DIR / "audit_report.json"
        with open(audit_path, 'w', encoding='utf-8') as f:
            json.dump(report, f, indent=2, ensure_ascii=False)

        print(f"\n📋 Audit report saved: {audit_path}")
        return report

    def export_all(self):
        """Export database in all formats."""
        # CSV is the primary format (already saved)
        print(f"\n📁 Database: {self.db.path}")

        # Export JSON
        json_path = DATA_DIR / "clubs_database.json"
        self.db.export_json(json_path)
        print(f"📁 JSON:     {json_path}")

        # Summary
        print(f"\n📊 Stats:")
        print(f"   Clubs: {self.db.stats['total']}")
        print(f"   With email: {self.db.stats['with_email']}")
        print(f"   Missing: {len(self.db.get_clubs_without_email())}")
