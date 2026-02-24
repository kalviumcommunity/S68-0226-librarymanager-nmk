# Goal (MVP)

Give public-library patrons a modern mobile experience to **discover books, check real-time availability, reserve copies, and track reservation/borrow status**, while giving staff a lightweight way to manage inventory and process reservations — all built with **Flutter (frontend)** and **Firebase (backend)**.

---

# Core MVP feature set (what we *must* ship)

1. **User authentication**

   * Email/password + optional phone OTP.
   * Patron profile (name, library card id optional).
2. **Catalog & discovery**

   * Browse categories / recent arrivals.
   * Full-text search (title, author, ISBN, tags).
   * Basic filters (available now, branch, genre).
3. **Book detail**

   * Cover image, metadata (title, author, publisher, ISBN), short summary, location/branch.
   * Live availability: total copies / available copies.
4. **Reservations**

   * Patron can reserve an available copy (hold).
   * Reservation has status: Pending / Ready for pickup / Checked out / Cancelled / Expired.
5. **My reservations & history**

   * View active reservations, pickup window, and past borrows.
6. **Push & in-app notifications**

   * Notify when reservation becomes Ready for pickup, due reminders, cancellations.
7. **Staff dashboard (web or in-app simplified)**

   * CRUD books & copies (add new copy, mark damaged/lost).
   * View & process reservations (mark ready for pickup, check out, check in).
8. **Basic analytics**

   * Counts: active reservations, most-requested titles (simple top-10).
9. **Offline-readiness (basic)**

   * Cache catalog data so users can browse recently fetched lists while offline.
10. **Secure access control**

    * Staff-only actions gated by role.

---

# User roles & main user stories

**Roles:** Patron, Staff (Librarian), Admin

Examples:

* As a Patron I can search for a book and see if copies are available now.
* As a Patron I can reserve a copy and be notified when it’s ready for pickup.
* As Staff I can mark a reserved copy “Ready for pickup” or “Checked out”.
* As Admin I can add/remove copies and view reservation analytics.

---

# High-level architecture & Firebase usage

* **Frontend:** Flutter (single codebase for Android/iOS + optional web for staff admin)
* **Auth:** Firebase Authentication (email / phone)
* **Database:** Cloud Firestore

  * Collections: `books`, `copies`, `reservations`, `users`, `branches`, `notifications`, `analytics`
* **Storage:** Firebase Storage for cover images
* **Server logic:** Firebase Cloud Functions

  * Enforce consistency (e.g., decrement available count on reservation confirmation)
  * Send push notifications (FCM) and email if needed
* **Messaging:** Firebase Cloud Messaging for push notifications
* **Hosting (optional):** Firebase Hosting for staff web dashboard or marketing site

---

# Suggested Firestore data model (concise)

* `books/{bookId}`

  * title, authors[], isbn, summary, genres[], coverUrl, createdAt
* `copies/{copyId}`

  * bookId, branchId, copyStatus (available, reserved, checked_out, lost), shelfCode
* `reservations/{reservationId}`

  * userId, copyId, bookId, status (pending, ready, checked_out, cancelled, expired), requestedAt, readyUntil
* `users/{userId}`

  * name, email, role (patron/staff), libraryCardId
* `branches/{branchId}`

  * name, address, hours
* `notifications/{notifId}` (optional or use Cloud Messaging logs)

(Use subcollections or join-like queries where appropriate; normalize copies separate from book metadata.)

---

# Security & rules (summary)

* Only authenticated users can create reservations.
* A user can only view their own reservations.
* Only users with `role: staff` can update `copies` and `reservations` statuses.
* Use Firestore rules + Cloud Functions to prevent race conditions (e.g., double-booking a single copy).

---

# UI / UX Flow (key screens)

1. Splash / Onboarding
2. Auth screen (login/signup)
3. Home: Search bar, categories, recommended
4. Search results list
5. Book detail (cover, meta, availability, reserve button)
6. Reservation flow: choose copy/branch → confirm → success
7. My reservations (status cards, cancel)
8. Staff dashboard: reservations queue + copy management
9. Settings / Profile

Keep screens simple, readable, and mobile-first.

---

# Minimum acceptance criteria (what "done" looks like)

