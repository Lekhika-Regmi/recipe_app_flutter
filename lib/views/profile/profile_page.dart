import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isSwitched = true;
  DateTime? _selectedDate;

  // Function to open the date picker
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                isSwitched ? Icons.nightlight : Icons.sunny,
                color: isSwitched ? Colors.black : Colors.deepOrange,
              ),
              SizedBox(width: 10),
              Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          CircleAvatar(
            radius: 80,
            backgroundImage: NetworkImage(
              'https://cdn-icons-png.freepik.com/512/6833/6833591.png',
            ),
          ),
          SizedBox(height: 16),
          Text(
            'User Name',
            style: TextStyle(
              fontFamily: 'Averia_Libre',
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Date of Birth:',
                style: TextStyle(fontFamily: 'Averia_Libre', fontSize: 20),
              ),
              SizedBox(width: 10),
              TextButton(
                onPressed: () => _pickDate(context),
                child: Text(
                  _selectedDate == null
                      ? 'Select Date'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Averia_Libre',
                    color: Colors.indigo,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
