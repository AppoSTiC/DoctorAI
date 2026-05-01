# Voice AI Health Assistant

This directory contains the core Flutter implementation for the Voice AI Health Assistant MVP.

## Setup Instructions

Since `flutter` could not be executed directly on this machine, follow these steps to build and run the app on a machine with Flutter installed:

### 1. Initialize the Flutter Project
Open a terminal in this directory (`d:\memory-bank\voice_ai_health_assistant`) and run:
```bash
flutter create .
```
This command will generate the Android and iOS folders without overwriting the `lib/` code.

### 2. Add Required Permissions

**For Android:**
Open `android/app/src/main/AndroidManifest.xml` and add the following permissions right above the `<application>` tag:
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

**For iOS:**
Open `ios/Runner/Info.plist` and add the following keys inside the `<dict>` tag:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>We need access to your microphone to hear your symptoms.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>We need speech recognition to process your voice input.</string>
```

### 3. Add Your OpenAI API Key
Open `lib/services/ai_service.dart` and replace `YOUR_OPENAI_API_KEY_HERE` with your actual OpenAI API key.

### 4. Fetch Dependencies
Run:
```bash
flutter pub get
```

### 5. Run the App
Connect a physical device or an emulator, then run:
```bash
flutter run
```

### 6. Build the APK
To build the production APK for Android, run:
```bash
flutter build apk
```
