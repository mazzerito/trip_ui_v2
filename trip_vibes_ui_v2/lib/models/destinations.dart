class Destination {
  final int? destinationId;
  final String destinationName;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? destinationImage;

  Destination({
    this.destinationId,
    required this.destinationName,
    this.startDate,
    this.endDate,
    this.destinationImage,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      destinationId: json['destination_id'],
      destinationName: json['destination_name'],
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
      destinationImage: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'destination_id': destinationId,
      'destination_name': destinationName,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'image_url': destinationImage,
    };
  }
}
