import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_vibes_ui_v2/services/authService.dart';
import '../../../models/activities.dart';

class AddActivityScreen extends StatefulWidget {
  final int destinationId; // Accepts destinationId as a parameter

  AddActivityScreen({required this.destinationId});

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final AuthService _activityService = AuthService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  Future<void> _saveActivity() async {
    String title = _titleController.text.trim();
    String location = _locationController.text.trim();
    double? cost = double.tryParse(_costController.text.trim());

    try {
      Activities newActivity = Activities(
        activityTitle: title,
        location: location,
        startTime: _startTime != null
            ? DateTime(0, 0, 0, _startTime!.hour, _startTime!.minute)
            : null,
        endTime: _endTime != null
            ? DateTime(0, 0, 0, _endTime!.hour, _endTime!.minute)
            : null,
        activityCost: cost,
      );

      await _activityService.addActivity(widget.destinationId, newActivity);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Activity added successfully')),
      );
      Navigator.pop(context, true); // Indicate a successful add
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add activity: $e')),
      );
    }
  }

  Future<void> _selectTime(BuildContext context,
      TextEditingController controller, bool isStartTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = pickedTime;
          controller.text = pickedTime.format(context);
        } else {
          _endTime = pickedTime;
          controller.text = pickedTime.format(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Activity",
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Activity Title', _titleController),
              _buildTextField('Location', _locationController),
              _buildTimeField('Start Time', _startTimeController,
                  () => _selectTime(context, _startTimeController, true)),
              _buildTimeField('End Time', _endTimeController,
                  () => _selectTime(context, _endTimeController, false)),
              _buildTextField('Cost', _costController,
                  inputType: TextInputType.number),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton(
                    context,
                    label: 'Cancel',
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                  _buildButton(
                    context,
                    label: 'Save',
                    color: Color(0xff5100F2),
                    textColor: Colors.white,
                    onPressed: _saveActivity,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller,
      {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }

  Widget _buildTimeField(
      String label, TextEditingController controller, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          filled: true,
          fillColor: Colors.grey.shade100,
          suffixIcon: Icon(Icons.access_time),
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
