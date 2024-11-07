
import 'package:intl/intl.dart';

class Activities {
  final int? activityId;
  final String activityTitle;
  final String? location;
  final DateTime? startTime;
  final DateTime? endTime;
  final double? activityCost;

  Activities({
    this.activityId,
    required this.activityTitle,
    this.location,
    this.startTime,
    this.endTime,
    this.activityCost,
  });

  // Factory constructor to create Activities object from JSON
  factory Activities.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(String? dateString) {
      if (dateString == null) return null;
      try {
        // Check if the format is time-only (HH:mm:ss)
        if (dateString.length <= 8) {
          return DateFormat('HH:mm:ss').parse(dateString);
        } else {
          // Full date-time format
          return DateTime.parse(dateString);
        }
      } catch (e) {
        print("Error parsing date: $e");
        return null;
      }
    }

    return Activities(
      activityId: json['activity_id'],
      activityTitle: json['activity_title'],
      location: json['location'],
      startTime: parseDateTime(json['start_time']),
      endTime: parseDateTime(json['end_time']),
      // activityCost: json['activity_cost'],
          activityCost: json['activity_cost'] != null
        ? (json['activity_cost'] as num).toDouble()
        : null,
    );
  }

// Adjusted toJson() method to send only time in HH:mm:ss format
  Map<String, dynamic> toJson() {
    String? formatTime(DateTime? time) {
      return time != null ? DateFormat('HH:mm:ss').format(time) : null;
    }

    return {
      'activity_id': activityId,
      'activity_title': activityTitle,
      'location': location,
      'start_time': formatTime(startTime), // Send time in HH:mm:ss format
      'end_time': formatTime(endTime),     // Send time in HH:mm:ss format
      'activity_cost': activityCost,
    };
  }

  // Method to get formatted start time for display
  String getFormattedStartTime() {
    return startTime != null ? DateFormat('HH:mm').format(startTime!) : 'N/A';
  }

  // Method to get formatted end time for display
  String getFormattedEndTime() {
    return endTime != null ? DateFormat('HH:mm').format(endTime!) : 'N/A';
  }
}
