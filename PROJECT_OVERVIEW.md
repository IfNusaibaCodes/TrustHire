# Trust Hire — Project Overview

> A Flutter mobile app that helps job seekers (primarily students) find **trusted** jobs, detect scam job postings, plan their day, track career growth, and check on burnout — backed by Supabase and Firebase Cloud Messaging.

_Last updated: 2026-06-26_

---

## 1. What the App Is

**Trust Hire** is a cross-platform (Android / iOS / web / Windows) Flutter application focused on safe job hunting. Beyond a normal job feed, its differentiator is a built-in **scam detector** that analyzes a pasted job offer and scores how risky it looks. It also layers on productivity and wellbeing tooling (planner, growth tracker, burnout check) plus an admin console for managing jobs, notifications, and user feedback.

**Tagline (from the landing page):** _"Find trusted jobs and build your career with confidence."_

### Core feature pillars
| Pillar | What it does |
|---|---|
| **Job Feed** | Browse all jobs, trending jobs, saved jobs, applied jobs, full job details with apply link |
| **Scam Detection** | Paste a job post → heuristic analyzer returns a 0–100 trust score, risk level, red flags, and positive signals |
| **Planner** | Daily to-do tasks with priorities, completion tracking, streaks, and a motivational quote |
| **Growth** | Dashboard of career stats: applications this week, skills/experience counts, weekly activity, streak |
| **Burnout Check** | Questionnaire that records wellbeing answers over time |
| **Profile** | First/last name, university, study year, skills, experiences, stats |
| **Notifications** | Targeted in-app + push notifications (by role / university / study year) with read tracking |
| **Admin Console** | Create/edit/delete jobs, mark trending, broadcast notifications, read user feedback |

---

