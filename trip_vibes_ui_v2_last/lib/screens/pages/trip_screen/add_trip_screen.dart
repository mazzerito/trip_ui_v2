import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_vibes_ui_v2/services/authService.dart';
import '../../../models/trips.dart'; // Make sure to import your TripService  // Import your Trip model

class AddTripScreen extends StatefulWidget {
  @override
  _AddTripScreenState createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final AuthService _authService = AuthService();
  DateTime? _startDate;
  DateTime? _endDate;


    String user_name = "null-value";
    int user_id = 0;
    
  @override
  void initState() {
    super.initState();
      getCookieUser();
    // Fetch trips when the screen loads
  }
  getCookieUser() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //Return bool
      user_name = prefs.getString('name') ?? "null=value";
      user_id = prefs.getInt("userId")?? 0;
      print('>>> user_name' + user_name + " user_id = ${user_id}");
      //fetchTrips(); 
    }
  Future<void> _saveTrip() async {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();
    String people = _peopleController.text.trim();

    // Parse and format dates and budget
    String start = _startDateController.text.trim();
    String end = _endDateController.text.trim();
    double budget = double.tryParse(_budgetController.text.trim()) ?? 0.0;

    try {
      int userId = user_id; // KEEPING COOKIE USER ID FOR LOGin

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
        title: Text(
          "Add New Trip",
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          double padding = constraints.maxWidth * 0.05;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'New trip',
                //   style: TextStyle(
                //     fontSize: 24,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                SizedBox(height: 10),
                _buildTextField('Trip title', _titleController),
                _buildTextField('Description', _descriptionController, ),
                _buildNumberField('Trip budget', _budgetController, TextInputType.number),
                _buildTextField('People joining the trip', _peopleController),
                _buildDateField(
                          'Start Date', 
                          _startDateController, 
                          readOnly: true,
                          onTap: () =>_selectDate (context, _startDateController),
                        ),
                _buildDateField(
                          'End Date', 
                          _endDateController, 
                          readOnly: true,
                          onTap: () =>_selectDate (context, _endDateController),
                        ),

                // _buildDateField('Start Date', _startDateController, readOnly: true,),
                // _buildDateField('End Date',_endDateController, readOnly: true,),
                // _buildDateField(
                //   'Start date',
                //   _startDateController,
                //   () => _selectDate(context, true), // Select start date
                // ),
                // _buildDateField(
                //   'End date',
                //   _endDate,
                //   () => _selectDate(context, false), // Select end date
                // ),
                
                SizedBox(height: 15),
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
                      onPressed: _saveTrip,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
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

  Widget _buildTextField(String hint, TextEditingController controller ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
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
      keyboardType: inputType, // Add this line to specify the input type
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
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
          readOnly: readOnly, // Set readOnly based on the parameter
          onTap: readOnly ? onTap : null, // Only trigger onTap if readOnly is true
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            suffixIcon: Icon(Icons.calendar_today,
                    color: Colors.grey,)
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
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(color: textColor, fontSize: 16),
      ),
    );
  }

  // Future<void> _selectDate(BuildContext context, bool isStartDate) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: isStartDate ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //   if (pickedDate != null) {
  //     setState(() {
  //       if (isStartDate) {
  //         _startDate = pickedDate;
  //       } else {
  //         _endDate = pickedDate;
  //       }
  //     });
  //   }
  // }

  // Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 6.0),
  //     child: GestureDetector(
  //       onTap: onTap,
  //       child: TextField(
  //         readOnly: true,
  //         decoration: InputDecoration(
  //           contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
  //           hintText: label,
  //           hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(30),
  //             borderSide: BorderSide(color: Colors.grey.shade300),
  //           ),
  //           filled: true,
  //           fillColor: Colors.grey.shade100,
  //           suffixIcon: Icon(Icons.calendar_today),
  //         ),
  //         controller: TextEditingController(
  //           text: date != null ? "${date.toLocal()}".split(' ')[0] : '',
  //         ),
  //       ),
  //     ),
  //   );
  // }

//   Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 6.0),
//     child: GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(30),
//           border: Border.all(color: Colors.black),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               date != null ? "${date.toLocal()}".split(' ')[0] : label,
//               style: TextStyle(
//                 color: date != null ? Colors.black : Colors.grey,
//                 fontSize: 14,
//               ),
//             ),
//             Icon(Icons.calendar_today, color: Colors.grey),
//           ],
//         ),
//       ),
//     ),
//   );
// }


}
