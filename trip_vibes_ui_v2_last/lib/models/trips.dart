class Trip {
  final int? tripId;
  final String tripTitle;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? tripBudget;
  final String? tripPeople;

  Trip({
    this.tripId,
    required this.tripTitle,
    this.description,
    this.startDate,
    this.endDate,
    this.tripBudget,
    this.tripPeople,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tripId: json['trip_id'],
      tripTitle: json['trip_title'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      tripBudget: (json['trip_budget'] as num?)?.toDouble(), 
      tripPeople: json['trip_people'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trip_id': tripId,
      'trip_title': tripTitle,
      'description': description,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'trip_budget': tripBudget,
      'trip_people': tripPeople,
    };
  }
}
