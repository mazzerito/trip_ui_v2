import 'package:flutter/material.dart';
import 'package:trip_vibes_ui_v2/models/activities.dart';
import 'package:intl/intl.dart';
import 'package:trip_vibes_ui_v2/screens/pages/activitiy_screen/add_activity_screen.dart';
import 'package:trip_vibes_ui_v2/screens/pages/activitiy_screen/edit_activity_screen.dart';
import '../../../services/authService.dart';

class ActivityScreen extends StatefulWidget {
    final int destinationId; 
    //Function fetchedActivity;// Add this parameter

  ActivityScreen({
    required this.destinationId,
    //required this.fetchedActivity,
    }); // Update constructor
  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final AuthService _authService = AuthService();
  List<Activities> activity = [];
  bool isLoading = true;
  //int destinationId=5;

  @override
  void initState() {
    super.initState();
    fetchActivities();
  }

  // Get all activities
  fetchActivities() async {
    try {
      final fetchedActivity = await _authService.getActivityByDestinationId(widget.destinationId);
      setState(() {
        activity = fetchedActivity;
        isLoading = false;
        print("Refresh acvitivity.........");
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching activities: $e");
      // Optionally show a message to the user
    }
  }
  // fetchAllActivities() async {
  //   try {
  //     final fetchedActivity = await _authService.getAllActivities();
  //     setState(() {
  //       activity = fetchedActivity;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print("Error fetching activities: $e");
  //     // Optionally show a message to the user
  //   }
  // }

  // Navigate to AddActivityScreen
  void addActivity(BuildContext context, int destinationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddActivityScreen(destinationId: destinationId),
      ),
    ).then((value) {
      if (value == true) {
        fetchActivities(); // Refresh the list after adding an activity
      }
    });
  }

  // Navigate to EditActivityScreen
  void editActivity(BuildContext context, int destinationId, Activities activity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditActivityScreen(destinationId: destinationId, activity: activity),
      ),
    ).then((value) {
      if (value == true) {
        fetchActivities(); // Refresh the list after editing an activity
      }
    });
  }

  // Delete an activity with confirmation dialog
  void deleteActivity(BuildContext context, int activityId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  const Row(
          children: [
            Icon(Icons.warning),
            Text('Confirm Delete',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          ],
        ),
          content: const Text('Are you sure you want to delete this activity?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  await _authService.deleteActivity(activityId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Activity deleted successfully')),
                  );
                  fetchActivities(); // Refresh the list after deletion
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete activity: $e')),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
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
          "Activity",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'All Activities',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () => addActivity(context, widget.destinationId),
                        child: const Icon(Icons.add),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          shape: const CircleBorder(),
                          elevation: 5,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 2),
                  const SizedBox(height: 10),
                  Expanded(
                    child: activity.isEmpty
                        ? Center(
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/notfound.webp',
                                  width: 200,
                                  height: 200,
                                ),
                                const Text(
                                  'No Activity available!',
                                  style: TextStyle(fontSize: 18, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: activity.length,
                            itemBuilder: (context, index) =>
                                _buildBookingCard(context, activity[index]),
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

  // Card widget for each activity
  Widget _buildBookingCard(BuildContext context, Activities activity) {
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
                    activity.activityTitle,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        "${activity.getFormattedStartTime()} - ${activity.getFormattedEndTime()}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).textTheme.displayLarge?.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.redAccent, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        activity.location ?? "No Location",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.displayLarge?.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const SizedBox(width: 5),
                      Text(
                        "Cost: \$${activity.activityCost?.toStringAsFixed(2) ?? 'N/A'}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteActivity(context, activity.activityId!),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.green),
                  onPressed: () => editActivity(context, widget.destinationId, activity),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
