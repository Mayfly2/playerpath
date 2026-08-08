"""
Database module — CSV storage, dedup, verification tracking
"""

import csv
import os
import hashlib
import json
from datetime import datetime, date
from pathlib import Path
from difflib import SequenceMatcher

# Fields in order for CSV export
FIELDS = [
    'club_name', 'step', 'league', 'division', 'county', 'town',
    'website', 'email', 'email_type', 'contact_name', 'contact_role',
    'phone', 'source_url', 'source_type', 'confidence', 'verification_status',
    'date_found', 'last_verified', 'notes'
]


class ClubDatabase:
    def __init__(self, path: Path):
        self.path = path
        self.clubs: list[dict] = []
        self.stats = {
            'total': 0, 'with_email': 0, 'verified': 0,
            'high_conf': 0, 'medium_conf': 0, 'low_conf': 0,
            'by_step': {},
        }

    def load(self):
        """Load existing database from CSV."""
        if not self.path.exists():
            return
        with open(self.path, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            self.clubs = [row for row in reader]
        self._recalc_stats()

    def save(self):
        """Save database to CSV."""
        with open(self.path, 'w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=FIELDS)
            writer.writeheader()
            for club in self.clubs:
                # Ensure all fields exist
                row = {k: club.get(k, '') for k in FIELDS}
                writer.writerow(row)

    def upsert(self, club: dict):
        """Insert or update a club record. Deduplicates by name + website."""
        if not club.get('club_name'):
            return

        existing = self._find_existing(club)
        if existing:
            # Merge: keep existing if it has more data
            idx = self.clubs.index(existing)
            merged = self._merge(existing, club)
            self.clubs[idx] = merged
        else:
            self.clubs.append(self._normalise(club))
        self._recalc_stats()

    def upsert_batch(self, clubs: list[dict]):
        """Batch upsert with progress."""
        added = 0
        updated = 0
        for club in clubs:
            existing = self._find_existing(club)
            if existing:
                idx = self.clubs.index(existing)
                self.clubs[idx] = self._merge(existing, club)
                updated += 1
            else:
                self.clubs.append(self._normalise(club))
                added += 1
        self._recalc_stats()
        return added, updated

    def _find_existing(self, club: dict) -> dict | None:
        """Find an existing club by name similarity or website match."""
        name = (club.get('club_name') or '').lower().strip()
        website = (club.get('website') or '').lower().strip().rstrip('/')

        if not name:
            return None

        for existing in self.clubs:
            ex_name = (existing.get('club_name') or '').lower().strip()
            ex_website = (existing.get('website') or '').lower().strip().rstrip('/')

            # Exact name match
            if name == ex_name:
                return existing

            # Same website (strong signal)
            if website and ex_website and website == ex_website:
                return existing

            # Fuzzy name match (>85% similar)
            if len(name) > 6 and len(ex_name) > 6:
                ratio = SequenceMatcher(None, name, ex_name).ratio()
                if ratio > 0.85:
                    return existing

        return None

    def _merge(self, existing: dict, new: dict) -> dict:
        """Merge two records. Prefer the one with more data."""
        merged = existing.copy()
        for key in FIELDS:
            if key == 'club_name':
                # Keep longer name
                if len(new.get(key, '')) > len(existing.get(key, '')):
                    merged[key] = new[key]
            elif key in ('confidence', 'verification_status', 'last_verified', 'notes'):
                # Only update if new has better data
                if new.get(key) and (not existing.get(key) or new.get('confidence') == 'High'):
                    merged[key] = new[key]
            elif key == 'notes':
                # Append notes
                if new.get(key):
                    merged[key] = (existing.get(key, '') + ' | ' + new[key]).strip(' |')
            else:
                # Prefer non-empty values
                if new.get(key) and not existing.get(key):
                    merged[key] = new[key]

        # Increment source count
        sources = set(existing.get('source_type', '').split(';'))
        new_sources = set(new.get('source_type', '').split(';'))
        merged['source_type'] = ';'.join(sources | new_sources - {''})

        return merged

    def _normalise(self, club: dict) -> dict:
        """Normalise a club record."""
        row = {k: club.get(k, '') for k in FIELDS}
        row['club_name'] = (row['club_name'] or '').strip()
        if not row.get('date_found'):
            row['date_found'] = date.today().isoformat()
        row['last_verified'] = date.today().isoformat()
        return row

    def _recalc_stats(self):
        """Recalculate statistics."""
        self.stats = {
            'total': len(self.clubs),
            'with_email': sum(1 for c in self.clubs if c.get('email')),
            'verified': sum(1 for c in self.clubs if c.get('verification_status') == 'Confirmed'),
            'high_conf': sum(1 for c in self.clubs if c.get('confidence') == 'High'),
            'medium_conf': sum(1 for c in self.clubs if c.get('confidence') == 'Medium'),
            'low_conf': sum(1 for c in self.clubs if c.get('confidence') == 'Low'),
            'by_step': {},
        }
        for club in self.clubs:
            step = club.get('step', '?')
            if step not in self.stats['by_step']:
                self.stats['by_step'][step] = {'total': 0, 'with_email': 0}
            self.stats['by_step'][step]['total'] += 1
            if club.get('email'):
                self.stats['by_step'][step]['with_email'] += 1

    def get_clubs_without_email(self) -> list[dict]:
        """Get clubs that don't have an email yet."""
        return [c for c in self.clubs if not c.get('email')]

    def get_clubs_by_step(self, step: int) -> list[dict]:
        """Get clubs for a specific step."""
        step_str = str(step)
        return [c for c in self.clubs if c.get('step') == step_str]

    def export_json(self, path: Path):
        """Export to JSON."""
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(self.clubs, f, indent=2, ensure_ascii=False)

    def print_summary(self):
        """Print a summary of the database."""
        print(f"\n{'='*60}")
        print(f"📊 Club Database Summary")
        print(f"{'='*60}")
        print(f"Total clubs: {self.stats['total']}")
        print(f"With email:  {self.stats['with_email']} ({self._pct(self.stats['with_email'])}%)")
        print(f"Verified:    {self.stats['verified']}")
        print(f"High conf:   {self.stats['high_conf']}")
        print(f"Medium conf: {self.stats['medium_conf']}")
        print(f"Low conf:    {self.stats['low_conf']}")
        print(f"\nBy step:")
        for step in sorted(self.stats['by_step'].keys()):
            s = self.stats['by_step'][step]
            print(f"  Step {step}: {s['total']} clubs, {s['with_email']} with email ({self._pct(s['with_email'], s['total'])}%)")

    def _pct(self, val: int, total: int = None) -> int:
        if total is None:
            total = self.stats['total']
        return round(100 * val / max(total, 1))
