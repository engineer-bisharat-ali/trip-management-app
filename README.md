# ✈️ Trip Management App (Flutter)

A simple and user-friendly Trip Management application built with Flutter.  
Users can create **One Way**, **Round Trip**, and **Multi-City trips**, manage segments, and view trip history.

---

## 🚀 Features

- ✅ Create **One Way Trips**
- ✅ Create **Round Trips (with return date)**
- ✅ Create **Multi-City Trips (dynamic segments)**
- ✅ Add / Remove trip segments
- ✅ Store trip history
- ✅ View all created trips in History Screen
- ✅ Clean UI with Provider state management

---

## 📱 Tech Stack

- **Flutter (Dart)**
- **Provider (State Management)**

---

## 📂 Project Structure

```
lib/
│
├── models/
│   ├── trip_model.dart
│   └── segment_model.dart
│
├── providers/
│   └── trip_provider.dart
│
├── screens/
│   ├── one_way_screen.dart
│   ├── round_trip_screen.dart
│   ├── multi_city_screen.dart
│   └── trip_summary_screen.dart
|    └── trip_history_screen.dart

│
├── widgets/
│   └── custom_button.dart
|   └── custom_textfield.dart
│
└── main.dart
```

---

## ⚙️ How It Works

### 1. Trip Creation Flow

- User selects trip type:
  - `oneWay`
  - `roundTrip`
  - `multiCity`

- Based on type:
  - OneWay → 1 segment  
  - RoundTrip → 2 segments (to & return)  
  - MultiCity → dynamic segments  

---
## ▶️ Getting Started

### 1. Clone Project

```bash
git clone https://github.com/engineer-bisharat-ali/trip-management-app.git
cd trip-management-app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run App

```bash
flutter run
```

---

## 🧠 State Management

This project uses **Provider**:

- `TripProvider` handles:
  - Trip data  
  - Segments  
  - Dates  
  - History  

---


## 👨‍💻 Author

**Bisharat Ali**  
GitHub: https://github.com/engineer-bisharat-ali

---

## 📌 Future Improvements

- Save data locally (Hive / SharedPreferences)  
- Add edit trip feature  
- Add delete trip option  
- UI improvements  

---

✨ Happy Coding & Traveling!
