import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_vibes_ui_v2/screens/pages/destination_screen/add_destination_screen.dart';
import 'package:trip_vibes_ui_v2/screens/pages/destination_screen/edit_destination_screen.dart';
import '../../../models/destinations.dart';
import '../../../services/authService.dart';
import '../activitiy_screen/activity_screen.dart';

class DestinationsScreen extends StatefulWidget {
  final int tripId; // Accepts tripId as a parameter
  DestinationsScreen({required this.tripId});

  @override
  State<DestinationsScreen> createState() => _DestinationsScreenState();
}

class _DestinationsScreenState extends State<DestinationsScreen> {
  final AuthService _authService = AuthService();
  List<Destination> destinations = [];
  

  @override
  void initState() {
    super.initState();
    fetchDestinations();
  }

  // Function to fetch destinations by trip ID
  Future<void> fetchDestinations() async {
    try {
      final fetchedDestinations = await _authService.getDestinationsByTripId(widget.tripId);
      setState(() {
        print("Refresh destination.........");
        destinations = fetchedDestinations;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load destinations: $e')),
      );
    }
  }

  // Function to add a new destination
  void addDestination(BuildContext context, int tripId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDestinationScreen(tripId: tripId),
      ),
    ).then((value) {
      if (value == true) {
        fetchDestinations(); // Refresh the list after adding a destination
      }
    });
  }

  // Function to edit an existing destination
  void editDestination(BuildContext context, Destination destination) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDestinationScreen(
          tripId: widget.tripId, 
          destination: destination,
          ),
      ),
    ).then((value) {
      if (value == true) {
        fetchDestinations(); // Refresh the list after editing a destination
      }
    });
  }

  // Function to show delete confirmation and delete a destination
  void deleteDestination(BuildContext context, int destinationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
          children: [
            Icon(Icons.warning),
            Text('Confirm Delete',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          ],
        ),
          content: Text('Are you sure you want to delete this destination?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  await _authService.deleteDestination(destinationId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Destination deleted successfully')),
                  );
                  fetchDestinations(); // Refresh the list after deletion
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete destination: $e')),
                  );
                }
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Destination",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'All Destinations',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () => addDestination(context, widget.tripId),
                  child: const Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: CircleBorder(),
                    elevation: 5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 2),
            const SizedBox(height: 20),
            Expanded(
              child: destinations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/notfound.webp',
                            width: 200,
                            height: 200,
                          ),
                          const Text(
                            'No destinations available!',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemCount: destinations.length,
                      itemBuilder: (context, index) {
                        final destination = destinations[index];
                        return _buildDestinationCard(context, destination);
                      },
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
        ),
      ),
    );
  }

  Widget _buildDestinationCard(BuildContext context, Destination destination) {
    final formatter = DateFormat('dd/MM/yyyy');
    String formattedStartDate = destination.startDate != null
        ? formatter.format(destination.startDate!)
        : 'No start date available';
    String formattedEndDate = destination.endDate != null
        ? formatter.format(destination.endDate!)
        : 'No end date available';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Theme.of(context).textTheme.displayLarge?.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              destination.destinationImage ?? 'https://via.placeholder.com/150',
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.orange, size: 16),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        destination.destinationName,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                color: Theme.of(context).textTheme.displayLarge?.color, size: 16),
                            SizedBox(width: 4),
                            Text(formattedStartDate),
                          ],
                        ),
                        Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Theme.of(context).textTheme.displayLarge?.color, size: 16),
                        SizedBox(width: 4),
                        Text(formattedEndDate),
                      ],
                    ),
                      ],
                    ),
                    ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityScreen(destinationId: destination.destinationId!),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text('Activity'),
                ),

                  ],
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        deleteDestination(context, destination.destinationId!);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.green),
                      onPressed: () => editDestination(context, destination),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
