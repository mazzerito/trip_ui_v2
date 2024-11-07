import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_vibes_ui_v2/services/authService.dart';
import '../../../models/destinations.dart';

class EditDestinationScreen extends StatefulWidget {
  final int tripId; // Trip ID passed to identify the trip
  final Destination destination; // Destination object to edit

  EditDestinationScreen({required this.tripId, required this.destination});

  @override
  _EditDestinationScreenState createState() => _EditDestinationScreenState();
}

class _EditDestinationScreenState extends State<EditDestinationScreen> {
  late TextEditingController _nameController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _imageUrlController;
  final AuthService _authService = AuthService();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.destination.destinationName);
    _startDateController = TextEditingController(
      text: widget.destination.startDate != null
          ? DateFormat('yyyy-MM-dd').format(widget.destination.startDate!)
          : '',
    );
    _endDateController = TextEditingController(
      text: widget.destination.endDate != null
          ? DateFormat('yyyy-MM-dd').format(widget.destination.endDate!)
          : '',
    );
    _imageUrlController = TextEditingController(text: widget.destination.destinationImage ?? '');
    _startDate = widget.destination.startDate;
    _endDate = widget.destination.endDate;
  }

  Future<void> _updateDestination() async {
    String name = _nameController.text.trim();
    String imageUrl = _imageUrlController.text.trim();
    String startDate = _startDateController.text.trim();
    String endDate = _endDateController.text.trim();

    try {
      // Call the service function to update the destination with the provided tripId
      await _authService.editDestination(
        widget.tripId, // Passing the trip ID as required
        widget.destination.destinationId!, // Destination ID for the update
        name,
        startDate,
        endDate,
        imageUrl.isNotEmpty ? imageUrl : null,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Destination updated successfully')),
      );
      Navigator.pop(context, true); // Indicate a successful update
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update destination: $e')),
      );
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller, bool isStartDate) async {
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
        title: Text("Update Destination",
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
                    label: 'Update',
                    color: Color(0xff5100F2),
                    textColor: Colors.white,
                    onPressed: _updateDestination,
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
