import 'package:flutter/material.dart';
import 'Place.dart';

class Dashboard extends StatelessWidget {
  final List<Place> allDestinations = [
    Place(location: 'Tokyo', description: 'Culture & sushi.', visited: true, imagePath: ''),
    Place(location: 'Rome', description: 'History and food.', visited: false, imagePath: ''),
  ];

  @override
  Widget build(BuildContext context) {
    final int visited = allDestinations.where((e) => e.visited).length;
    final int pending = allDestinations.length - visited;

    return Scaffold(
      appBar: AppBar(
        title: const Text("📊 Travel Dashboard", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Destinations Summary", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildBar("Visited", visited, Colors.green),
                const SizedBox(width: 20),
                _buildBar("Pending", pending, Colors.orange),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBar(String label, int count, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            height: count * 20.0,
            color: color,
          ),
          const SizedBox(height: 8),
          Text('$count places'),
        ],
      ),
    );
  }
}
