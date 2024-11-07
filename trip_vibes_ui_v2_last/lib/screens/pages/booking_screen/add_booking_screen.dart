import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_vibes_ui_v2/services/authService.dart';
import '../../../models/bookings.dart';

class AddBookingScreen extends StatefulWidget {
  final int tripId;

  AddBookingScreen({required this.tripId});

  @override
  _AddBookingScreenState createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final AuthService _bookingService = AuthService();
  DateTime? _bookingDate;
  BookingStatus _selectedStatus = BookingStatus.pending; // Default status

  String userName = "null-value";
  int userId = 0;

  @override
  void initState() {
    super.initState();
    getCookieUser();
  }

  getCookieUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('name') ?? "null-value";
    userId = prefs.getInt("userId") ?? 0;
    print('>>> user_name: $userName, user_id: $userId');
  }

  Future<void> _saveBooking() async {
    String title = _titleController.text.trim();
    double cost = double.tryParse(_costController.text.trim()) ?? 0.0;
    String date = _dateController.text.trim();

    try {
      await _bookingService.createNewBooking(
        widget.tripId,
        //userId,
        title,
        cost,
        date,
        _selectedStatus, // Include selected status
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking saved successfully')),
      );

      Navigator.pop(context, true); // Pass true to indicate a successful save
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save booking: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      _bookingDate = pickedDate;
      _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add New Booking",
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
              // Text(
              //   'New Booking',
              //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              // ),
              const SizedBox(height: 10),
              _buildTextField('Booking Title', _titleController),
              _buildNumberField('Cost', _costController, TextInputType.number),
              _buildDateField(
                'Booking Date',
                _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 15),
              _buildStatusDropdown(),
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
                    onPressed: _saveBooking,
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

  Widget _buildNumberField(String hint, TextEditingController controller, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
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

  Widget _buildDateField(String hint, TextEditingController controller, {bool readOnly = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          filled: true,
          fillColor: Colors.grey.shade100,
          suffixIcon: Icon(Icons.calendar_today),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: DropdownButtonFormField<BookingStatus>(
        value: _selectedStatus,
        onChanged: (BookingStatus? newValue) {
          setState(() {
            _selectedStatus = newValue!;
          });
        },
        items: BookingStatus.values.map((BookingStatus status) {
          return DropdownMenuItem<BookingStatus>(
            value: status,
            child: Text(status.toString().split('.').last.toUpperCase()),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: 'Status',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          filled: true,
          fillColor: Colors.grey.shade100,
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
