import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_vibes_ui_v2/services/authService.dart';

class AddTestTripScreen extends StatefulWidget {
  const AddTestTripScreen({super.key});

  @override
  State<AddTestTripScreen> createState() => _AddTripNaState();
}

class _AddTripNaState extends State<AddTestTripScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _budController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<void> _saveNewTrip() async {
    String title = _titleController.text.trim();
    String description = _desController.text.trim();
    String people = _peopleController.text.trim();

    // Parse and format dates and budget
    String start = _startController.text.trim();
    String end = _endController.text.trim();
    double budget = double.tryParse(_budController.text.trim()) ?? 0.0;

    try {
      int userId = 2; // Example user ID; replace with actual dynamic value if available

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save trip: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
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
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  TextFormField(
                    controller: _budController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Trip budget'),
                  ),
                  TextFormField(
                    controller: _peopleController,
                    decoration: InputDecoration(labelText: 'Trip people'),
                  ),
                  TextFormField(
                    controller: _startController,
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Start date'),
                    onTap: () => _selectDate(context, _startController),
                  ),
                  TextFormField(
                    controller: _endController,
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'End date'),
                    onTap: () => _selectDate(context, _endController),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _saveNewTrip,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
