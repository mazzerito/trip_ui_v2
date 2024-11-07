import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_vibes_ui_v2/models/user.dart';
import 'package:trip_vibes_ui_v2/screens/pages/trip_screen/edit_trip_screen.dart';
import 'package:trip_vibes_ui_v2/screens/pages/trip_screen/trip_detail.dart';
import 'package:trip_vibes_ui_v2/screens/pages/user_screen/profile_screen.dart';
import 'package:trip_vibes_ui_v2/services/authService.dart';
import 'package:intl/intl.dart';
import '../../../models/trips.dart';

class TripScreen extends StatefulWidget {
  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  final AuthService _authService = AuthService();
  List<Trip> trips = [];
  List<Trip> filteredTrips = [];
  TextEditingController searchController = TextEditingController();

  String userName = 'Loading...';
  String userEmail = 'Loading...';
  String? profileImagePath;
  int userId = 0;
  User? user;
    bool isLoading = false; // Add this line to declare isLoading

  @override
  void initState() {
    super.initState();
    //getUserDataFromPreferences();
    getUserDataFromServer();
    searchController.addListener(_filterTrips);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Future<void> getUserDataFromPreferences() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     userName = prefs.getString('name') ?? 'Guest';
  //     userEmail = prefs.getString('email') ?? 'guest@example.com';
  //     userId = prefs.getInt('userId') ?? 0;
  //     //profileImagePath = prefs.getString('profileImagePath');
  //     user = User(userId: userId, userEmail: userEmail, userName: userName);
  //   });
  //   fetchTrips();
  // }
  
  
Future<void> getUserDataFromServer() async {
  setState(() {
    isLoading = true;
  });

  // Make sure userId is set before making the request
  if (userId == 0) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId') ?? 0;
    });
  }

  if (userId != 0) { // Check that userId is valid
    final userData = await AuthService().getUserData(userId);
    if (userData != null) {
      setState(() {
        userName = userData['user_name'] ?? 'Guest';
        userEmail = userData['email'] ?? 'guest@example.com';
        profileImagePath = userData['profile_picture'];
        user = User(userId: userId, userEmail: userEmail, userName: userName);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Error fetching user data');
    }
  } else {
    setState(() {
      isLoading = false;
    });
    print('User ID is not set');
  }

  // Fetch trips after loading user data
  fetchTrips();
}

  void _filterTrips() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredTrips = trips.where((trip) {
        final title = trip.tripTitle.toLowerCase();
        return title.contains(query);
      }).toList();
    });
  }

  Future<void> fetchTrips() async {
    final fetchedTrips = await _authService.getTripsByUserId(userId);
    setState(() {
      trips = fetchedTrips;
      filteredTrips = fetchedTrips;
    });
  }

  Future<void> _onDetailTrip(Trip trip) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripDetailScreen(
          tripId: trip.tripId!,
          title: trip.tripTitle,
          description: trip.description ?? '',
          startDate: trip.startDate ?? DateTime.now(),
          endDate: trip.endDate ?? DateTime.now(),
          people: trip.tripPeople ?? '',
          budget: trip.tripBudget ?? 0.0,
          fectchTrip: fetchTrips, // Refreshes the trip list after returning
        ),
      ),
    );
  }

  // Method to navigate to the Edit Trip screen and handle the result
  Future<void> _onEditTrip(Trip trip) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTripScreenTest(
          tripId: trip.tripId!,
          title: trip.tripTitle,
          description: trip.description ?? '',
          startDate: trip.startDate ?? DateTime.now(),
          endDate: trip.endDate ?? DateTime.now(),
          people: trip.tripPeople ?? '',
          budget: trip.tripBudget ?? 0.0,
          fectchTrip: fetchTrips, // Callback to refresh trip list
        ),
      ),
    );

    // Refresh the list of trips if the edit was successful
    if (result == true) {
      fetchTrips();
    }
  }

