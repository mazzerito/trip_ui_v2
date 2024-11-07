import 'package:flutter/material.dart';
import 'package:trip_vibes_ui_v2/models/activities.dart';
//import 'package:trip_vibes_ui_v2/models/booking.dart';
import 'package:trip_vibes_ui_v2/models/bookings.dart';
//import '../../../models/booking.dart';
import 'package:intl/intl.dart';
import '../../services/authService.dart';

class BookingScreenTest extends StatefulWidget {
  // final int tripId; // Accepts tripId as a parameter

  // BookingScreenTest({required this.tripId});
  
  @override
  State<BookingScreenTest> createState() => _BookingScreenTestState();
}

class _BookingScreenTestState extends State<BookingScreenTest> {
  final AuthService _authService = AuthService();
  List<Activities> bookingss = [];
  //int tripId = 11;


  @override
  void initState() {
    super.initState();
      fetchAllBookings();
    // Fetch trips when the screen loads
  }
//get booking by trip Id
  // fetchBookings() async {
  //   // Retrieve trips from your service or database
  //   final fetchedBookings = await AuthService().getBookingByTripId(widget.tripId);
  //   setState(() {
  //     print("Refresh bookings.........");
  //     bookingss = fetchedBookings;
  //   });
  // }
//get all booking
  fetchAllBookings() async {
    // Retrieve trips from your service or database
    final fetchedBookings = await AuthService().getAllActivities();
    setState(() {
      print("Refresh all bookings.........");
      bookingss = fetchedBookings;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking", 
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, 
            color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      //backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'All Bookings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    // minimumSize:
                    //     Size(50, 40), // Set the width and height of the button
                    shape: CircleBorder(),
                    elevation: 5,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 2),
            const SizedBox(height: 10),
            Expanded(
              child: bookingss.isEmpty
                  ? Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/notfound.webp',
                            width: 200,
                            height: 200,
                          ),
                          const Text(
                            'No bookings available! ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  :ListView.builder(
                itemCount: bookingss.length,
                itemBuilder: (context, index) =>
                    _buildBookingCard(context, bookingss[index]),
              ),
              
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 1.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/trip');
          },
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          child: Icon(Icons.home, color: Theme.of(context).primaryColor),
        ),)
    );
  }

Widget _buildBookingCard(BuildContext context, Activities booking) {
  final formatter = DateFormat('dd/MM/yyyy');
  String formattedDate = booking.startTime != null 
    ? formatter.format(booking.startTime!) 
    : 'No date available';

  return Card(
    elevation: 3,
    shadowColor: Theme.of(context).textTheme.displayLarge?.color,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.activityTitle.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Theme.of(context).textTheme.displayLarge?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      //formattedDate,
                      'Hmmmm',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.displayLarge?.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "\$${booking.activityCost?.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    //_buildConfirmButton(booking.status ?? BookingStatus.pending), // Pass default if null
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.green),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


Widget _buildConfirmButton(BookingStatus status) {
  Color backgroundColor;
  Color textColor;
  String label;

  switch (status) {
    case BookingStatus.confirmed:
      backgroundColor = Colors.greenAccent.shade100;
      textColor = Colors.green;
      label = 'Confirm';
      break;
    case BookingStatus.pending:
      backgroundColor = Colors.yellowAccent.shade100;
      textColor = Colors.yellow.shade900;
      label = 'Pending';
      break;
    case BookingStatus.cancelled:
      backgroundColor = Colors.red.shade200;
      textColor = Colors.red.shade900;
      label = 'Cancel';
      break;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 12,
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}




}
