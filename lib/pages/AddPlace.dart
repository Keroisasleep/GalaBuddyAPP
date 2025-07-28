import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Place.dart';

class AddPlace extends StatefulWidget {
  const AddPlace({super.key});

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  final _formKey = GlobalKey<FormState>();
  String _location = '';
  String _description = '';
  bool _visited = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Place',
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Where should we go next?',
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Location Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
                onChanged: (value) => _location = value,
              ),
              const SizedBox(height: 15),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _description = value,
              ),
              const SizedBox(height: 15),

              SwitchListTile(
                title: const Text('Visited'),
                value: _visited,
                onChanged: (value) {
                  setState(() => _visited = value);
                },
              ),
              const SizedBox(height: 15),

              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigoAccent),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newPlace = Place(
                      location: _location,
                      description: _description,
                      visited: _visited,
                      imagePath: '', // No image allowed during add
                    );
                    Navigator.pop(context, newPlace);
                  }
                },
                child: const Text('Add', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
