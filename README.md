# Zaffran Restaurant App

Zaffran is an iOS restaurant reservation and event-booking application developed using SwiftUI and Firebase.

The application was created as a two-person university project by Mohammad Abbas Tungeker and Mansour Junbish at the University of Technology Sydney. It allows users to register, sign in, create different types of restaurant bookings, and view or cancel their existing reservations.

> This is a university portfolio project. The original Firebase backend and configuration are no longer included or maintained.

## Features

- User registration and login
- Firebase Authentication
- Individual table reservations
- Group booking requests
- Event booking requests
- Date and time selection
- Table and menu selection
- User-specific booking history
- Booking cancellation
- Cloud Firestore data storage

## Technologies

- Swift
- SwiftUI
- Firebase Authentication
- Cloud Firestore
- Xcode
- Swift Package Manager

## Application Structure

The project follows a basic Model-View-ViewModel architecture:

```text
RestaurantApp/
├── Model/
│   ├── EventBookingModel/
│   ├── GroupBookingModel/
│   └── ReservationModel/
│
├── View/
│   ├── AuthenticationView/
│   ├── EventBookingView.swift
│   ├── GroupBookingView.swift
│   ├── MainView.swift
│   ├── MyBookings.swift
│   └── ReservationView.swift
│
├── ViewModel/
│   ├── AuthenticationViewModel/
│   ├── EventBookingViewModel/
│   ├── GroupBookingViewModel/
│   └── ReservationViewModel/
│
├── Assets.xcassets/
├── ContentView.swift
└── RestaurantAppApp.swift
```

- **Models** represent reservation, group-booking, and event-booking data.
- **Views** contain the SwiftUI screens displayed to the user.
- **ViewModels** manage authentication, Firebase requests, and booking data.

## Running the Project

### Requirements

- A Mac running macOS
- Xcode
- An iPhone simulator or physical iOS device
- Internet access for Firebase services
- A personal Firebase project

### Instructions

1. Clone or download the repository:

```bash
git clone https://github.com/abbastungeker/Zaffran-Restaurant-App.git
```

2. Open the project folder:

```bash
cd Zaffran-Restaurant-App
```

3. Open `Zafran.xcodeproj` in Xcode.

4. Create your own Firebase project.

5. Enable Firebase Authentication and Cloud Firestore.

6. Register an iOS application in Firebase using the bundle identifier configured in the Xcode project.

7. Download your own `GoogleService-Info.plist`.

8. Add `GoogleService-Info.plist` to the Xcode project and ensure it is included in the application target.

9. Allow Xcode to resolve the Firebase packages through Swift Package Manager.

10. Select an available iPhone simulator or connected iOS device.

11. Press **Run** or use:

```text
Command + R
```

## Firebase Configuration

The original `GoogleService-Info.plist` file is not included in this repository.

Developers must create their own Firebase project and supply their own configuration file before running the application.

The Firebase configuration file is excluded from version control through `.gitignore`:

```gitignore
GoogleService-Info.plist
**/GoogleService-Info.plist
```

The application also requires suitable Firebase Authentication settings, Firestore collections, and Firestore security rules.

## Academic Context

This application was developed as a two-person university group project at the University of Technology Sydney.

### Team Members

- Mohammad Abbas Tungeker
- Mansour Junbish

The project was later reviewed and given minor corrections to improve:

- Authentication behaviour
- Booking-date handling
- Input validation
- Firestore record management

## Limitations

This is a university project rather than a production-ready restaurant platform.

- The application focuses on bookings rather than food ordering or payment processing.
- Booking options are predefined within the application.
- Firebase error handling is basic.
- The application requires a user-supplied Firebase configuration and an available Firestore database.
- The original Firebase backend is no longer maintained.
- The application has not been prepared for deployment to the Apple App Store.
