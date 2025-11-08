# Flutter Login App - AI Agent Instructions

## Architecture Overview
This is a Flutter mobile app with Firebase authentication featuring a login system, item management, and user interactions. The app uses a brown-themed Material Design UI with custom components.

**Key Components:**
- `lib/main.dart` - Firebase initialization and app entry point
- `lib/my_app.dart` - MaterialApp with named routes (`/`, `/register`)
- `lib/views/` - Screen widgets (login, register, home)
- `lib/widgets/` - Reusable components (custom_text_fields.dart)
- `lib/firebase_options.dart` - Platform-specific Firebase configuration

## Navigation Patterns
- **Named Routes**: Used for unauthenticated screens (`/` → Login, `/register` → Register)
- **Manual Navigation**: `Navigator.pushReplacement()` for authenticated transitions (Login → Home)
- **Dialog-based Input**: Use `showDialog()` with `AlertDialog` for user input instead of separate screens

## State Management
- **Local State**: `StatefulWidget` with `setState()` for UI state
- **Data Storage**: In-memory lists stored in widget state (e.g., `_items` in Home widget)
- **No External State**: No providers, bloc, or redux - keep state local to widgets

## UI Patterns
**Color Scheme:**
```dart
// Primary colors used throughout
Colors.brown[800]  // AppBar background
Colors.brown       // FAB, accents
Colors.brown[50]   // Input field backgrounds
Colors.brown[700]  // Icon colors
```

**Custom Components:**
- `CustomTextField` - Brown-themed text fields with validation
- Card-based ListView items with trailing delete buttons
- FloatingActionButton for primary actions
- SnackBar for user feedback

**Layout Structure:**
```dart
Scaffold(
  appBar: AppBar(
    backgroundColor: Colors.brown[800],
    // actions with IconButton widgets
  ),
  body: _items.isEmpty ? emptyStateWidget : listView,
  floatingActionButton: FAB(),
)
```

## Firebase Integration
**Authentication Flow:**
- Firebase Auth instance: `FirebaseAuth.instance`
- Sign out: `await _auth.signOut()`
- Current user: `_auth.currentUser`
- Navigation after auth: `Navigator.pushReplacement()`

**Configuration:**
- Initialize in `main()`: `await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`
- Platform-specific options in `firebase_options.dart`

## Development Workflow
**Running the App:**
```bash
flutter run          # Run on connected device/emulator
flutter run -d chrome # Run on web (if configured)
```

**Building:**
```bash
flutter build apk    # Android APK
flutter build ios    # iOS (requires macOS)
flutter build web    # Web build
```

**Firebase Setup:**
```bash
flutterfire configure # Configure Firebase (requires Firebase CLI)
```

## Code Conventions
- **Imports**: Group by package type (flutter, firebase, local)
- **State Classes**: Use `WidgetNameState` pattern for StatefulWidget
- **Controllers**: Dispose TextEditingController in `dispose()` method
- **Error Handling**: Use try-catch with mounted checks and SnackBar feedback
- **Navigation Guards**: Check `context.mounted` before navigation

## Common Patterns
**Dialog Input:**
```dart
void _showAddInputDialog() {
  final controller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add Item'),
      content: TextField(controller: controller),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        ElevatedButton(onPressed: () => _addItem(controller.text), child: Text('Add')),
      ],
    ),
  );
}
```

**List Management:**
```dart
ListView.builder(
  itemCount: _items.length,
  itemBuilder: (context, index) => Card(
    child: ListTile(
      title: Text(_items[index]),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => setState(() => _items.removeAt(index)),
      ),
    ),
  ),
)
```

## Dependencies
- `firebase_core`, `firebase_auth` - Authentication
- `google_sign_in`, `flutter_facebook_auth` - Social login
- `file_picker` - File selection
- `logging` - Debug logging

## File Structure
```
lib/
├── main.dart              # App entry with Firebase init
├── my_app.dart            # MaterialApp with routes
├── firebase_options.dart  # Firebase config
├── views/
│   ├── login.dart         # Authentication screen
│   ├── register.dart      # Registration screen
│   └── home.dart          # Main app screen
└── widgets/
    └── custom_text_fields.dart  # Reusable text field
```