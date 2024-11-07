
enum BookingStatus { confirmed, pending, cancelled }

class Bookings {
  final int? bookingId;
  final String? bookingTitle;
  final DateTime? bookingDate;
  final double? bookingCost;
  final BookingStatus? status;

  Bookings({
    required this.bookingId,
    required this.bookingTitle,
    this.bookingDate,
    this.bookingCost,
    this.status,
  });

  // Map JSON 'status' to BookingStatus enum
  factory Bookings.fromJson(Map<String, dynamic> json) {
    return Bookings(
      bookingId: json['booking_id'],
      bookingTitle: json['booking_title'],
      bookingCost: (json['booking_cost'] as num?)?.toDouble(),
      bookingDate: json['booking_date'] != null
          ? DateTime.parse(json['booking_date'])
          : null,
      status: _stringToStatus(json['status']),
    );
  }

  // Convert BookingStatus enum to string for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'booking_title': bookingTitle,
      'booking_cost': bookingCost,
      'booking_date': bookingDate?.toIso8601String(),
      'status': _statusToString(status),
    };
  }

  // Helper method to convert JSON string to BookingStatus enum
  static BookingStatus? _stringToStatus(String? status) {
    switch (status) {
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'pending':
        return BookingStatus.pending;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        return null;
    }
  }

  // Helper method to convert BookingStatus enum to string for JSON
  static String? _statusToString(BookingStatus? status) {
    switch (status) {
      case BookingStatus.confirmed:
        return 'confirmed';
      case BookingStatus.pending:
        return 'pending';
      case BookingStatus.cancelled:
        return 'cancelled';
      default:
        return null;
    }
  }
}

// enum BookingsStatus { confirmed, pending, cancelled }

// class Bookings {
//   final int? bookingId;
//   final String? bookingTitle;
//   final DateTime? bookingDate;
//   final double? bookingCost;
//   final BookingsStatus? status;
//   //final String? status;

//   Bookings({
//     required this.bookingId,
//     required this.bookingTitle,
//     this.bookingDate,
//     this.bookingCost,
//     this.status,
//   });

//     factory Bookings.fromJson(Map<String, dynamic> json) {
//     return Bookings(
//       bookingId: json['booking_id'],
//       bookingTitle: json['booking_title'],
//       bookingCost: (json['booking_cost'] as num?)?.toDouble(), 
//       bookingDate: DateTime.parse(json['booking_date']),
//       status: _stringToStatus(json['status']),
//     );
//   }

//   Map<String, dynamic> toJson(){
//     return {
//       'booking_id': bookingId,
//       'booking_title': bookingTitle,
//       'booking_cost': bookingCost,
//       'booking_date': bookingDate?.toIso8601String(),
//       'status': _statusToString(status),
      
//     };
//   }


//     // Helper method to convert BookingsStatus enum to string for JSON
//   static String? _statusToString(BookingsStatus? status) {
//     switch (status) {
//       case BookingsStatus.confirmed:
//         return 'confirmed';
//       case BookingsStatus.pending:
//         return 'pending';
//       case BookingsStatus.cancelled:
//         return 'cancelled';
//       default:
//         return null;
//     }
//   }
// }