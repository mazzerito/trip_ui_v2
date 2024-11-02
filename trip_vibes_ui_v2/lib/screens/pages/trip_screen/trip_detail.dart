import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TripDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Details", 
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                'https://149990825.v2.pressablecdn.com/wp-content/uploads/2023/09/Paris1.jpg',
                height: screenWidth * 0.5,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            const _headerTripDetails(),

            const SizedBox( height: 15),
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Description",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vitae sapien viverra laoreet fusce cras nibh.",
                  style: TextStyle(color: Theme.of(context).textTheme.displayLarge?.color),
                ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.date_range, color: Theme.of(context).textTheme.displayLarge?.color),
                    const SizedBox(width: 8),
                    Text("15/02/2025",
                        style: TextStyle(fontWeight: FontWeight.bold,
                        color:Theme.of(context).textTheme.displayLarge?.color)),
                    const SizedBox(width: 16),
                    Icon(Icons.date_range, color: Theme.of(context).textTheme.displayLarge?.color),
                    const SizedBox(width: 8),
                    Text("25/02/2025",
                        style: TextStyle(fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.displayLarge?.color,)),
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
            const SizedBox(height: 10,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/booking');
            },
            style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary, 
                backgroundColor: Theme.of(context).colorScheme.primary, 
            ),
            child: const Text(
              'Booking',// Text color
            ),
          ),
          const SizedBox(width: 16), // Add some space between buttons
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/destination');
            },
            style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary, 
                backgroundColor: Theme.of(context).colorScheme.primary, 
            ),
            child: const Text(
              'Destination',// Text color
            ),
          ),
          const SizedBox(width: 16), // Add some space between buttons
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/activity');
            },
            style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary, 
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            child: const Text(
              'Activity',// Text color
            ),
          ),
                ],
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
        ),)
    );
  }
}

class _headerTripDetails extends StatelessWidget {
  const _headerTripDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Paris with family",
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  ),
                overflow: TextOverflow.ellipsis, // Truncates overflowed text
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.redAccent, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    "Paris, France",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.displayLarge?.color),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Column(
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
                "\$ 450.00",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,
                color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


