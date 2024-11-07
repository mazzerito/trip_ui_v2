import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_vibes_ui_v2/screens/pages/destination_screen/destination_screen.dart';

import '../../../models/destinations.dart';
import '../../../models/trips.dart';
import '../../../services/authService.dart';
import '../activitiy_screen/activity_screen.dart';
import '../booking_screen/booking_screen.dart';

class TripDetailScreen extends StatefulWidget {
  final int tripId;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String people;
  final double budget;
  Function fectchTrip;

  TripDetailScreen({
    //required this.userId,
    required this.tripId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.people,
    required this.budget,
    required this.fectchTrip,
  });
  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
    final AuthService _authService = AuthService();
  Destination? firstDestination;

@override
  void initState() {
    super.initState();
    _fetchFirstDestination();
  }

Future<void> _fetchFirstDestination() async {
    try {
      List<Destination> destinations = await _authService.getDestinationsByTripId(widget.tripId);
      if (destinations.isNotEmpty) {
        setState(() {
          firstDestination = destinations.first; // Get the first destination
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load destinations: $e')),
      );
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final formatter = DateFormat('dd/MM/yyyy');
    String formatDate(DateTime date) {
      return DateFormat('dd/MM/yyyy').format(date); // Customize the format here
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Details",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  firstDestination?.destinationImage ?? 'https://static.vecteezy.com/system/resources/previews/002/967/753/large_2x/traveling-vacation-design-illustration-with-cartoon-style-free-vector.jpg',
                  height: screenWidth * 0.5,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // "Paris with family",
                          widget.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Truncates overflowed text
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.redAccent, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              firstDestination?.destinationName ?? 'Location not available',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.color),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Budget',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          //"\$ 450.00",
                          "\$ ${widget.budget.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.description,
                        style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.color),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Tripmates",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.people,
                        style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.color),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.date_range,
                          color:
                              Theme.of(context).textTheme.displayLarge?.color),
                      const SizedBox(width: 8),
                      Text(

                          //"15/02/2025",
                          //widget.startDate,
                          formatDate(widget.startDate),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.color)),
                      const SizedBox(width: 16),
                      Icon(Icons.date_range,
                          color:
                              Theme.of(context).textTheme.displayLarge?.color),
                      const SizedBox(width: 8),
                      Text(
                          //"25/02/2025",
                          //widget.endDate,
                          formatDate(widget.endDate),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.displayLarge?.color,
                          )),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "About Trip Plan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: MediaQuery.of(context).size.width, // Full screen width
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, '/booking');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingScreen(
                                tripId: widget.tripId,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                        ),
                        child: const Text(
                          'Booking', // Text color
                        ),
                      ),
                      //const SizedBox(width: 20), // Add some space between buttons
                      ElevatedButton(
                        onPressed: () {
                          //Navigator.pushNamed(context, '/destination');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DestinationsScreen(
                                tripId: widget.tripId,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                        ),
                        child: const Text(
                          'Destination', // Text color
                        ),
                      ),
                      const SizedBox(width: 16), // Add some space between buttons
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.pushNamed(context, '/activity');
                      //     // Navigator.push(
                      //     //   context,
                      //     //   MaterialPageRoute(
                      //     //     builder: (context) => ActivityScreen(
                      //     //       destinationId: widget
                      //     //           .tripId, // Assuming destinationId is derived from tripId
                      //     //     ),
                      //     //   ),
                      //     // );
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     foregroundColor:
                      //         Theme.of(context).colorScheme.onPrimary,
                      //     backgroundColor: Theme.of(context).colorScheme.primary,
                      //   ),
                      //   child: const Text(
                      //     'Activity', // Text color
                      //   ),
                      // ),
                    ],
                  ),
                ),
              )
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
          ),
        ));
  }
}
