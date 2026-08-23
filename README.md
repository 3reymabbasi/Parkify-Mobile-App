# SmartParkify

A  parking management app built as my Final Year Project (BSCS) — designed to solve the everyday hassle of finding parking in busy city areas like Karachi, Islamabad where drivers often waste 15-30 minutes just searching for an empty spot.

## The problem

Traditional parking systems don't tell you in real time whether a spot is free, don't let you reserve one in advance, and give admins no easy way to monitor lots or handle complaints. SmartParkify fixes this with a fully digital, mobile-first approach.

## What it does

**For Drivers:**
- View real-time parking slot availability on an interactive map (OpenStreetMap)
- Book a slot in advance by selecting date and time
- Get a unique QR code for entry/exit verification
- Live GPS navigation to the parking lot 
- Report theft, damage, or wrong parking with photo evidence

**For Managers:**
- Add, update, or remove parking lots through a secure dashboard
- View and manage incoming reports (approve/reject with one tap)
- Real-time visibility into bookings and reports
- Basic analytics on occupancy and busy hours

## Tech stack

- **Frontend:** Flutter (Dart)
- **Backend:** Firebase (Authentication, Firestore, Cloud Messaging, Storage)
- **Maps & Navigation:** OpenStreetMap
- **Architecture:** MVVM pattern with role-based access control (RBAC)
- **Methodology:** Agile Scrum


