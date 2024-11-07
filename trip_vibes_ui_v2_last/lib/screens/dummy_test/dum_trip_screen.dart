import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_vibes_ui_v2/models/user.dart';
import 'package:trip_vibes_ui_v2/screens/pages/trip_screen/edit_trip_screen.dart';
import 'package:trip_vibes_ui_v2/screens/pages/trip_screen/trip_detail.dart';
import 'package:trip_vibes_ui_v2/screens/pages/user_screen/profile_screen.dart';
import 'package:trip_vibes_ui_v2/services/authService.dart';
import '../../../models/trips.dart';
import 'package:intl/intl.dart';

class TripScreenDummy extends StatefulWidget {
    //final int tripId;

  //TripScreenDummy({required this.tripId});
  @override
  State<TripScreenDummy> createState() => _TripScreenDummyState();
}

class _TripScreenDummyState extends State<TripScreenDummy> {
  final AuthService _authService = AuthService();
  List<Trip> trips = [];

  List<Trip> filteredTrips = []; // New list to store filtered trips
  TextEditingController searchController = TextEditingController(); // Search controller

  //==================2
  String user_name = "null-value";
  String user_email = "null-value";
  int user_id = 0;
   User? user; // Add a User instance

  @override
  void initState() {
    super.initState();
      getCookieUser();
    // Fetch trips when the screen loads
    searchController.addListener(_filterTrips); // Add listener for real-time search
  }
  @override
  void dispose() {
    searchController.dispose(); // Dispose the controller
    super.dispose();
  }
  // Real-time filtering based on the search text
  void _filterTrips() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredTrips = trips.where((trip) {
        final title = trip.tripTitle.toLowerCase();
        return title.contains(query); // Filter by matching title
      }).toList();
    });
  }

//get trip by user id
  fetchTrips() async {
    // Retrieve trips from your service or database
    final fetchedTrips = await AuthService().getTripsByUserId(user_id);
    setState(() {
      print("Refresh trips.........");
      trips = fetchedTrips;
      filteredTrips = fetchedTrips; // Initialize with all trips
    });
  }
    // Future<void> _onProfile(User user) async {
    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ProfileScreen(
    //     userId: user.userId!,
    //     userEmail: user.userEmail.toString(),
    //     userName: user.userName,
    //   )));}
// Update the _onProfile function to use the user instance
Future<void> _onProfile() async {
    if (user != null && user!.userId != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
            userId: user!.userId!,
            userEmail: user!.userEmail ?? '', // Provide a fallback if null
            userName: user!.userName ?? '',   // Provide a fallback if null
          ),
        ),
      );
    } else {
      // Handle the case where the user is null or userId is not available
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data is not available.')),
      );
    }
  }


  Future<void> _onAddTrip() async {
    await Navigator.pushNamed(context, '/add-trip');
    fetchTrips(); // Refresh the trip list after adding a new trip
  }

  Future<void> _onEditTrip(Trip trip) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTripScreenTest(
        tripId: trip.tripId!,
        title: trip.tripTitle,
        description: trip.description ?? '',
        startDate: trip.startDate ?? DateTime.now(),  // Pass DateTime directly
        endDate: trip.endDate ?? DateTime.now(), 
        people: trip.tripPeople ?? '',
        budget: trip.tripBudget ?? 0.0,
        fectchTrip: fetchTrips,
        ))
    );
    // if (result == true) _fetchTrips(); // Refresh the list if a trip was edited
  }



  
  Future<void> _onDetailTrip(Trip trip) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripDetailScreen(
        tripId: trip.tripId!,
        title: trip.tripTitle,
        description: trip.description ?? '',
        startDate: trip.startDate ?? DateTime.now(),  // Pass DateTime directly
        endDate: trip.endDate ?? DateTime.now(),  
        people: trip.tripPeople ?? '',
        budget: trip.tripBudget ?? 0.0,
        fectchTrip: fetchTrips,
        ))
    );
    // if (result == true) _fetchTrips(); // Refresh the list if a trip was edited
  }

