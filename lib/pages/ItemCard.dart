import 'package:flutter/material.dart';
import 'Place.dart';

class ItemCard extends StatefulWidget {
  final Place place;

  const ItemCard({super.key, required this.place});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  late bool isVisited;

  @override
  void initState() {
    super.initState();
    isVisited = widget.place.visited;
  }

  void toggleVisited() {
    setState(() {
      isVisited = !isVisited;
      widget.place.visited = isVisited; // Update original object
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (widget.place.imagePath.isNotEmpty) {
      imageWidget = Image.asset(
        widget.place.imagePath,
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 160,
            color: Colors.grey[300],
            child: const Center(child: Icon(Icons.image_not_supported, size: 60)),
          );
        },
      );
    } else {
      imageWidget = Container(
        height: 160,
        color: Colors.grey[200],
        child: const Center(child: Icon(Icons.travel_explore, size: 60, color: Colors.blueGrey)),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.blueGrey, width: 1.5),
        ),
        elevation: 4,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: imageWidget,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.place.location,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.place.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: toggleVisited,
                        icon: Icon(
                          isVisited ? Icons.undo : Icons.check,
                          color: Colors.white,
                        ),
                        label: Text(isVisited ? "Mark as Pending" : "Mark as Visited"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isVisited ? Colors.orange : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
