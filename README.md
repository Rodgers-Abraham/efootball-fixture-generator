# eFootball Fixture Generator

A comprehensive tournament management platform for eFootball, featuring automated fixture generation, OCR-based match result scanning, and squad management.

## 🏗️ Architecture

The project consists of three main components:

- **Flutter Application**: A cross-platform mobile app built with Flutter.
  - **State Management**: [Riverpod](https://riverpod.dev/) for clean, reactive state handling.
  - **Navigation**: [GoRouter](https://pub.dev/packages/go_router) for declarative routing.
  - **OCR**: [Google ML Kit](https://developers.google.com/ml-kit/vision/text-recognition) for scanning match result screenshots.
- **Supabase Backend**: Provides real-time database, authentication, and Row Level Security (RLS).
- **Python Scraper**: A utility to populate the `player_cards` database by scraping player data from pesmaster.com.

---

## 🚀 Getting Started

### 1. Backend Setup (Supabase)
1. Create a new project on [Supabase](https://supabase.com/).
2. Navigate to the **SQL Editor** in the Supabase dashboard.
3. Copy the contents of `supabase/schema.sql` and run it to create the necessary tables and security policies.

### 2. Python Scraper Setup
The scraper is used to populate the database with the latest eFootball player cards.
1. Navigate to the `scraper/` directory.
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Create a `.env` file based on the environment variables required in `config.py`:
   ```env
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
   ```
4. Run the scraper:
   ```bash
   python main.py --mode efworld  # Recommended fast mode
   ```

### 3. Flutter App Setup
1. Ensure you have the Flutter SDK installed.
2. Install project dependencies:
   ```bash
   flutter pub get
   ```
3. Configure your Supabase credentials in `lib/core/utils/supabase_client.dart` (Note: It is recommended to migrate these to environment variables for production).
4. Run the app:
   ```bash
   flutter run
   ```

---

## 🧪 Testing

The project includes unit tests for core business logic, such as the bracket and fixture generation.

To run the tests:
```bash
flutter test
```

---

## 🎨 App Logo

This project uses [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) for icon management.
To update the logo:
1. Place your icon at `assets/icon/app_icon.png`.
2. Run the icon generation command:
   ```bash
   dart run flutter_launcher_icons
   ```