* End-to-end: Patron can search → view book → reserve → receive push notification when staff marks Ready → view status in My reservations.
* Staff can mark a reserved copy Ready and mark Checked out on pickup.
* No data leaks across users (security rules enforced).
* App runs on Android and iOS emulator/device, basic styling applied.
* Critical flows covered by simple automated tests (auth + reservation flow).

---

# MVP timeline & sprint plan (example for a small team / 6 weeks)

**Assumption:** small team (1–2 devs, 1 designer/QA). Use 2-week sprints.

**Sprint 0 (prep, 1 week)** — Setup & design (can be squeezed into Sprint 1)

* Project scaffolding: repo, project conventions
* Firebase project, auth enabled
* Basic UI wireframes + design tokens (colors, fonts)
* Create sample seed data for books

**Sprint 1 (2 weeks)** — Core read flows + auth

* Implement Authentication (email)
* Build Catalog screens: browse, search, book detail
* Firestore `books` read rules
* Offline caching for catalog
  **Deliverable:** Search → View book with availability

**Sprint 2 (2 weeks)** — Reservations + staff flow

* Implement reservations (write to `reservations`)
* Implement `copies` and availability logic
* Simple Staff dashboard: view reservations, mark Ready/Checked out
* Cloud Function to update availability and trigger FCM notification on status change
  **Deliverable:** Full patron reservation + notification end-to-end

**Sprint 3 (2 weeks)** — Polish, testing & launch

* Push notifications (FCM) integrated to mobile
* My reservations & history screen
* Firestore security rules tightened & audited
* QA, user acceptance, deployment to TestFlight/Play Internal
  **Deliverable:** MVP release candidate and demo

If you’re solo, compress to 4–6 weeks focusing on Sprints 1+2 essentials.

---

# QA / testing

* Unit tests for data models and utility functions.
* Integration tests for reservation flow (simulate writes & Cloud Function triggers).
* Manual UAT: test staff acceptance flow, race conditions (two patrons reserving last copy).
* Security audit: validate Firestore rules with the emulator.

---

# Monitoring & metrics (basic)

Track:

* Daily active users (DAU)
* Reservation completion rate (reserve → pickup)
* Average time from reserve → ready
* Top 10 searched titles (to detect catalog gaps)

Use Firebase Analytics and simple Cloud Function logs.

---

# Risks & mitigations

* **Race condition double-reserve** → Use transactions / Cloud Functions to atomically check-and-update copy status.
* **Staff adoption resistance** → Keep staff UI minimal and optionally provide barcode/QR scan for fast processing.
* **Limited internet at branches** → Support offline caching & queueing staff actions to sync later.
* **Data quality (missing ISBN/metadata)** → Provide quick import via CSV or minimal manual entry in staff UI.

---

# Nice-to-have (post-MVP / roadmap)

* Barcode/QR scanning for check-in/out (faster staff ops).
* Reservation queue (if multiple patrons want same title).
* Inter-branch transfers & hold-slots.
* Public web catalog & self-service kiosks.
* Integration with national library APIs (if available) for richer metadata.
* Fines/renewals, loan durations, automated due-date emails.

---

# Dev habits & delivery suggestions

* Use Provider or Riverpod for state management (Riverpod recommended for testability).
* Keep data layer isolated (Repository pattern).
* Add end-to-end CI with Firebase emulators for rules/tests.
* Release early to a small set of pilot users (1 branch) to collect feedback.

---

# Sprint checklist (for each sprint)

* [ ] Acceptance criteria written & agreed
* [ ] UI mockups ready
* [ ] Firebase rules drafted
* [ ] Cloud Functions for critical operations
* [ ] End-to-end test executed
* [ ] Demo recorded (2–3 minute walkthrough)
* [ ] Release to testers

---

# Quick next steps for you (practical)

1. Decide team size (solo / 2–3 people) and pick sprint cadence.
2. Create Firebase project, enable Auth + Firestore + Storage + FCM.
3. Prepare 50–200 seed book records (CSV) for development.
4. Sketch 6 screens (Home, Search, Book, Reserve, My reservations, Staff dashboard).
5. Start Sprint 1: implement Auth + Catalog read flows.
