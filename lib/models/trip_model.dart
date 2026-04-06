import 'package:trip_management/models/segment_model.dart';

class TripModel {
  final String tripName;
  final String tripType;
  final List<Segment> segments;

  TripModel({
    required this.tripName,
    required this.tripType,
    required this.segments,
  });
}
