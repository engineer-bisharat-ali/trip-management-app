import 'package:flutter/material.dart';
import '../models/trip_model.dart';
import '../models/segment_model.dart';

class TripProvider extends ChangeNotifier {
  // Trip History
  final List<TripModel> _tripHistory = [];

  //  Current Trip Data
  String _tripName = '';
  String _tripType = 'oneWay';
  final List<Segment> _segments = [];

  DateTime? _departureDate;
  DateTime? _returnDate;

  // GETTERS
  String get tripName => _tripName;
  String get tripType => _tripType;
  List<Segment> get segments => List.unmodifiable(_segments);
  DateTime? get departureDate => _departureDate;
  DateTime? get returnDate => _returnDate;
  List<TripModel> get tripHistory => List.unmodifiable(_tripHistory);

  // SETTERS
  void setTripName(String name) {
    _tripName = name;
    notifyListeners();
  }

  void setTripType(String type) {
    _tripType = type;

    //  reset data on type change
    _segments.clear();
    _departureDate = null;
    _returnDate = null;

    notifyListeners();
  }

  // ADD SEGMENT
  void addSegment(Segment segment) {
    _segments.add(segment);
    notifyListeners();
  }
  // CLEAR SEGMENTS (used when switching trip types or resetting form)
  void clearSegments() {
    _segments.clear();
    notifyListeners();
  }
  // SET DATES
  void setDepartureDate(DateTime date) {
    _departureDate = date;
    notifyListeners();
  }
  // For round trip, we need to set return date separately
  void setReturnDate(DateTime date) {
    _returnDate = date;
    notifyListeners();
  }

  // CREATE TRIP (SAVE TO HISTORY)
  void createTrip() {
    final newTrip = TripModel(
      tripName: _tripName,
      tripType: _tripType,
      segments: List.from(_segments),
    );

    _tripHistory.add(newTrip); // 🔥 add to history

    notifyListeners();
  }

  //  RESET CURRENT FORM DATA
  void resetTrip() {
    _tripName = '';
    _tripType = 'oneWay';
    _segments.clear();
    _departureDate = null;
    _returnDate = null;

    notifyListeners();
  }
}
