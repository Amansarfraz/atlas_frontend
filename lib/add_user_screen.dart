import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String? _selectedCity;
  String? _selectedCountry;

  final List<String> cities = [
    "Karachi",
    "Lahore",
    "Islamabad",
    "Peshawar",
    "Quetta",
  ];
  final List<String> countries = ["Pakistan", "India", "USA", "UK", "UAE"];

  Future<void> addUser() async {
    if (_formKey.currentState!.validate()) {
      User user = User(
        userId: _userIdController.text,
        name: _nameController.text,
        fatherName: _fatherNameController.text,
        city: _selectedCity!,
        country: _selectedCountry!,
        age: int.parse(_ageController.text),
      );

      bool success = await ApiService.addUser(user.toJson());
      if (success)
        Navigator.pop(context);
      else
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding user')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add User")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _userIdController,
                decoration: InputDecoration(labelText: "User ID"),
                validator: (v) => v!.isEmpty ? "Enter User ID" : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
                validator: (v) => v!.isEmpty ? "Enter Name" : null,
              ),
              TextFormField(
                controller: _fatherNameController,
                decoration: InputDecoration(labelText: "Father Name"),
                validator: (v) => v!.isEmpty ? "Enter Father Name" : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                items: cities
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCity = v),
                decoration: InputDecoration(labelText: "City"),
                validator: (v) => v == null ? "Select City" : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                items: countries
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCountry = v),
                decoration: InputDecoration(labelText: "Country"),
                validator: (v) => v == null ? "Select Country" : null,
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Enter Age" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: addUser, child: Text("Add User")),
            ],
          ),
        ),
      ),
    );
  }
}
