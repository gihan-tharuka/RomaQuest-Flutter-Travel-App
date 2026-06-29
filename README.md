# RomaQuest

RomaQuest is a Flutter travel companion app focused on discovering places in Rome. It began as a university assignment and has since been modernized into a stronger portfolio project with updated Flutter compatibility, cleaner structure, typed place data, local persistence, widget tests, and a more polished UI.

## Project Pitch

RomaQuest showcases a practical mobile app foundation for travel discovery:

- Firebase email/password authentication
- curated Rome place discovery by category
- favorites and visited-place flows with local persistence
- weather and location integration
- profile photo capture and simple device utility integrations

The goal of this repository is not to present a production-ready travel platform. It is an honest example of taking an older student project and incrementally upgrading it into a maintained Flutter portfolio app.

## Compatibility

- Flutter stable `3.44.4`
- Dart `3.12.2`

The project has been updated to run on current Flutter 3.44 tooling, including newer text theme APIs and theme compatibility updates.

## Features

- Welcome flow with authentication state handling
- Firebase Auth login and registration
- Home discovery screen with category filtering
- Typed `Place` model backed by seeded Rome travel data
- `PlaceRepository` for loading and filtering places
- Place details screen with rating, category, hours, and description
- Favorites saved locally with `SharedPreferences`
- Visited places saved locally with `SharedPreferences`
- Weather screen using device location plus OpenWeatherMap
- Profile screen with camera image selection and persisted profile image path
- Battery level display on the profile screen
- Light/dark theme support with a refreshed travel-oriented design foundation
- Widget tests covering key app flows

## Tech Stack

- Flutter
- Dart
- Firebase Authentication
- `shared_preferences`
- `http`
- `geolocator`
- `geocoding`
- `permission_handler`
- `image_picker`
- `battery_plus`

## Architecture Summary

The app keeps a lightweight Flutter structure that is still approachable for a portfolio project:

- `lib/main.dart`: app bootstrap and Firebase initialization
- `lib/screens/`: user-facing screens and navigation flow
- `lib/models/place.dart`: typed `Place` domain model
- `lib/data/place_seed_data.dart`: seeded place data used by the app
- `lib/repositories/place_repository.dart`: place lookup and category filtering helper
- `lib/widgets/`: shared UI pieces such as auth shell, empty states, place cards, and saved-place tiles
- `lib/theme/`: app theme, tokens, and design foundation files

State is mostly managed with `StatefulWidget` and local `setState`, with persistence handled through `SharedPreferences`.

## Upgrade Highlights

Recent upgrade work focused on turning the app into a cleaner portfolio piece while preserving its original feature scope:

- updated compatibility for modern Flutter 3.44 / Dart 3.12
- replaced outdated Flutter theme/text API usage
- introduced a typed `Place` model instead of screen-centric maps
- moved seeded travel data behind a small `PlaceRepository`
- completed favorites and visited persistence flows
- improved empty/error states for saved lists and weather
- added widget tests aligned to the actual app
- refreshed the visual foundation and key screens with a more modern travel-app look

## Upgrade Case Study

### Before

- assignment-era structure
- screen-local hardcoded place maps
- incomplete visited flow
- weaker empty states and test coverage
- older Flutter API usage that broke on newer SDKs

### After

- current Flutter compatibility
- typed place data and a light repository layer
- working favorites and visited flows with persistence
- stronger README, test coverage, and UI consistency
- more credible presentation as an actively maintained learning project

## Testing and Quality

Current repo quality checks used during the upgrade:

- `flutter test` passes
- widget tests cover favorites, visited persistence, and place repository behavior
- `flutter run -d chrome` has been verified during upgrade work
- `flutter analyze` still reports some non-blocking lint noise in older files, but the app builds and runs

This project is best understood as a maintained portfolio app with honest limitations, not a fully hardened production codebase.

## Setup

1. Clone the repository:

   ```bash
   git clone <your-repo-url>
   cd RomaQuest-Flutter-Travel-App
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the tests:

   ```bash
   flutter test
   ```

4. Launch the app:

   ```bash
   flutter run
   ```

For web verification, Chrome has been used during upgrade checks:

```bash
flutter run -d chrome
```

## Setup Notes

- Firebase configuration files are already present for the current project setup.
- Weather functionality requires network access and location permission.
- Profile photo support depends on platform camera/image-picker behavior.
- Platform folders currently present in the repo include Android, iOS, web, macOS, Linux, and Windows.

## Known Limitations

- Place content is seeded locally rather than loaded from a backend or CMS.
- Weather uses a simple direct API integration and is not wrapped in a larger data layer.
- Authentication is limited to Firebase email/password flows.
- Some analyzer lints remain in older parts of the codebase.
- The project does not yet claim deployment, CI, offline sync, or production-grade error monitoring.

## Screenshots

### Welcome

![Welcome screen](assets/screenshots/start.png)

### Authentication

![Login screen](assets/screenshots/login.png)
![Registration screen](assets/screenshots/register1.png)

### Discovery

![Home screen](assets/screenshots/home.png)
![Place details screen](assets/screenshots/place.png)

### Saved and Utility Screens

![Favorites screen](assets/screenshots/fav.png)
![Weather screen](assets/screenshots/weather.png)
![Profile screen](assets/screenshots/settings.png)
