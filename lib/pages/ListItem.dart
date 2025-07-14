import 'package:flutter/material.dart';
import 'Place.dart';
import 'ItemCard.dart';
import 'AddPlace.dart';

class ListItems extends StatefulWidget {
  const ListItems({super.key});

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  List<Place> destinations = [
    Place(location: 'Kyoto, Japan', description: 'Temple hopping & culture.', visited: false, imagePath: ''),
    Place(location: 'Paris, France', description: 'Eiffel Tower and cafes.', visited: true, imagePath: ''),
  ];

  void _addNewPlace(Place newPlace) {
    setState(() {
      destinations.add(newPlace);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧭 My Travel List', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: destinations.map((destination) => ItemCard(place: destination)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPlace = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPlace()),
          );
          if (newPlace != null && newPlace is Place) {
            _addNewPlace(newPlace);
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
