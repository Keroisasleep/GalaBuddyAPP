import 'package:flutter/material.dart';
import 'Place.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Place> destinations = [
    Place(
        location: 'Kyoto, Japan',
        description: 'Temple hopping & culture.',
        visited: true,
        imagePath: ''),
    Place(
        location: 'Paris, France',
        description: 'Eiffel Tower and cafes.',
        visited: false,
        imagePath: ''),
  ];

  int? selectedCardIndex;

  void _editPlace(int index) {
    final place = destinations[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Place'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Editing: ${place.location}'),
            const SizedBox(height: 10),
            const Text('Edit feature coming soon...'),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close')),
        ],
      ),
    );
  }

  void _deletePlace(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Place'),
        content:
        Text('Are you sure you want to delete ${destinations[index].location}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        destinations.removeAt(index);
        selectedCardIndex = null;
      });
    }
  }

  void _handleLongPress(int index) {
    setState(() {
      selectedCardIndex = index;
    });
  }

  void _clearSelection() {
    setState(() {
      selectedCardIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _clearSelection, // tap outside to close icons
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Travel List',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.indigo,
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: destinations.length,
          itemBuilder: (context, index) {
            final place = destinations[index];
            final isSelected = selectedCardIndex == index;

            return GestureDetector(
              onLongPress: () => _handleLongPress(index),
              onTap: () {
                if (isSelected) _clearSelection();
              },
              child: Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.travel_explore,
                          size: 48, color: Colors.grey),
                      const SizedBox(height: 12),
                      Text(
                        place.location,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(place.description),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: place.visited
                                  ? Colors.green
                                  : Colors.orange,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              place.visited ? 'Visited' : 'Pending',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (isSelected)
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => _editPlace(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deletePlace(index),
                                ),
                              ],
                            )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            // TODO: Add place logic here
          },
        ),
      ),
    );
  }
}
