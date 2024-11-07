import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_vibes_ui_v2/models/destinations.dart';
import 'package:trip_vibes_ui_v2/services/authService.dart';

class AddDestinationScreen extends StatefulWidget {
  final int tripId;

  AddDestinationScreen({required this.tripId});

  @override
  _AddDestinationScreenState createState() => _AddDestinationScreenState();
}

class _AddDestinationScreenState extends State<AddDestinationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final AuthService _destinationService = AuthService();
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _saveDestination() async {
    String name = _nameController.text.trim();
    String imageUrl = _imageUrlController.text.trim();
    String startDate = _startDateController.text.trim();
    String endDate = _endDateController.text.trim();

    try {
      Destination newDestination = Destination(
        destinationName: name,
        startDate: _startDate,
        endDate: _endDate,
        destinationImage: imageUrl.isEmpty ? null : imageUrl,
      );

      await _destinationService.addDestination(widget.tripId, newDestination);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Destination added successfully')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add destination: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
          _startDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        } else {
          _endDate = pickedDate;
          _endDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Destination",
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Destination Name', _nameController),
              _buildDateField(
                'Start Date',
                _startDateController,
                () => _selectDate(context, _startDateController, true),
              ),
              _buildDateField(
                'End Date',
                _endDateController,
                () => _selectDate(context, _endDateController, false),
              ),
              _buildTextField('Image URL', _imageUrlController),
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
                    label: 'Save',
                    color: Color(0xff5100F2),
                    textColor: Colors.white,
                    onPressed: _saveDestination,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller, VoidCallback onTap) {
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
          suffixIcon: Icon(Icons.calendar_today),
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
