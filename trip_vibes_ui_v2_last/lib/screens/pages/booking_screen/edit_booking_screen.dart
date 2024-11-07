import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_vibes_ui_v2/services/authService.dart';
import '../../../models/bookings.dart';

class UpdateBookingScreen extends StatefulWidget {
  final int tripId;
  final Bookings booking; // Pass the booking to be updated

  UpdateBookingScreen({required this.tripId, required this.booking});

  @override
  _UpdateBookingScreenState createState() => _UpdateBookingScreenState();
}

class _UpdateBookingScreenState extends State<UpdateBookingScreen> {
  late TextEditingController _titleController;
  late TextEditingController _costController;
  late TextEditingController _dateController;
  final AuthService _bookingService = AuthService();
  late BookingStatus _selectedStatus;
  DateTime? _bookingDate;

  String userName = "null-value";
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.booking.bookingTitle);
    _costController = TextEditingController(
        text: widget.booking.bookingCost?.toStringAsFixed(2) ?? '');
    _dateController = TextEditingController(
        text: widget.booking.bookingDate != null
            ? DateFormat('yyyy-MM-dd').format(widget.booking.bookingDate!)
            : '');
    _selectedStatus = widget.booking.status ?? BookingStatus.pending;
    getCookieUser();
  }

  getCookieUser() async {
    // Fetch user information
    // This is just for illustration; adjust as needed
  }

  Future<void> _updateBooking() async {
    String title = _titleController.text.trim();
    double cost = double.tryParse(_costController.text.trim()) ?? 0.0;
    String date = _dateController.text.trim();

    try {
      await _bookingService.updateBooking(
        widget.booking.bookingId!,
        widget.tripId,
        //userId,
        title,
        cost,
        date,
        _selectedStatus,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking updated successfully')),
      );

      Navigator.pop(context, true); // Return true to indicate a successful update
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update booking: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _bookingDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _bookingDate = pickedDate;
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Booking",
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
              //   'Edit Booking',
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
                    label: 'Update',
                    color: Color(0xff5100F2),
                    textColor: Colors.white,
                    onPressed: _updateBooking,
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
