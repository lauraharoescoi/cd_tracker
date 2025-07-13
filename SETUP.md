# 🛠️ Setup Guide for CD Tracker

This guide will walk you through setting up the CD Tracker project step by step.

## 🚀 Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/lauraharoescoi/cd_tracker.git
   cd cd_tracker
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Copy the credentials template**
   ```bash
   cp lib/config/credentials.dart.example lib/config/credentials.dart
   ```

4. **Follow the detailed setup below** 👇

## 📋 Detailed Setup Instructions

### 1. Firebase Setup

#### Install Firebase CLI
```bash
npm install -g firebase-tools
```

#### Configure Firebase
```bash
# Login to Firebase
firebase login

# Configure FlutterFire
flutterfire configure
```

#### Enable Firebase Services
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Enable **Authentication**:
   - Go to Authentication → Sign-in method
   - Enable **Google** provider
   - Copy the **Web client ID** (you'll need this later)
4. Enable **Firestore Database**:
   - Go to Firestore Database
   - Create database in **test mode** (for development)

### 2. Spotify API Setup

#### Create a Spotify App
1. Go to [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)
2. Log in with your Spotify account
3. Click **"Create an App"**
4. Fill in:
   - **App name**: CD Tracker (or any name you prefer)
   - **App description**: Personal CD collection tracker
   - **Redirect URIs**: Leave empty (we use Client Credentials flow)
5. Accept the Terms of Service
6. Click **"Create"**

#### Get Your Credentials
1. In your new app, copy the **Client ID**
2. Click **"Show Client Secret"** and copy it
3. Edit `lib/config/credentials.dart` and replace:
   ```dart
   const String spotifyClientId = 'YOUR_ACTUAL_CLIENT_ID_HERE';
   const String spotifyClientSecret = 'YOUR_ACTUAL_CLIENT_SECRET_HERE';
   ```

### 3. Google Sign-In Configuration

#### Get the Google Server Client ID
1. In Firebase Console, go to **Authentication** → **Sign-in method**
2. Click on **Google**
3. In the **Web SDK configuration** section, copy the **Web client ID**
4. Edit `lib/config/credentials.dart` and replace:
   ```dart
   const String googleServerClientId = 'YOUR_ACTUAL_WEB_CLIENT_ID_HERE';
   ```

### 4. Platform-Specific Setup

#### Android
- The `google-services.json` file is already included
- If you need to regenerate it:
  1. Go to Firebase Console → Project Settings → General
  2. Scroll to "Your apps" → Android app
  3. Download `google-services.json`
  4. Place it in `android/app/`

#### iOS
- The `GoogleService-Info.plist` file is already included
- If you need to regenerate it:
  1. Go to Firebase Console → Project Settings → General
  2. Scroll to "Your apps" → iOS app
  3. Download `GoogleService-Info.plist`
  4. Place it in `ios/Runner/`

#### macOS
- The `GoogleService-Info.plist` file is already included for macOS
- If you need to regenerate it, follow the same process as iOS

### 5. Run the App

```bash
flutter run
```