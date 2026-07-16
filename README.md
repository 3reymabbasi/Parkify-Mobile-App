# SmartParkify

A smart parking management app built as my Final Year Project (BSCS) — designed to solve the everyday hassle of finding parking in busy city areas like Karachi, Islamabad where drivers often waste 15-30 minutes just searching for an empty spot.

## The problem

Traditional parking systems don't tell you in real time whether a spot is free, don't let you reserve one in advance, and give admins no easy way to monitor lots or handle complaints. SmartParkify fixes this with a fully digital, mobile-first approach.

## What it does

**For drivers:**
- View real-time parking slot availability on an interactive map (OpenStreetMap)
- Book a slot in advance by selecting date and time
- Get a unique QR code for entry/exit verification
- Live GPS navigation to the parking lot with automatic rerouting
- Report theft, damage, or wrong parking with photo evidence
- Works offline — bookings and reports are queued locally and synced automatically once internet is back

**For admins:**
- Add, update, or remove parking lots through a secure dashboard
- View and manage incoming reports (approve/reject with one tap)
- Real-time visibility into bookings and reports
- Basic analytics on occupancy and busy hours

## Tech stack

- **Frontend:** Flutter (Dart)
- **Backend:** Firebase (Authentication, Firestore, Cloud Messaging, Storage)
- **Maps & Navigation:** OpenStreetMap
- **Architecture:** MVC pattern with role-based access control (RBAC)
- **Methodology:** Agile Scrum

## Key engineering challenges solved

- **Race conditions on booking:** Solved using Firebase atomic transactions, so two users can never book the same slot at the same time.
- **Real-time sync:** Slot availability updates across all devices within seconds using Firestore listeners.
- **Instant theft alerts:** Push notifications are triggered immediately to the admin when a theft report is submitted.


