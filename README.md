# Music Finder

A Flutter application designed for music discovery, real-time song search, synchronized lyrics rendering, and audio playback management.

## Features

- **Music Search**: Dynamic song search functionality with real-time results (`music_search_service.dart`, `music_search_field.dart`).
- **Interactive Audio Player**: Audio playback controls, rotating album art animation (`album_disc.dart`), playback slider (`playback_slider.dart`), and a compact mini-player (`compact_player.dart`).
- **Synchronized Lyrics**: Parsed line-by-line lyric viewer with active line tracking (`lyrics_service.dart`, `lyrics_panel.dart`, `lyric_line.dart`).
- **User Profile & Settings**: Local storage integration for user preferences (`preferences_store.dart`, `profile_settings_page.dart`).
- **Theme Support**: Custom dark and light mode UI configurations (`music_theme.dart`).

## Tech Stack

- **Framework**: Flutter (Dart)
- **Target Platforms**: Android and Web
- **State & Local Persistence**: Shared Preferences (`shared_preferences`)

## Project Structure

```
lib/
├── app/
│   ├── music_application.dart    # Application root widget and routing configuration
│   └── music_theme.dart          # Visual theme and style declarations
├── models/
│   └── lyric_line.dart           # Data model for synchronized lyrics
├── pages/
│   ├── home/                     # Home screen and search view
│   ├── player/                   # Full-screen audio player page
│   └── profile/                  # User profile and settings view
├── services/
│   ├── lyrics_service.dart       # Lyrics parsing and fetch handlers
│   ├── music_search_service.dart # Music API communication service
│   └── preferences_store.dart    # Local persistence implementation
├── widgets/
│   ├── home/                     # Modular widgets for the home screen
│   └── player/                   # Player components (disc animation, lyrics panel, slider)
└── main.dart                     # Application main entry point
```

## Getting Started

### Prerequisites

Ensure the following tools are installed on your environment:

- Flutter SDK (`>= 3.0.0`)
- Android Studio or VS Code with Flutter extensions
- Android Virtual Device (AVD) or physical testing device
- Google Chrome (for web)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/username/Music-Finder.git
   ```

2. Navigate to the project directory:
   ```bash
   cd Music-Finder
   ```

3. Install project dependencies:
   ```bash
   flutter pub get
   ```

4. Run the application in Chrome:
   ```bash
   flutter run -d chrome
   ```

   To run on Android instead, start an emulator or connect a device, then use:
   ```bash
   flutter run
   ```

   On Windows, if a build command reports that a path such as `C:\Users\...` is
   not recognized, use a Flutter SDK path without spaces and put its `bin`
   directory first on `PATH`.

## Testing

Execute the test suite using the standard Flutter test runner:

```bash
flutter test
```

## License

This project is licensed under the MIT License.