// Method to confirm and handle trip deletion
  void _confirmDelete(BuildContext context, Trip trip) async {
    final bool? deleteConfirmed = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.warning),
              SizedBox(width: 8),
              Text("Confirm Delete",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
          content: const Text("Are you sure you want to delete this trip?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // Cancelled
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // Confirmed
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    // If the user confirmed deletion, call the delete function
    if (deleteConfirmed == true) {
      _onDeleteTrip(context, trip.tripId!);
    }
  }

// Method to handle the deletion of a trip
  void _onDeleteTrip(BuildContext context, int tripId) async {
    final response = await _authService.deleteTrip(tripId);

    if (response['statusCode'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip deleted successfully')),
      );
      fetchTrips(); // Refresh the list of trips after deletion
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to delete trip: ${response['body']['message']}')),
      );
    }
  }


  Future<void> _onProfile() async {
    if (user != null && user!.userId != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
            userId: user!.userId!,
            userEmail: user!.userEmail ?? '',
            userName: user!.userName ?? '',
          ),
        ),
      );

      // Check if profile was updated
      if (result == true) {
        getUserDataFromServer(); // Refresh user data
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data is not available.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: _buildEndDrawer(context),
      body:  isLoading
        ? Center(child: CircularProgressIndicator())
        :Padding(
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
              child: filteredTrips.isEmpty
                  ? Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/notfound.webp',
                              width: 200,
                              height: 200,
                              fit: BoxFit.contain, 
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'No trips available. Begin your adventure by creating a new trip now!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredTrips.length,
                      itemBuilder: (context, index) =>
                          _buildTripCard(context, filteredTrips[index]),
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
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome,✨$userName',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
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
        ),
        Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openEndDrawer();
              },
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.menu,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 26,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        hintText: 'Start searching here...',
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Color(0xff5100F2), width: 2.0),
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
          onPressed: () => Navigator.pushNamed(context, '/add-trip'),
          child: const Icon(Icons.add),
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
    return GestureDetector(
      onTap: ()=> _onDetailTrip(trip),
      child: Card(
        elevation: 3,
        shadowColor: Theme.of(context).textTheme.displayLarge?.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _onDetailTrip(trip),
                      child: Text(
                        trip.tripTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Budget: \$${trip.tripBudget?.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 14,
                          color: Theme.of(context).textTheme.displayLarge?.color,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          formatter.format(trip.startDate!),
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).textTheme.displayLarge?.color,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.arrow_right_alt,
                          size: 14,
                          color: Theme.of(context).textTheme.displayLarge?.color,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          formatter.format(trip.endDate!),
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).textTheme.displayLarge?.color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.green),
                    onPressed: () => _onEditTrip(trip),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(context, trip),
                  ),
                ],
              ),
            ],
          ),
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
                  child: CircleAvatar(
                    radius: 36,
                    backgroundImage: profileImagePath?.isNotEmpty == true
                        ? NetworkImage(
                            'http://192.168.44.1:4000/api/public/images/users/$profileImagePath')
                        : const AssetImage('assets/images/panda.jpg'),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  userName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userEmail,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Theme.of(context).primaryColor),
            title: const Text('Profile'),
            onTap: _onProfile,
          ),
          ListTile(
            leading: Icon(Icons.notifications,
                color: Theme.of(context).primaryColor),
            title: const Text('Notifications'),
            onTap: () {},
          ),
          ListTile(
            leading:
                Icon(Icons.settings, color: Theme.of(context).primaryColor),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, "/settings");
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Theme.of(context).primaryColor),
            title: const Text('About Us'),
            onTap: () {},
          ),
          ListTile(
            leading:
                Icon(Icons.contact_mail, color: Theme.of(context).primaryColor),
            title: const Text('Contact Us'),
            onTap: () {},
          ),
          ListTile(
            leading:
                Icon(Icons.feedback, color: Theme.of(context).primaryColor),
            title: const Text('Feedback'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Theme.of(context).primaryColor),
            title: const Text('Logout'),
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.warning),
              SizedBox(width: 5),
              Text("Confirm Logout",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20 )),
            ],
          ),
          content: const Text("Do you want to log out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context);
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
