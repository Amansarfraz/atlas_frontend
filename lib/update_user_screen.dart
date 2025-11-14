import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UpdateUserScreen extends StatefulWidget {
  final User user;
  UpdateUserScreen({required this.user});

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _fatherNameController;
  late TextEditingController _ageController;

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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _fatherNameController = TextEditingController(text: widget.user.fatherName);
    _ageController = TextEditingController(text: widget.user.age.toString());
    _selectedCity = widget.user.city;
    _selectedCountry = widget.user.country;
  }

  Future<void> updateUser() async {
    if (_formKey.currentState!.validate()) {
      User updatedUser = User(
        userId: widget.user.userId,
        name: _nameController.text,
        fatherName: _fatherNameController.text,
        city: _selectedCity!,
        country: _selectedCountry!,
        age: int.parse(_ageController.text),
      );

      bool success = await ApiService.updateUser(
        widget.user.userId,
        updatedUser.toJson(),
      );
      if (success)
        Navigator.pop(context);
      else
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating user')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update User")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
              ElevatedButton(onPressed: updateUser, child: Text("Update User")),
            ],
          ),
        ),
      ),
    );
  }
}
