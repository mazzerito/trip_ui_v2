import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_vibes_ui_v2/services/authService.dart';
import '../../../models/activities.dart';

class EditActivityScreen extends StatefulWidget {
  final int destinationId;
  final Activities activity;

  EditActivityScreen({required this.destinationId, required this.activity});

  @override
  _EditActivityScreenState createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  final AuthService _activityService = AuthService();
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _costController;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.activity.activityTitle);
    _locationController = TextEditingController(text: widget.activity.location ?? '');
    _startTimeController = TextEditingController(
      text: widget.activity.startTime != null
          ? DateFormat('HH:mm').format(widget.activity.startTime!)
          : '',
    );
    _endTimeController = TextEditingController(
      text: widget.activity.endTime != null
          ? DateFormat('HH:mm').format(widget.activity.endTime!)
          : '',
    );
    _costController = TextEditingController(
      text: widget.activity.activityCost != null
          ? widget.activity.activityCost!.toStringAsFixed(2)
          : '',
    );
    _startTime = widget.activity.startTime != null
        ? TimeOfDay.fromDateTime(widget.activity.startTime!)
        : null;
    _endTime = widget.activity.endTime != null
        ? TimeOfDay.fromDateTime(widget.activity.endTime!)
        : null;
  }

  Future<void> _updateActivity() async {
    String title = _titleController.text.trim();
    String location = _locationController.text.trim();
    double? cost = double.tryParse(_costController.text.trim());

    try {
      await _activityService.editActivity(
        widget.activity.activityId!,
        title,
        location,
        _startTime != null
          ? '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}:00' // Ensure time format is HH:mm:ss
          : null,
      _endTime != null
          ? '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}:00' // Ensure time format is HH:mm:ss
          : null,
        cost,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Activity updated successfully')),
      );
      Navigator.pop(context, true); // Indicate a successful update
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update activity: $e')),
      );
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller, bool isStartTime) async {
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
        title: Text("Update Activity",
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
              _buildTimeField('Start Time', _startTimeController, () => _selectTime(context, _startTimeController, true)),
              _buildTimeField('End Time', _endTimeController, () => _selectTime(context, _endTimeController, false)),
              _buildTextField('Cost', _costController, inputType: TextInputType.number),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton(
                    context,
                    label: 'Cancel',
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildButton(
                    context,
                    label: 'Update',
                    color: Color(0xff5100F2),
                    textColor: Colors.white,
                    onPressed: _updateActivity,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {TextInputType inputType = TextInputType.text}) {
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

  Widget _buildTimeField(String label, TextEditingController controller, VoidCallback onTap) {
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
