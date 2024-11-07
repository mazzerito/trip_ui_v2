enum BookingStatus { confirmed, pending, cancelled }

class Booking {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final double cost;
  final BookingStatus status;

  Booking({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.cost,
    required this.status,
  });
}

final List<Booking> bookings = [
  Booking(
    title: 'Millennium Hotel',
    startDate: DateTime(2025, 2, 15),
    endDate: DateTime(2025, 2, 25),
    cost: 450.0,
    status: BookingStatus.confirmed, // Updated
  ),
  Booking(
    title: '3 Cars',
    startDate: DateTime(2025, 2, 15),
    endDate: DateTime(2025, 2, 25),
    cost: 150.0,
    status: BookingStatus.pending, // Updated
  ),
  Booking(
    title: 'Restaurant for Dinner',
    startDate: DateTime(2025, 2, 15),
    endDate: DateTime(2025, 2, 25),
    cost: 200.0,
    status: BookingStatus.cancelled, // Example with "Cancelled" status
  ),
  Booking(
    title: 'Camp',
    startDate: DateTime(2025, 2, 15),
    endDate: DateTime(2025, 2, 25),
    cost: 58.0,
    status: BookingStatus.pending,
  ),
  Booking(
    title: 'Boat',
    startDate: DateTime(2025, 2, 15),
    endDate: DateTime(2025, 2, 25),
    cost: 180.0,
    status: BookingStatus.confirmed,
  ),
];
