import 'package:flutter/material.dart';
import 'package:trip_vibes_ui_v2/services/authService.dart';

class AddTtripNa extends StatefulWidget {
  const AddTtripNa({super.key});

  @override
  State<AddTtripNa> createState() => _AddTtripNaState();
}

class _AddTtripNaState extends State<AddTtripNa> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _budController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final AuthService _authService = AuthService();

Future<void> _saveNewTrip() async {
  String title = _titleController.text;
  String description = _desController.text;
  String budget = _budController.text;
  String people = _peopleController.text;
  String start = _startController.text;
  String end = _endController.text;

  try {
    // Replace 'userId' with the actual user ID value you have available
    int userId = 2; // For example, this could come from a logged-in user’s data

    await _authService.createNewTrip(
      userId,
      title,
      description,
      end,
      start,
      people,
      budget,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Trip saved successfully')),
    );

    Navigator.pushNamed(context, '/trip');
  } catch (e) {
    // Handle any errors here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save trip: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add trip'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Add trip'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Trip title'),
                  ),
                  TextFormField(
                    controller: _desController,
                    decoration: InputDecoration(labelText: 'description'),
                  ),
                  TextFormField(
                    controller: _budController,
                    decoration: InputDecoration(labelText: 'trip_budget'),
                  ),
                  TextFormField(
                    controller: _peopleController,
                    decoration: InputDecoration(labelText: 'trip_people'),
                  ),
                  TextFormField(
                    controller: _startController,
                    decoration: InputDecoration(labelText: 'start_date'),
                  ),
                  TextFormField(
                    controller: _endController,
                    decoration: InputDecoration(labelText: 'end_date'),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed:_saveNewTrip,
              child: Text('Save'))
          ],
          
        ),
      ),
    );
  }
}