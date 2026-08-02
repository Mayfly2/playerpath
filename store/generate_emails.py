#!/usr/bin/env python3
"""
Generate personalised outreach emails from a CSV of club names + emails.

Usage:
  1. Create clubs.csv with columns: name, email
  2. Run: python generate_emails.py
  3. Import the output CSV into SendGrid/Mailchimp/Brevo

Format of clubs.csv:
  name,email
  "Stockport County","info@stockportcounty.com"
  "FC Halifax Town","contact@fchalifax.com"
"""

import csv
import sys

TEMPLATE = """Subject: A free recruitment platform for grassroots clubs — PlayerPath

Hi {name},

I'm reaching out because I've built PlayerPath — a free recruitment platform built for non-league and grassroots football clubs.

Finding good players at Steps 3-7 shouldn't cost a fortune. PlayerPath lets you:

• Search player profiles by position, age, step, and location — free
• See full football CVs with stats, videos, and match history
• Post open trials and manage applications
• Use AI match scoring to find the right fit

We're launching now with players across the North West. It's completely free for clubs.

Would you be open to a 5-minute look? https://playerpath.app

Best,
James
Founder, PlayerPath
"""


def main():
    try:
        with open('clubs.csv', 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            clubs = list(reader)
    except FileNotFoundError:
        print("Error: clubs.csv not found.")
        print("Create a file with columns: name, email")
        sys.exit(1)

    with open('outreach_emails.csv', 'w', newline='', encoding='utf-8') as out:
        writer = csv.writer(out)
        writer.writerow(['email', 'name', 'subject', 'body'])

        for club in clubs:
            name = club.get('name', '').strip()
            email = club.get('email', '').strip()
            if not name:
                continue
            # If no email found, include anyway for Hunter.io processing
            if not email:
                website = club.get('website', '').strip()
                # Extract domain from website for reference
                domain = ''
                if website:
                    from urllib.parse import urlparse
                    parsed = urlparse(website)
                    domain = parsed.netloc
                email = f'MISSING-{domain}' if domain else 'MISSING'

            body = TEMPLATE.replace('{name}', name)
            subject = f"A free recruitment platform for grassroots clubs — PlayerPath"
            writer.writerow([email, name, subject, body.strip()])

    print(f"✅ Generated {len(clubs)} emails → outreach_emails.csv")
    print("Import this file into SendGrid, Mailchimp, or Brevo to send.")


if __name__ == '__main__':
    main()
