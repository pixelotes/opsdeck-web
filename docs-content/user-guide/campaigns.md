# Campaigns

Manage email campaigns for announcements, policy communications, and awareness initiatives.

## Email campaigns

1. Navigate to **Communications → Campaigns**.
2. Click **Create Campaign**.
3. Select or create an **email template** (`EmailTemplate`).
4. Define the recipient list (users, groups, or custom lists).
5. Schedule or send immediately.

## Templates

Email templates use a customizable format with merge fields for personalization (name, email, role). Create templates in **Communications → Templates**.

## Scheduled communications

`ScheduledCommunication` records allow scheduling campaigns for future delivery. The APScheduler processes the queue and sends emails via the configured SMTP server. Delivery status is tracked per recipient.
