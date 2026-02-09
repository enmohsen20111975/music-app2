# Development Setup Guide

## Prerequisites

1. Install Flutter SDK:
   - Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install)
   - Add Flutter to your PATH
   - Run `flutter doctor` to verify installation

2. Install Git:
   - Download Git from [git-scm.com](https://git-scm.com/download/win)
   - During installation, select "Git from the command line and also from 3rd-party software"
   - After installation, open a new terminal and verify with `git --version`

3. Install Android Studio or Visual Studio Code:
   - For Android Studio: Install Flutter and Dart plugins
   - For VS Code: Install Flutter and Dart extensions

## Project Setup

1. Clone and Setup:
   ```powershell
   # Clone the repository (if needed)
   git clone <repository-url>
   cd "Music App"

   # Get dependencies
   flutter pub get
   ```

2. Run the analyzer to check for issues:
   ```powershell
   flutter analyze
   ```

3. Run the app:
   ```powershell
   flutter run
   ```

## Common Issues

1. "Error: Unable to find git in your PATH"
   - Solution: Install Git and ensure it's in your PATH
   - After installing, close and reopen your terminal/VS Code

2. Flutter command not found
   - Solution: Add Flutter to your PATH
   - Verify with `flutter doctor`

3. Package resolution fails
   - Run `flutter clean`
   - Then `flutter pub get`

## Project Structure

- `lib/`: Main source code
  - `Controllers/`: GetX controllers and state management
  - `MP3Player/`: Audio playback implementation
  - `View/`: UI screens and widgets
  - `DataModel/`: Data models and DTOs
  - `Scraping/`: Web scraping implementation

## Key Dependencies

The app uses several important packages:
- `get`: State management
- `just_audio`: Audio playback
- `just_audio_background`: Background audio support
- `sqflite`: Local database
- `http`: Network requests
- `auto_size_text`: Responsive text

## Development Guidelines

1. Null Safety:
   - Use proper null safety patterns
   - Avoid force unwrapping (!) unless absolutely necessary
   - Initialize late variables in initState

2. State Management:
   - Use GetX controllers for state
   - Dispose controllers properly
   - Avoid static state when possible

3. Error Handling:
   - Add try-catch blocks around network calls
   - Show user-friendly error messages
   - Log errors for debugging

4. Resource Management:
   - Dispose controllers and streams
   - Clean up subscriptions
   - Use const widgets when possible