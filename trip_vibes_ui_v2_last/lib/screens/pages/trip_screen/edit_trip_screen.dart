import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/authService.dart';

class EditTripScreenTest extends StatefulWidget {
  //final int userId;
  final int tripId;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String people;
  final double budget;
  Function fectchTrip;
  EditTripScreenTest({
    //required this.userId,
    required this.tripId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.people,
    required this.budget,
    required this.fectchTrip,
  });

  @override
  _EditTripScreenTestState createState() => _EditTripScreenTestState();
}

class _EditTripScreenTestState extends State<EditTripScreenTest> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _peopleController;
  late TextEditingController _budgetController;
  final AuthService _authService = AuthService();

  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    _startDateController =
        TextEditingController(text: dateFormatter.format(widget.startDate));
    _endDateController =
        TextEditingController(text: dateFormatter.format(widget.endDate));
    _peopleController = TextEditingController(text: widget.people);
    _budgetController = TextEditingController(text: widget.budget.toString());
  }

  Future<void> _submitEdit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await _authService.editTrip(
          //widget.userId,
          widget.tripId,
          _titleController.text,
          _descriptionController.text,
          //_startDateController.text,
          _startDateController.text,
          _endDateController.text,
          _peopleController.text,
          double.parse(_budgetController.text),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Trip updated successfully!........')),
        );
        widget.fectchTrip();

        Future.delayed(Duration(seconds: 3));
        print(">>>>>> widget.fetchtripsssss");
        Navigator.pop(context, response);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update trip: $e')),
        );
      }
    }
  }

  Future<void> _selectDate(
      TextEditingController controller, DateTime initialDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        controller.text = dateFormatter.format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Trip",
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
        padding: const EdgeInsets.all(20.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Trip Title',
                    contentPadding: EdgeInsets.symmetric(horizontal: 18.0),
                    hintText: 'Enter trip title',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a title' : null,
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    contentPadding: EdgeInsets.symmetric(horizontal: 18.0),
                    hintText: 'Enter trip description',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: _peopleController,
                  decoration: InputDecoration(
                    labelText: 'People',
                    contentPadding: EdgeInsets.symmetric(horizontal: 18.0),
                    hintText: 'Enter trip people names',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter people names' : null,
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: _budgetController,
                  decoration: InputDecoration(
                    labelText: 'Budget',
                    contentPadding: EdgeInsets.symmetric(horizontal: 18.0),
                    hintText: 'Enter trip Budget',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a budget';
                    }
                    final budget = double.tryParse(value);
                    if (budget == null || budget < 0) {
                      return 'Please enter a valid budget';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25,),
                TextFormField(
                  controller: _startDateController,
                  readOnly: true,
                  onTap: () => _selectDate(
                    _startDateController,
                    widget.endDate,
                  ),
                  decoration: InputDecoration(
                      labelText: 'Start Date (YYYY-MM-DD)',
                      contentPadding: EdgeInsets.symmetric(horizontal: 18.0),
                      hintText: 'Enter trip start date',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                      )),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a start date' : null,
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: _endDateController,
                  readOnly: true,
                  onTap: () => _selectDate(
                    _endDateController,
                    widget.endDate,
                  ),
                  decoration: InputDecoration(
                      labelText: 'End Date (YYYY-MM-DD)',
                      //labelStyle: TextStyle(color: Colors.black),
                      contentPadding: EdgeInsets.symmetric(horizontal: 18.0),
                      hintText: 'Enter trip end date',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                      )),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter an end date' : null,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: _submitEdit,
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff5100F2),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
