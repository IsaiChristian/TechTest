[![Flutter CI](https://github.com/IsaiChristian/TechTest/actions/workflows/main.yml/badge.svg)](https://github.com/IsaiChristian/TechTest/actions/workflows/main.yml)

[Coverage Result](https://isaichristian.github.io/TechTest/index.html)

# Christian Tech test MovieDB

A Flutter movie browsing application showcasing modern development practices and clean architecture.

## Preface

Hi, I'm Christian Isai. Thanks for your consideration for the position. 
Something to consider while reviewing this test: I took the opportunity 
to try some of the latest features, including some experimental ones. 

Other things that I decided to practice while doing your test were:
- Setting up a worker on my own VPS to run the GitHub Actions (You can click on the badge at the top to see each run!)
- Using GitHub Actions to perform an analysis for Flutter tests (I also printed the results with LCOV)
- Playing with Animations without the use of lottie or rive



## Features

- Browse popular movies with infinite scroll
- Mark movies as favorites and manage your collection
- Search for movies by title
- Responsive UI with custom animations
- Smart error handling (blocking and non-blocking states)
- Comprehensive test coverage

# Screenshots and Video

## Home Screen
| Loading States | Content View | Movie Detail |
|:---:|:---:|:---:|
| ![Initial Loading](https://raw.githubusercontent.com/IsaiChristian/TechTest/refs/heads/master/screenshots/home_loading_init.jpg) | ![Home](https://raw.githubusercontent.com/IsaiChristian/TechTest/refs/heads/master/screenshots/home.jpg) | ![Movie Detail](https://raw.githubusercontent.com/IsaiChristian/TechTest/refs/heads/master/screenshots/movie_detail.jpg) |
| **Initial Loading** | **Home View** | **Movie Detail** |

| Loading More | Non-Blocking Error |
|:---:|:---:|
| ![Loading More](https://raw.githubusercontent.com/IsaiChristian/TechTest/refs/heads/master/screenshots/home_loading_more.jpg) | ![Error State](https://raw.githubusercontent.com/IsaiChristian/TechTest/refs/heads/master/screenshots/home_not_blocking_error.jpg) |
| **Loading More Content** | **Non-Blocking Error** |

## Favorites
| Empty State | With Content |
|:---:|:---:|
| ![Empty Favorites](https://raw.githubusercontent.com/IsaiChristian/TechTest/refs/heads/master/screenshots/favorites_empty.jpg) | ![Filled Favorites](https://raw.githubusercontent.com/IsaiChristian/TechTest/refs/heads/master/screenshots/favorites_filled.jpg) |
| **Empty Favorites** | **Favorites List** |

## Search
| Default | Active Search | Error State |
|:---:|:---:|:---:|
| ![Search](https://raw.githubusercontent.com/IsaiChristian/TechTest/refs/heads/master/screenshots/search.jpg) | ![Search Active](https://raw.githubusercontent.com/IsaiChristian/TechTest/refs/heads/master/screenshots/search_active.jpg) | ![Search Error](https://raw.githubusercontent.com/IsaiChristian/TechTest/refs/heads/master/screenshots/search_query_error.jpg) |
| **Search Screen** | **Active Search** | **Search Query Error** |

## Error Handling
| Blocking Error |
|:---:|
| ![Blocking Error](https://raw.githubusercontent.com/IsaiChristian/TechTest/refs/heads/master/screenshots/blocking_error.jpg) |
| **Blocking Error Screen** |

## Video Demo

https://raw.githubusercontent.com/IsaiChristian/TechTest/refs/heads/master/screenshots/working_video.mp4

## Getting Started

### Prerequisites

- Flutter SDK (3.35.5 or higher recommended)
- Dart SDK (2.9.2 or higher recommended)
- A code editor (VS Code, Android Studio, or IntelliJ IDEA)
- iOS Simulator or Android Emulator (or a physical device)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/IsaiChristian/TechTest.git
   cd TechTest
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up your API key**
   
   Create a `.env` file in the `secrets` directory with your [TheMovieDB](https://www.themoviedb.org/) API key:
   
   ```bash
   
   # Create the .env file
   touch secrets/.env
   ```
   
   Add your API key to `secrets/.env`:
   ```env
   TMDB_API_KEY=your_api_key_here
   ```
   
   > **Getting an API key:** Visit [TheMovieDB](https://www.themoviedb.org/), create a free account, go to Settings → API, and request an API key.

4. **Run the app**
   
   This project uses experimental features, so you'll need to enable them:
   ```bash
   flutter run --enable-experiment=dot-shorthands
   ```
   
   Or for a specific device:
   ```bash
   # List available devices
   flutter devices
   
   # Run on a specific device
   flutter run --enable-experiment=dot-shorthands -d <device-id>
   ```

### Running Tests

```bash
# Run all tests
flutter test --enable-experiment=dot-shorthands

# Run tests with coverage
flutter test --enable-experiment=dot-shorthands --coverage

# View coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Building for Release

**Android:**
```bash
flutter build apk --enable-experiment=dot-shorthands --release
```

**iOS:**
```bash
flutter build ios --enable-experiment=dot-shorthands --release
```

### VS Code Configuration

If you're using VS Code, create a `launch.json` file to make running with experimental features easier:

1. Create a `.vscode` folder in the project root (if it doesn't exist)
2. Create a `launch.json` file inside `.vscode` with the following content:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter (Dev)",
      "request": "launch",
      "type": "dart",
      "program": "lib/src/main.dart",
      "toolArgs": [
        "--enable-experiment=dot-shorthands"
      ]
    },
    {
      "name": "Flutter (Profile)",
      "request": "launch",
      "type": "dart",
      "flutterMode": "profile",
      "program": "lib/src/main.dart",
      "toolArgs": [
        "--enable-experiment=dot-shorthands"
      ]
    },
    {
      "name": "Flutter (Release)",
      "request": "launch",
      "type": "dart",
      "flutterMode": "release",
      "program": "lib/src/main.dart",
      "toolArgs": [
        "--enable-experiment=dot-shorthands"
      ]
    }
  ]
}
```

Now you can run the app directly from VS Code's Run and Debug panel (or press `F5`) without typing the command every time!

## Architecture

We are using Clean Code Architecture with BLoC as the state management solution.

### Project Structure

```plaintext
lib
├── core ──────────────────────────── Shared code across the app
│   ├── di ────────────────────────── Dependency injection setup
│   ├── error ─────────────────────── Error handling, failures, logger service, and error bus
│   ├── network ───────────────────── Network configuration and interceptors
│   ├── router ────────────────────── App navigation
│   └── services ──────────────────── Local services (storage, etc.)
├── data ──────────────────────────── Data layer - where data is gathered
│   ├── mappers ───────────────────── Transformations between layers
│   ├── models ────────────────────── Data models (usually mirror JSON structure)
│   └── repositories ──────────────── Repository implementations
├── domain ────────────────────────── Domain layer - business logic
│   ├── entities ──────────────────── Business entities (mirror UI structure)
│   └── repositories ──────────────── Repository abstractions
├── presentation ──────────────────── Shared widgets across features
└── src ───────────────────────────── Feature modules
    ├── app ───────────────────────── Global app BLoC (auth, network events)
    ├── favorites/presentation
    ├── home/presentation
    │   ├── bloc ──────────────────── State management
    │   ├── pages ─────────────────── Full page screens
    │   └── widgets ───────────────── Reusable feature widgets
    ├── movie_detail/presentation
    ├── search/presentation
    └── main.dart ─────────────────── App entry point
```

> **Note:** The test folder structure mirrors the lib folder for consistency.

## Technical Decisions 

### Why Clean Architecture?
I find it very straightforward once you know what goes where. It also forces you to think about each layer and how the information should flow, making the codebase more maintainable and testable.

### Why BLoC?
BLoC is more verbose than other state management solutions, but it gives you much more control once everything is set up. It provides a clear separation between business logic and UI, making the code easier to test and reason about.

### Why Dio?
Dio offers interceptors, which are very useful for having just one place to handle everything HTTP-related. Having only one place for this helps with logging, debugging, and adding features like retry logic or authentication tokens.

### What is the Global Error Bus?
It's a centralized way to dispatch errors from anywhere in the app to the AppBLoC. This helps with error handling and user notifications, especially when errors occur outside the normal UI flow.

### How Do You Handle Errors?
We use a functional approach with the Either type:

`Either<L, R>` represents a value that can be one of two possible types:
- **Left (L)** → represents a failure or error
- **Right (R)** → represents a success or valid result

This pattern forces you to always acknowledge both the failure and success paths, making error handling explicit and harder to overlook.

### Is That Why You Have SafeCalls?
Yes! SafeCalls are helper functions that reduce boilerplate while keeping the power of the Either pattern. They wrap try-catch blocks and automatically return Either types.

### Why Add Infinite Scroll?
I wanted to demonstrate a different approach to loading states and pagination. The implementation tracks scroll position and automatically loads the next page when the user approaches the end of the list, providing a seamless browsing experience.

### Is the App Production-Ready?
It's close, but not quite. A production app would need:
- Secure API key management (backend proxy or secure key storage)
- Proper authentication flow
- More comprehensive error logging and analytics
- Crash reporting
- Performance monitoring
- More extensive testing (integration and E2E tests)
- Accessibility improvements
- Internationalization support

No production app should have API keys in the code, regardless of obfuscation or runtime injection methods.

## Tech Stack

- **Framework:** Flutter
- **State Management:** BLoC (flutter_bloc)
- **Networking:** Dio with interceptors
- **Functional Programming:** dartz (Either type)
- **Dependency Injection:** provider
- **Routing:** go_router
- **Local Storage:** shared_preferences 
- **Testing:** mockito, bloc_test

## Contributing

This is a test project, but if you have suggestions or find issues, feel free to open an issue or submit a pull request!

## License

This project is for demonstration purposes. 
Note: The BlackBull branding, logo, and all associated visual assets are proprietary and owned by BlackBull. All rights reserved.

## Contact
- Email: christian.isai@gmail.com
- Phone: +52 961 290 9907
- GitHub: IsaiChristian

---

Made with ❤️ and Flutter