## 2. Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter (Dart SDK `^3.11.0`) |
| **Backend / DB / Auth** | [Supabase](https://supabase.com) (`supabase_flutter ^2.12.4`) — Postgres + Auth + Realtime |
| **Push notifications** | Firebase Cloud Messaging (`firebase_messaging`) + `flutter_local_notifications` |
| **State management** | GetX (`get ^4.6.5`) + `get_storage` |
| **Deep linking** | `app_links` (handles auth callbacks / password recovery) |
| **HTTP / images** | `http`, `cached_network_image` |
| **UI / fonts** | `google_fonts`, Poppins (bundled), `iconsax`, `smooth_page_indicator` |
| **Utilities** | `intl`, `logger`, `url_launcher` |
| **Tooling** | `flutter_lints`, `flutter_launcher_icons`, `image` |

**Backend services in use:**
- **Supabase project:** `pgqagkfcbeifyibyyyce.supabase.co` (URL + anon key initialized in `main.dart`)
- **Firebase:** configured via `firebase_options.dart` + `android/app/google-services.json` (used only for FCM push)

---

## 3. Architecture

The app follows a **layered, feature-first architecture** loosely resembling MVC with a service/repository layer. There is no single rigid pattern — instead each feature has its own page(s), a database/service class for data access, and a model.

```
UI (Pages / Widgets)
      │  reads/writes via
      ▼
Controllers (GetX)  ──or──  Database/Service classes (static or instance)
      │
      ▼
Supabase client  ←→  Postgres tables  /  Firebase Cloud Messaging
```

### Layer responsibilities
- **Models** (`lib/Model/`) — plain Dart data classes with `fromMap` / `toMap` (e.g. `JobModel`, `NotificationModel`, `ProfileModel`, `BurnoutRecord`, `TaskModel`).
- **Services** (`lib/Authentication/Services/`) — cross-cutting concerns: auth, push, deep links, auth gating.
- **Controllers** (`lib/Authentication/Controllers/`) — GetX reactive controllers holding observable state (`PlannerController`, `NotificationController`, `OnboardingController`).
- **Database classes** (`*_database.dart`, `*_db.dart`) — feature-scoped Supabase data access (e.g. `JobsDatabaseService`, `ProfileDatabase`, `GrowthDatabase`, `BurnoutRepository`, `NotificationService`). Some are static (`JobsDatabaseService`, `GrowthDatabase`), some instance-based (`ProfileDatabase`, `PlannerDatabase`).
- **Pages** (`lib/Pages/`) — screens, grouped by feature folder.
- **Admin** (`lib/admin/`) — admin-only screens + `AdminService`.
- **Utilities** (`lib/Utilities/`) — theme, colors, constants, reusable widgets, validation, responsive sizing.
- **Common** (`lib/Common/`) — shared login/signup widgets and spacing styles.

> ⚠️ **Note:** The architecture is pragmatic rather than strict. Not every feature uses a GetX controller — many pages call the database classes directly with `FutureBuilder`/`setState`. State management is a mix of **GetX reactive (`.obs`)** for planner/notifications and **vanilla `StatefulWidget`** elsewhere.

---

## 4. Directory Structure

```
lib/
├── main.dart                       # Entry point: Supabase + Firebase + Push + DeepLink init
├── firebase_options.dart           # FlutterFire generated config
│
├── Authentication/
│   ├── Controllers/
│   │   ├── notification_controller.dart   # GetX: notifications + realtime + unread count
│   │   ├── onboarding_controller.dart     # GetX: onboarding page state
│   │   └── planner_controller.dart        # GetX: tasks, streak, filter, quote
│   └── Services/
│       ├── auth_gate.dart                 # StreamBuilder on auth state → route
│       ├── auth_service.dart              # Sign in/up/out, current user getters
│       ├── deep_link_service.dart         # app_links + auth events → routing + token reg
│       └── push_service.dart              # FCM init, local notifs, device token mgmt
│
├── Model/                          # Data models (job, notification, profile, planner, burnout, feedback, guide)
│
├── Navigation/
│   └── bottom_navigator.dart       # 4-tab IndexedStack shell (Jobs/Detect/Planner/Growth)
│
├── Pages/
│   ├── splash_page.dart            # Animated splash → AuthGate
│   ├── landing_page.dart           # Create Account / Log In
│   ├── onboarding_page.dart        # 3-image intro carousel
│   ├── Login/  SignUp/             # Auth screens
│   ├── forget_password_page.dart  reset_password_page.dart
│   ├── Job Feed/                   # all_jobs, job_feed_page, job_details, item list,
│   │   ├── Saved Jobs/             #   saved + applied subfolders, each with its own DB class
│   │   └── Applied Jobs/
│   ├── scam_detection/             # scam_detection_page, scam_analyzer (logic), red_flags_page
│   ├── Planner/                    # planner_page + planner_database
│   ├── Growth/                     # growth_page + growth_database
│   ├── Burnout/                    # burnout_check_page + burnout_db
│   ├── Guide/                      # work_guide_page + work_guide_db (remote work guide)
│   ├── Notifications/              # notification_page + notification_database (service)
│   └── Drawer/                     # about, contact, privacy, terms, feedback & support
│
├── admin/                          # Admin-only: job mgmt, create/edit job, trending,
│                                   #   send notification, feedback inbox, AdminService
├── profile/                        # profile_page + profile_database
│
├── Utilities/
│   ├── Constants/                  # colors, sizes, image_strings, text_strings, responsive
│   ├── Customs/
│   │   ├── theme.dart  Themes/     # Centralized Material theme (appbar, buttons, text, etc.)
│   │   └── Reuseable_Widgets/      # ~25 shared widgets (cards, chips, buttons, app bar, etc.)
│   └── Validation/validation.dart
│
└── Common/                         # Login/Signup shared widgets, spacing styles
```

---

## 5. Startup & Navigation Flow

### App boot (`main.dart`)
1. `WidgetsFlutterBinding.ensureInitialized()`
2. **Supabase.initialize(...)** — auth flow type `implicit`, with the project URL + anon key.
3. Lazily register `NotificationController` with GetX (`fenix: true` so it survives disposal).
4. `runApp(MyApp)` — a `GetMaterialApp` with the custom theme, `home: SplashPage`.
5. **Post-frame callback** (after first frame, non-blocking):
   - Initialize **Firebase** + **PushService** (FCM). Wrapped in try/catch so push failures don't crash the app.
   - Wire `PushService.onNotificationTap` → navigate to `NotificationPage`.
   - Initialize **DeepLinkService**.

### Routing sequence
```
SplashPage (2s animation)
   └─> AuthGate (StreamBuilder on Supabase auth state)
          ├─ session != null ──> BottomNavBar  (main app shell)
          └─ session == null ──> OnBoardingPage ──> Landing ──> Login / SignUp
```

### Main shell (`bottom_navigator.dart`)
- `IndexedStack` of 4 pages keeps state alive across tab switches:
  1. **Jobs** (`JobFeedPage`)
  2. **Detect** (`ScamDetectorPage`)
  3. **Planner** (`PlannerPage`)
  4. **Growth** (`GrowthPage`) — uses a `GlobalKey` so switching to it triggers `reload()`.

### Deep links & auth events (`deep_link_service.dart`)
- Listens to `app_links` URI stream for auth callbacks (`code`, `token_hash`, `access_token`, `error_code`).
- Subscribes to Supabase `onAuthStateChange`:
  - **signedIn / initialSession** → register FCM device token for the user.
  - **signedOut** → unregister token.
  - **passwordRecovery** → route to `ResetPasswordPage`.
  - **signedIn from a deep link** → route to `BottomNavBar`.

---

## 6. Working Mechanisms (Feature by Feature)

### 6.1 Authentication (`auth_service.dart`, `auth_gate.dart`)
- Email/password sign-up stores `first_name`, `last_name`, `phone` in Supabase user metadata; email confirmation redirects to a custom scheme `com.example.trust_hire_app://login-callback/`.
- `AuthGate` reactively gates the whole app on the auth session stream.
- Convenience getters pull current user id/email/name/phone from the live session.

### 6.2 Job Feed (`Pages/Job Feed/`, `JobsDatabaseService`, `JobModel`)
- `JobsDatabaseService` (static) reads/writes the `jobs` table: `fetchData`, `fetchTrendingJobs` (`is_trending = true`), `createJob`, `updateJob`, `deleteJob`, `setTrending`.
- `JobModel.fromMap` is notably defensive — it handles **two different shapes** of incoming data: nested objects (`company`, `types[]`, `cities[]`) *and* flattened slash-keyed columns (`company/name`, `types/0/name`, `cities/0/country/name`). This suggests jobs were imported from an external dataset/API export.
- **Saved Jobs** and **Applied Jobs** are separate subfolders, each with its own database class and page, persisting to `saved_jobs` / `applied_jobs` tables keyed by `user_id` + `job_id`.

### 6.3 Scam Detection (`scam_analyzer.dart`) — the flagship feature
- **Pure, offline, rule-based heuristic** — no ML/API call. `ScamAnalyzer.analyze(text)` returns a `ScamResult(score, riskLevel, issues, positives)`.
- Starts at **score = 100** and deducts penalties for red flags:
  - Upfront payment / fees (−35), untraceable payment like crypto/gift cards (−30), requests for sensitive data (−30), unrealistic income promises (−20), "selected without interview" (−20), urgency pressure (−15), too-good salary (−15), free email domains (−12), unofficial messaging channels like WhatsApp/Telegram (−12), excessive caps (−8), spammy punctuation (−8).
- Adds **positive signals** (company website, proper job description, real application process, registered company, physical address).
- Guards: rejects empty input, and text that doesn't look like a job post (< 8 words or no job-related keywords) returns "Not Enough Info".
- Final **risk bands:** ≥75 Low Risk, ≥45 Medium Risk, else High Risk. Results shown via `scam_result_card.dart`; `red_flags_page.dart` likely educates on common red flags.

### 6.4 Planner (`PlannerController`, `PlannerDatabase`, `TaskModel`)
- GetX reactive controller with `tasks`, `isLoading`, `streakDays`, `filter` observables.
- Tasks are **per-user, per-day** (`todayDate = yyyy-MM-dd`). Filters: All / Pending / Done.
- **Optimistic UI**: toggling/adding/deleting updates the in-memory list immediately, then persists; on failure it rolls back and shows a snackbar.
- **Streak logic:** the first time a task is completed today, `recordActivityAndGetStreak` updates the `planner_streaks` table and returns the new streak.
- Shows a daily rotating motivational quote (`DateTime.now().day % quotes.length`).

### 6.5 Growth (`GrowthDatabase`)
- Static aggregator that reads across several tables to build a dashboard:
  - `loadStats` (`profile_stats`), `loadStreak` (`planner_streaks`), `loadSkillCount` (`skills`), `loadExperienceCount` (`experiences`), `loadProfile` (`profiles`).
  - `loadRecentApplied` — last 3 applied jobs joined back to `jobs`.
  - `loadAppliedThisWeek` / `loadWeeklyActivity` — counts applications since Monday, bucketed into a 7-day array for a weekly chart.

### 6.6 Burnout (`BurnoutRepository`, `BurnoutRecord`)
- Questionnaire answers saved as rows in `burnout_checks` (one row per question, with `user_id`, `question_number`, `question_text`, `answer`).
- `fetchHistory`, `fetchByDate` for reviewing past checks.

### 6.7 Profile (`ProfileDatabase`)
- Lazily **self-heals**: if no `profiles` row exists for the user, it creates one from auth metadata. Same pattern for `profile_stats`.
- Manages `skills` and `experiences` (add/delete/load), and `updateProfile` (stamps `updated_at`).

### 6.8 Notifications (`NotificationController`, `NotificationService`, `NotificationModel`)
- **Targeted broadcast model:** a single `notifications` table holds messages with optional `target_role` / `target_university` / `target_study_year`. Read state is tracked **per user** in a separate `notification_reads` table (so one notification can be read independently by many users).
- `fetchNotifications` fetches all notifications + the user's reads in parallel (`Future.wait`), marks read state, and filters client-side via `NotificationModel.matchesAudience(...)` against the user's role/university/study year.
- **Realtime:** `NotificationController` subscribes to Postgres `INSERT` events on `notifications` and reloads automatically; exposes a reactive `unreadCount` (uses a `_tick` observable to force GetX rebuilds on in-place mutations).
- **Push:** `PushService` initializes FCM, creates a high-importance Android channel, shows foreground messages via local notifications, routes taps to the notification page, and upserts/deletes the FCM token in `device_tokens` on login/logout.

### 6.9 Admin (`lib/admin/`, `AdminService`)
- `AdminService.isAdmin()` checks `profiles.is_admin` for the current user.
- The app drawer conditionally renders an **ADMIN** section (Job Management, Feedback Inbox) only when `isAdmin` is true.
- Admin screens: create/edit/delete jobs, manage trending, send broadcast notifications (`send_notification_form.dart` → `NotificationService.createBroadcast`), and read user feedback (`feedback_inbox_page.dart`).

### 6.10 Drawer & Static Pages
- About Us, Contact Us, Privacy Policy, Terms & Conditions, Feedback & Support (which writes to a feedback table read by the admin inbox).

---

## 7. Data Model (Supabase Tables — inferred from code)

| Table | Purpose | Key columns |
|---|---|---|
| `profiles` | User profile | `id` (= auth uid), `first_name`, `last_name`, `email`, `phone`, `university`, `study_year`, `is_admin`, `updated_at` |
| `profile_stats` | Career stat counters | `user_id`, … |
| `skills` | User skills | `id`, `user_id`, `name`, `created_at` |
| `experiences` | Work experience | `id`, `user_id`, `title`, `company`, `start_date`, `end_date`, `is_current` |
| `jobs` | Job postings | `id`, `title`, `company/*`, `types`, `cities`, `has_remote`, `published`, `application_url`, `is_trending`, … |
| `saved_jobs` | Bookmarked jobs | `user_id`, `job_id` |
| `applied_jobs` | Applications | `user_id`, `job_id`, `created_at` |
| `planner_tasks` | Daily tasks | `user_id`, `title`, `priority`, `is_done`, date |
| `planner_streaks` | Streak counter | `user_id`, `streak_days` |
| `burnout_checks` | Wellbeing answers | `user_id`, `question_number`, `question_text`, `answer`, `created_at` |
| `notifications` | Broadcasts | `id`, `type`, `title`, `body`, `sent_by`, `target_role/university/study_year`, `created_at` |
| `notification_reads` | Per-user read state | `user_id`, `notification_id` |
| `device_tokens` | FCM tokens | `token`, `user_id`, `platform`, `updated_at` |
| `feedback` | User feedback | (read by admin inbox) |

> Table/column names are inferred from the Dart data-access code; the actual Supabase schema (RLS policies, types, constraints) lives in the Supabase project, not in this repo.

---

## 8. Theming & UI System

- **Centralized theme** in `Utilities/Customs/theme.dart` composed from per-component theme files (`appbar_theme`, `elevated_button_theme`, `outlined_button_theme`, `text_field_theme`, `text_theme`, `checkbox_theme`).
- **Brand palette** (`TColors`): primary blue `#3B5BDB`, navy `#1A1F36`, light backgrounds `#F5F6FA`, plus success/error/amber semantic colors.
- **Typography:** Poppins font family bundled with full weight range.
- **Reusable widget library** (~25 components in `Reuseable_Widgets/`): app bar, cards (app/section/stat/compact job/notification/scam result), chips (filter/selectable/job info), buttons, text fields, empty states, badges, logos, gradient banners — enforcing a consistent design language.
- **Responsive sizing** via `Utilities/Constants/responsive.dart` and `size.dart` (`.sp` extensions).

---

## 9. Current State

### What's built and working
- ✅ Full auth flow (sign up / login / forgot + reset password / email confirmation via deep link)
- ✅ Onboarding carousel → landing → auth gating
- ✅ 4-tab main shell with persistent state
- ✅ Job feed with trending, saved, applied, and detail screens
- ✅ Offline rule-based scam detector with scoring & red-flag education
- ✅ Planner with streaks, filters, optimistic updates
- ✅ Growth dashboard with weekly activity aggregation
- ✅ Burnout questionnaire with history
- ✅ Profile with skills/experiences
- ✅ Targeted notifications (in-app realtime + FCM push) with per-user read tracking
- ✅ Admin console (jobs, trending, broadcasts, feedback inbox) gated by `is_admin`
- ✅ Custom theme, reusable widget library, launcher icons configured

### Git state
- Branch: `nusaiba` (main branch: `main`). Working tree clean at session start.
- Recent commits show finalizing auth flow, navigation, planner, job feed, and notification work.

### Observations / potential issues to be aware of
1. **Hardcoded secrets:** Supabase URL + anon key are inline in `main.dart`. The anon key is public-by-design, but consider moving to env/config for cleanliness.
2. **Bug in `BurnoutRepository.deleteRecord`** ([burnout_db.dart:75-81](lib/Pages/Burnout/burnout_db.dart#L75-L81)): it filters `.eq('id', uid)` — comparing the row `id` to the **user id** instead of the passed `id` parameter. This will not delete the intended record.
3. **`saveAnswers` calls `_getRequiredUid()` inside the loop** unnecessarily ([burnout_db.dart:25-28](lib/Pages/Burnout/burnout_db.dart#L25-L28)) — minor inefficiency.
4. **Mixed state management:** GetX for some features, raw `setState`/`FutureBuilder` for others — intentional but worth standardizing if the team grows.
5. **Duplicated double-extension asset names** (e.g. `balance.png.png`) — cosmetic but odd.
6. **No automated tests** beyond the default `RunnerTests.swift`; `flutter_test` is present but no test files in `test/`.
7. **Security depends on Supabase RLS** — since the client holds the anon key and queries tables directly (e.g. filtering notifications client-side), row-level security policies on the Supabase side are critical and must be verified.

---

## 10. How to Run

```bash
# Install dependencies
flutter pub get

# Generate the launcher icon (optional, already configured)
dart run flutter_launcher_icons

# Run on a connected device / emulator
flutter run

# Build a release APK
flutter build apk --release
```

**Requirements:** Flutter SDK with Dart `^3.11.0`, a configured Android/iOS toolchain, and network access to the Supabase + Firebase backends. The `google-services.json` (Android) and Firebase options are already committed.

---

## 11. Quick Reference — Key Files

| Concern | File |
|---|---|
| App entry / init | [lib/main.dart](lib/main.dart) |
| Auth gating | [lib/Authentication/Services/auth_gate.dart](lib/Authentication/Services/auth_gate.dart) |
| Auth operations | [lib/Authentication/Services/auth_service.dart](lib/Authentication/Services/auth_service.dart) |
| Push notifications | [lib/Authentication/Services/push_service.dart](lib/Authentication/Services/push_service.dart) |
| Deep links / auth routing | [lib/Authentication/Services/deep_link_service.dart](lib/Authentication/Services/deep_link_service.dart) |
| Main navigation shell | [lib/Navigation/bottom_navigator.dart](lib/Navigation/bottom_navigator.dart) |
| Scam detection logic | [lib/Pages/scam_detection/scam_analyzer.dart](lib/Pages/scam_detection/scam_analyzer.dart) |
| Job data access | [lib/Pages/Job Feed/jobs_database.dart](lib/Pages/Job%20Feed/jobs_database.dart) |
| Planner state | [lib/Authentication/Controllers/planner_controller.dart](lib/Authentication/Controllers/planner_controller.dart) |
| Notifications state | [lib/Authentication/Controllers/notification_controller.dart](lib/Authentication/Controllers/notification_controller.dart) |
| Notification data access | [lib/Pages/Notifications/notification_database.dart](lib/Pages/Notifications/notification_database.dart) |
| Growth dashboard data | [lib/Pages/Growth/growth_database.dart](lib/Pages/Growth/growth_database.dart) |
| Admin role check | [lib/admin/admin_service.dart](lib/admin/admin_service.dart) |
| Theme & colors | [lib/Utilities/Customs/theme.dart](lib/Utilities/Customs/theme.dart), [lib/Utilities/Constants/colors.dart](lib/Utilities/Constants/colors.dart) |
