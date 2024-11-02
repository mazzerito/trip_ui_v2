import 'package:flutter/material.dart';
import '../../../models/trip_model.dart';
import 'package:intl/intl.dart';

class TripScreen extends StatefulWidget {
  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  
  @override
  Widget build(BuildContext context) {
        return Scaffold(
      //backgroundColor: const Color(0xFFF3F4F9),
      endDrawer: _buildEndDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildSearchField(),
            const SizedBox(height: 20),
            _buildTripListHeader(context),
            const SizedBox(height: 10),
            const Divider(height: 2),
            Expanded(
              child: ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, index) =>
                    _buildTripCard(context, trips[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Alex 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "What's new for today?",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Builder(builder: (context) {
          return GestureDetector(
              onTap: () {
                // Navigator.pushNamed(context,"/profile");
                Scaffold.of(context).openEndDrawer();
              },
              child: Container(
                width: 45, // Adjust width and height to control size
                height: 45,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(
                      10), // Change 10 to your desired radius
                ),
                child: Icon(
                  Icons.menu,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 26,
                ),
              ));
        }),
        //_buildEndDrawer(context),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        hintText: 'Start searching here...',
          hintStyle: const TextStyle(
        color: Colors.grey, 
      ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
              color: Colors.grey), // Change this to your desired color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
              color: Color(0xff5100F2),
              width: 2.0), // Color and width for focused state
        ),
      ),
    );
  }

  Widget _buildTripListHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'My Trip Plan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add-trip');
          },
          child: const Icon(
            Icons.add,
          ),
          style: ElevatedButton.styleFrom(
                                foregroundColor: Theme.of(context).colorScheme.onPrimary, 
                                backgroundColor: Theme.of(context).colorScheme.primary,
            shape: const CircleBorder(),
            elevation: 5,
          ),
        ),
      ],
    );
  }

  Widget _buildTripCard(BuildContext context, Trip trip) {
    final formatter = DateFormat('dd/MM/yyyy');
    return Card(
      elevation: 3,
      shadowColor: Theme.of(context).textTheme.displayLarge?.color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/trip-detail');
                },
                child: Image.network(
                  trip.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${trip.cost.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 14, 
                              color: Theme.of(context).textTheme.displayLarge?.color),
                          Text(
                            "${formatter.format(trip.startDate)}",
                            style: TextStyle(
                                fontSize: 12, 
                                color: Theme.of(context).textTheme.displayLarge?.color),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_month,
                              size: 14, 
                              color: Theme.of(context).textTheme.displayLarge?.color),
                          Text(
                            "${formatter.format(trip.endDate)}",
                            style: TextStyle(
                                fontSize: 12, 
                                color: Theme.of(context).textTheme.displayLarge?.color),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.green),
                      onPressed: () {
                        Navigator.pushNamed(context, '/edit-trip');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEndDrawer(BuildContext context) {
    return Drawer(
      elevation: 16,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
            radius: 40,
            backgroundColor: Colors.purple.shade200,
            child: const CircleAvatar(
              radius: 36,
              backgroundImage: AssetImage('assets/images/panda.jpg'),
            ),),
                const SizedBox(height: 8),
                Text(
                  'Alex Johnson',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18, 
                    fontWeight: FontWeight.bold
                    ),
                ),
                Text(
                  'alex.johnson@gmail.com',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person, 
              color: Theme.of(context).primaryColor,
              ),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, "/profile");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.notifications, 
              color: Theme.of(context).primaryColor,
              ),
            title: const Text('Notifications'),
            onTap: () {
              //Navigator.pushNamed(context, "/notifications");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings, 
              color: Theme.of(context).primaryColor,
              ),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, "/settings");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info, 
              color: Theme.of(context).primaryColor,
              ),
            title: const Text('About Us'),
            onTap: () {
              //Navigator.pushNamed(context, "/about");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.contact_mail, 
              color: Theme.of(context).primaryColor,
              ),
            title: const Text('Contact Us'),
            onTap: () {
              //Navigator.pushNamed(context, "/contact");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.feedback, 
              color: Theme.of(context).primaryColor,
              ),
            title: const Text('Feedback'),
            onTap: () {
              //Navigator.pushNamed(context, "/feedback");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout, 
              color: Theme.of(context).primaryColor,
              ),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }
}