//Function Delete trip
  void _onDeleteTrip(BuildContext context,int tripId) async {
    
    final response = await _authService.deleteTrip(tripId);

    if (response['statusCode'] == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trip deleted successfully')),
      );
      //Navigator.of(context).pop(); // Go back to the previous screen
      fetchTrips();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete trip: ${response['body']['message']}')),
      );
    }
  }

  void _confirmDelete(BuildContext context, Trip trip) async {
    // Show a confirmation dialog before deleting
    final bool? deleteConfirmed = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this trip?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // Cancelled
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // Confirmed
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
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

//======================1. get user cookie
  getCookieUser() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //Return bool
      user_name = prefs.getString('name') ?? "null=value";
      user_email = prefs.getString('email') ?? "null=value";
      user_id = prefs.getInt("userId")?? 0;
      // print('>>> user_name' + user_name + " user_id = ${user_id}");
          // Create User object with the retrieved data
      user = User(userId: user_id, userEmail: user_email, userName: user_name);
      fetchTrips(); 
    }
    


  @override
  Widget build(BuildContext context) {
    //print(">> trips.length ${trips.length}");
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
              child: filteredTrips.isEmpty
                  ? Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/notfound.webp',
                            width: 200,
                            height: 200,
                          ),
                          const Text(
                            'No trips available. Begin your adventure by creating a new trip now! ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredTrips.length,
                      itemBuilder: (context, index) =>
                          _buildTripCard(context, filteredTrips[index]),
                    ),)
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
              'Welcome, $user_name 👋',
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
      controller: searchController, 
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
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(12),
            //   child: GestureDetector(
            //     onTap: () {
            //       Navigator.pushNamed(context, '/trip-detail');
            //     },
            //     child: Image.asset(
            //       'assets/images/logo.png',
            //       //trip.imageUrl,
            //       width: 100,
            //       height: 100,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: ()=> _onDetailTrip(trip),
                  //   onTap: () {
                  // Navigator.pushNamed(context, '/trip-detail');
                  //     },
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
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_month,
                              size: 14, 
                              color: Theme.of(context).textTheme.displayLarge?.color),
                          const SizedBox(width: 5),
                          Text(
                            formatter.format(trip.startDate!),
                            style: TextStyle(
                                fontSize: 12, 
                                color: Theme.of(context).textTheme.displayLarge?.color),
                          ), 
                          const SizedBox(width: 10,),// Space between start and end dates
                          Icon(Icons.arrow_right_alt, size: 14, color: Theme.of(context).textTheme.displayLarge?.color), // Optional icon to indicate range
                          const SizedBox(width: 5),
                          Text(
                            formatter.format(trip.endDate!),
                            style: TextStyle(
                                fontSize: 12, 
                                color: Theme.of(context).textTheme.displayLarge?.color),
                          ),
                        ],
                      ),
                    ]
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
                      onPressed: () => _onEditTrip(trip),
                      // onPressed: () {
                      //   _onEditTrip;
                      //   //Navigator.pushNamed(context, '/edit-trip');
                      // },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(context, trip),
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
                  // 'Alex Johnson',
                  user_name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18, 
                    fontWeight: FontWeight.bold
                    ),
                ),
                Text(
                  // 'alex.johnson@gmail.com',
                  user_email,
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
            onTap: _onProfile,
            // onTap: () {

            //   //Navigator.pushNamed(context, "/profile");
            // },
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
            onTap:() => _confirmLogout(context),
            // onTap: () {
            //   //Navigator.pushNamed(context, "/login");
            // },
          ),
        ],
      ),
    );

    
  }
}
void _logout(BuildContext context){
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
                  SizedBox(width: 5,),
                  Text("Confirm Logout", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  
                ],
              ),
              content: const Text("Do you want to log out?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    _logout(context); // Call the logout function
                  },
                  child: const Text("Logout", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
}

