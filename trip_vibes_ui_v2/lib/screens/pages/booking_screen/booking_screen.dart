import 'package:flutter/material.dart';
import '../../../models/booking.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatelessWidget {
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
              child: ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) =>
                    _buildBookingCard(context, bookings[index]),
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

  Widget _buildBookingCard(BuildContext context, Booking booking) {
    final formatter = DateFormat('dd/MM/yyyy');
    return Card(
      elevation: 3,
      shadowColor: Theme.of(context).textTheme.displayLarge?.color,
      //color: Colors.grey[300],
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
                    booking.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 14, color: Theme.of(context).textTheme.displayLarge?.color,),
                      const SizedBox(width: 4),
                      Text(
                        "${formatter.format(booking.startDate)} - ${formatter.format(booking.endDate)}",
                        style:
                          TextStyle(fontSize: 14, color: Theme.of(context).textTheme.displayLarge?.color,),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "\$${booking.cost.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildConfirmButton(booking.status),
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
