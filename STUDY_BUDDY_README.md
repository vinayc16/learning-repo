# Study Buddy AI - Professional Study Assistant

A beautiful, professional AI-powered study assistant app built with Flutter that helps students convert handwritten notes into intelligent study materials.

## ✨ Features

### 🔐 Authentication System
- **User Registration** - Create new account with name, email, phone, and password
- **User Login** - Secure login with email and password
- **SharedPreferences Storage** - Local data persistence for user information
- **Auto-login** - Automatically logs in returning users

### 🏠 Home Screen
- **User Profile in AppBar** - Displays user name, email, and profile picture
- **Welcome Card** - Personalized greeting with gradient background
- **Scan Notes** - Upload images via camera or gallery
- **Image Preview** - Shows uploaded image before processing
- **Text Extraction** - Uses Google ML Kit for OCR
- **AI-Powered Study Materials**:
  - 📝 **Generate Summary** - Concise breakdown of key concepts
  - 🎴 **Create Flashcards** - Digital cards for active recall
  - 📊 **Build Quiz** - Multiple-choice questions from content

### ⚙️ Settings Screen
- **Profile Management**
  - Edit name and phone number
  - Upload/change profile picture (camera or gallery)
  - Remove profile picture
  - Profile picture displayed throughout app
- **Permission Management**
  - Camera permission status and request
  - Storage/Photos permission status and request
  - Visual indicators (Granted/Denied)
  - Direct link to app settings for permanently denied permissions
- **Logout** - Secure logout with confirmation

### 🎨 Modern UI Design
- **Beautiful Gradients** - Purple and blue gradient color scheme
- **Card-based Layout** - Clean, organized interface
- **Smooth Animations** - Fade-in animations and transitions
- **Professional Icons** - Material Design icons
- **Responsive Design** - Works on all screen sizes
- **Loading States** - Clear feedback during processing

### 📸 Camera & Storage Permissions
- **Runtime Permission Requests** - Asks for permissions when needed
- **Permission Status Tracking** - Shows current status in settings
- **Settings Integration** - Deep link to app settings
- **User-friendly Messages** - Clear explanations for permission needs

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.10.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Google Gemini API Key

### Installation

1. **Clone the repository**
```bash
git clone <your-repo-url>
cd learning
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Add your Gemini API Key**
   - Open `lib/study_buddy_ai_power/screens/home/study_buddy_home_screen.dart`
   - Replace the API key on line 21:
```dart
static const String _geminiApiKey = 'YOUR_API_KEY_HERE';
```

4. **Configure Android Permissions**
   - Open `android/app/src/main/AndroidManifest.xml`
   - Add the following permissions:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```

5. **Configure iOS Permissions** (if targeting iOS)
   - Open `ios/Runner/Info.plist`
   - Add the following:
```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to scan your notes</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to select images</string>
```

6. **Run the app**
```bash
flutter run
```

## 📁 Project Structure

```
lib/study_buddy_ai_power/
├── services/
│   ├── auth_service.dart          # Authentication & user management
│   └── permission_service.dart    # Camera & storage permissions
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart      # Login interface
│   │   └── register_screen.dart   # Registration interface
│   ├── home/
│   │   └── study_buddy_home_screen.dart  # Main app screen
│   └── settings/
│       └── settings_screen.dart   # Settings & profile management
└── screen/
    └── study_buddy_screen.dart    # Main app entry point
```

## 🔧 Key Technologies

- **Flutter** - Cross-platform mobile framework
- **Google ML Kit** - Text recognition (OCR)
- **Google Gemini AI** - Generate summaries, flashcards, and quizzes
- **SharedPreferences** - Local data storage
- **Image Picker** - Camera and gallery access
- **Permission Handler** - Runtime permissions
- **Material Design 3** - Modern UI components

## 📱 Screenshots Features

### Login/Registration
- Gradient background (purple to blue)
- Smooth animations
- Form validation
- Password visibility toggle

### Home Screen
- User profile in app bar with avatar
- Personalized welcome card
- Scan buttons (camera/gallery)
- Uploaded image preview
- Extracted text display
- AI magic cards for study materials
- Processing indicators

### Settings Screen
- Large profile picture with edit button
- User information display
- Edit profile dialog
- Change profile picture options
- Permission management cards
- Permission status indicators
- Logout with confirmation

## 🎯 Usage Flow

1. **First Time Users**
   - App opens to Login screen
   - Click "Register" to create account
   - Fill in details and submit
   - Automatically logged in and redirected to Home

2. **Returning Users**
   - App automatically logs in
   - Shows Home screen directly

3. **Scanning Notes**
   - Click Camera or Gallery button
   - Grant permissions if requested
   - Select/capture image
   - View uploaded image
   - See extracted text

4. **Generating Study Materials**
   - After text extraction, select AI Magic option:
     - Summary → Concise overview
     - Flashcards → Q&A format
     - Quiz → Multiple choice questions
   - Materials are auto-saved

5. **Managing Profile**
   - Click profile picture in app bar
   - Edit name/phone
   - Change profile picture
   - Manage permissions
   - Logout when done

## 🔒 Data Storage

All user data is stored locally using SharedPreferences:
- User credentials
- Profile information
- Profile picture paths
- Study notes and materials

## 🎨 Design Highlights

- **Color Scheme**: Purple (#667EEA) and Pink (#764BA2) gradients
- **Typography**: Roboto font family
- **Border Radius**: Rounded corners (12-20px)
- **Shadows**: Subtle elevation for depth
- **Animations**: Fade-in effects and micro-interactions
- **Icons**: Material Design icons with custom colors

## 🚧 Future Enhancements

- [ ] Cloud sync for notes
- [ ] Subject-wise organization
- [ ] Study schedule planner
- [ ] Progress tracking
- [ ] Share study materials
- [ ] Dark mode
- [ ] Multiple language support

## 📄 License

This project is private and for educational purposes.

## 👨‍💻 Developer

Created with ❤️ using Flutter

---

**Note**: Remember to keep your Gemini API key secure and never commit it to public repositories!
