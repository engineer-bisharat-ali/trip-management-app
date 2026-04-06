// segment model
class Segment {
  final String from;
  final String to;
  final DateTime date;
  final DateTime?
  returnDate; // for round trip segments, this can be null for one-way segments

  Segment({
    required this.from,
    required this.to,
    required this.date,
    this.returnDate,
  });
}
