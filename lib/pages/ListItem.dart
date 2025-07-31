import 'dart:async';
import 'package:flutter/material.dart';
import 'Place.dart';
import 'ItemCard.dart';
import 'AddPlace.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:galaapp/services/world_time.dart';

class ListItems extends StatefulWidget {
  const ListItems({super.key});

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  List<Place> destinations = [
    Place(location: 'Kyoto, Japan', description: 'Temple hopping & culture.', visited: false, imagePath: ''),
    Place(location: 'Paris, France', description: 'Eiffel Tower and cafes.', visited: false, imagePath: ''),
  ];

  String _currentTime = 'Loading...';
  Timer? _timeUpdateTimer;

  @override
  void initState() {
    super.initState();
    _loadTime();
    _timeUpdateTimer = Timer.periodic(const Duration(seconds: 20), (_) => _loadTime());
  }

  @override
  void dispose() {
    _timeUpdateTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadTime() async {
    WorldTime instance = WorldTime(
      location: 'Manila',
      url: 'Asia/Manila',
      flag: 'assets/philippines.jpg',
    );
    await instance.getTime();

    setState(() {
      _currentTime = instance.time;
    });
  }

  void _addNewPlace(Place newPlace) {
    setState(() {
      destinations.insert(0, newPlace);
    });
  }

  void _deletePlace(int index) {
    setState(() {
      destinations.removeAt(index);
    });
  }

  void _editPlace(int index, Place updatedPlace) {
    setState(() {
      destinations[index] = updatedPlace;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Travel List',
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: Date
                Text(
                  DateFormat('MM/dd/yyyy').format(DateTime.now()),
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                // Center: "Manila"
                Text(
                  'Manila',
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                // Right: Time
                Text(
                  _currentTime,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/worldtime');
              },
              child: const Text(
                'Check World Time',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                return ItemCard(
                  place: destinations[index],
                  onDelete: () => _deletePlace(index),
                  onEdit: () async {
                    final current = destinations[index];
                    final updated = await showModalBottomSheet<Place>(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (_) {
                        final locController = TextEditingController(text: current.location);
                        final descController = TextEditingController(text: current.description);
                        bool visited = current.visited;

                        return Padding(
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 20,
                            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Edit Place', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              TextField(controller: locController, decoration: const InputDecoration(labelText: 'Location')),
                              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
                              SwitchListTile(
                                value: visited,
                                onChanged: (val) => visited = val,
                                title: const Text('Visited'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                    Place(
                                      location: locController.text,
                                      description: descController.text,
                                      visited: visited,
                                      imagePath: current.imagePath,
                                    ),
                                  );
                                },
                                child: const Text('Save Changes'),
                              )
                            ],
                          ),
                        );
                      },
                    );

                    if (updated != null) _editPlace(index, updated);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final newPlace = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPlace()),
          );
          if (newPlace != null) _addNewPlace(newPlace);
        },
      ),
    );
  }
}
