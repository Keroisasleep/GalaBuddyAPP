import 'package:flutter/material.dart';

void main() => runApp(GalaBuddyApp());

class GalaBuddyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GalaBuddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: TravelChecklistScreen(),
    );
  }
}

class TravelChecklistScreen extends StatefulWidget {
  @override
  _TravelChecklistScreenState createState() => _TravelChecklistScreenState();
}

class _TravelChecklistScreenState extends State<TravelChecklistScreen> {
  final List<Destination> destinations = [
    Destination(name: 'Venice', imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/06/Venice_from_San_Giorgio_Maggiore.jpg'),
    Destination(name: 'Grand Canyon', imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/5c/Grand_Canyon_view_from_Pima_Point_2010.jpg'),
    Destination(name: 'Kyoto', imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/e6/Kiyomizu-dera_in_Kyoto.jpg'),
    Destination(name: 'Paris', imageUrl: 'https://invalid-url.com/image.jpg'), // Invalid URL for icon fallback
  ];

  void toggleVisited(int index) {
    setState(() {
      destinations[index].visited = !destinations[index].visited;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'GalaBuddy',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(icon: Icon(Icons.account_circle), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Add place logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Add New Place', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Travel Checklist',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: destinations.length,
                itemBuilder: (context, index) {
                  final destination = destinations[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          destination.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey[200],
                            child: Icon(Icons.photo, color: Colors.grey[500]),
                          ),
                        ),
                      ),
                      title: Text(destination.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              destination.visited
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: destination.visited ? Colors.teal : Colors.grey,
                            ),
                            onPressed: () => toggleVisited(index),
                          ),
                          Icon(Icons.notes, color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Destination {
  final String name;
  final String imageUrl;
  bool visited;

  Destination({required this.name, required this.imageUrl, this.visited = false});
}