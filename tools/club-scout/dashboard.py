"""
Dashboard & Audit — Full coverage tracker with Step 7 parity
"""

import json
from datetime import date
from pathlib import Path
from collections import Counter

from config import STEPS, EXPECTED_CLUBS, EXPECTED_TOTAL, DATA_DIR
from database import ClubDatabase


class Dashboard:
    def __init__(self, db: ClubDatabase):
        self.db = db

    def print_dashboard(self):
        """Print full admin dashboard with step-by-step breakdown."""
        db = self.db
        db._recalc_stats()

        print(f"\n{'='*80}")
        print(f"  🏆 PLAYERPATH CLUB SCOUT — ADMIN DASHBOARD")
        print(f"  English Non-League Football Club Contact Database")
        print(f"  Steps 1–7  •  {date.today().isoformat()}")
        print(f"{'='*80}")

        # ── Overall stats ──
        total = db.stats['total']
        with_email = db.stats['with_email']
        verified = db.stats['verified']
        print(f"  Total clubs expected:  {EXPECTED_TOTAL}")
        print(f"  Clubs discovered:      {total}  ({self._pct(total, EXPECTED_TOTAL)}%)")
        print(f"  With public email:     {with_email}  ({self._pct(with_email, total)}%)")
        print(f"  Verified emails:       {verified}")
        print(f"  High confidence:       {db.stats['high_conf']}")
        print(f"  Medium confidence:     {db.stats['medium_conf']}")
        print(f"  Low confidence:        {db.stats['low_conf']}")
        print(f"{'='*80}")

        # ── Per-step table ──
        print(f"\n  {'Step':<6} {'Expected':<10} {'Found':<8} {'Websites':<10} {'Emails':<8} {'Verified':<10} {'Missing':<8} {'Coverage'}")
        print(f"  {'-'*6} {'-'*10} {'-'*8} {'-'*10} {'-'*8} {'-'*10} {'-'*8} {'-'*8}")

        for step in range(1, 8):
            expected = EXPECTED_CLUBS.get(step, 0)
            step_str = str(step)
            step_data = db.stats['by_step'].get(step_str, {'total': 0, 'with_email': 0})

            found = step_data['total']
            emails = step_data['with_email']
            websites = sum(1 for c in db.clubs
                          if c.get('step') == step_str and c.get('website'))
            missing = found - emails if found > emails else 0

            # Count verified for this step
            step_verified = sum(1 for c in db.clubs
                              if c.get('step') == step_str
                              and c.get('verification_status') in ('Verified', 'Confirmed'))

            cov = self._pct(found, expected) if expected else 0
            bar = '█' * (cov // 5) + '░' * (20 - cov // 5)

            print(f"  Step {step}  {expected:<10} {found:<8} {websites:<10} {emails:<8} {step_verified:<10} {missing:<8} {bar} {cov}%")

        print(f"\n  {'='*80}")

        # ── Missing reason breakdown ──
        missing_clubs = [c for c in db.clubs if not c.get('email')]
        if missing_clubs:
            reasons = Counter()
            for c in missing_clubs:
                reason = c.get('missing_reason', 'No reason recorded')
                reasons[reason] += 1

            print(f"\n  📋 MISSING EMAIL REASONS ({len(missing_clubs)} clubs):")
            for reason, count in reasons.most_common():
                print(f"     • {reason}: {count}")

        # ── Clubs needing manual review ──
        manual = [c for c in db.clubs if c.get('needs_manual_review') == 'TRUE']
        if manual:
            print(f"\n  ⚠ CLUBS NEEDING MANUAL REVIEW: {len(manual)}")
            for c in manual[:15]:
                print(f"     • {c['club_name']} (Step {c.get('step','?')}, {c.get('league','?')})")
            if len(manual) > 15:
                print(f"     ... and {len(manual)-15} more")

        print(f"\n{'='*80}")

    def generate_audit(self) -> dict:
        """Generate comprehensive audit report."""
        db = self.db
        db._recalc_stats()

        missing = [c for c in db.clubs if not c.get('email')]
        reasons = Counter(c.get('missing_reason', 'No reason recorded') for c in missing)
        manual = [c for c in db.clubs if c.get('needs_manual_review') == 'TRUE']

        report = {
            'report_date': date.today().isoformat(),
            'expected_total': EXPECTED_TOTAL,
            'discovered': db.stats['total'],
            'coverage_pct': self._pct(db.stats['total'], EXPECTED_TOTAL),
            'with_email': db.stats['with_email'],
            'email_coverage_pct': self._pct(db.stats['with_email'], db.stats['total']),
            'verified': db.stats['verified'],
            'high_confidence': db.stats['high_conf'],
            'medium_confidence': db.stats['medium_conf'],
            'low_confidence': db.stats['low_conf'],
            'needs_manual_review': len(manual),
            'missing_reasons': dict(reasons.most_common()),
            'sources_used': list(set(
                s.strip() for c in db.clubs
                for s in c.get('source_type', '').split(';') if s.strip()
            )),
            'by_step': {},
        }

        for step in range(1, 8):
            expected = EXPECTED_CLUBS.get(step, 0)
            step_str = str(step)
            step_clubs = [c for c in db.clubs if c.get('step') == step_str]
            step_emails = sum(1 for c in step_clubs if c.get('email'))
            step_websites = sum(1 for c in step_clubs if c.get('website'))
            step_verified = sum(1 for c in step_clubs
                               if c.get('verification_status') in ('Verified', 'Confirmed'))
            step_missing = len(step_clubs) - step_emails if len(step_clubs) > step_emails else 0

            report['by_step'][f'step_{step}'] = {
                'name': STEPS[step]['name'],
                'expected': expected,
                'discovered': len(step_clubs),
                'websites': step_websites,
                'emails': step_emails,
                'verified': step_verified,
                'missing': step_missing,
                'coverage_pct': self._pct(len(step_clubs), expected),
            }

        audit_path = DATA_DIR / "audit_report.json"
        with open(audit_path, 'w', encoding='utf-8') as f:
            json.dump(report, f, indent=2, ensure_ascii=False)

        print(f"\n  📋 Audit report saved: {audit_path}")
        return report

    def export_all(self):
        """Export in all formats."""
        # CSV (primary)
        print(f"\n  📁 CSV:  {self.db.path}")

        # JSON
        json_path = DATA_DIR / "clubs_database.json"
        self.db.export_json(json_path)
        print(f"  📁 JSON: {json_path}")

        # Summary
        self.db._recalc_stats()
        steps_with_missing = sum(
            1 for s in range(1, 8)
            if any(not c.get('email') for c in self.db.clubs if c.get('step') == str(s))
        )
        print(f"\n  📊 {self.db.stats['total']} clubs | "
              f"{self.db.stats['with_email']} emails | "
              f"{steps_with_missing} steps with missing data")

    def _pct(self, val: int, total: int) -> int:
        if total == 0:
            return 0
        return round(100 * val / total)
