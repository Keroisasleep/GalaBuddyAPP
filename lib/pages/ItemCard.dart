import 'package:flutter/material.dart';
import 'Place.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ItemCard extends StatefulWidget {
  final Place place;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ItemCard({
    super.key,
    required this.place,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool showActions = false;

  void _toggleVisitedStatus() {
    if (!widget.place.visited) {
      setState(() {
        widget.place.visited = true;
        widget.place.visitedDate = DateTime.now();
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _toggleActions() {
    setState(() => showActions = !showActions);
  }

  Future<void> _pickImageWithPermission(Function(String) onPicked) async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked != null) {
        onPicked(picked.path);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission to access gallery denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (showActions) setState(() => showActions = false);
      },
      onLongPress: _toggleActions,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: showActions
            ? _buildActionCard(key: const ValueKey("action"))
            : _buildNormalCard(key: const ValueKey("normal")),
      ),
    );
  }

  Widget _buildNormalCard({required Key key}) {
    return Card(
      key: key,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              image: widget.place.imagePath.isNotEmpty
                  ? DecorationImage(
                image: FileImage(File(widget.place.imagePath)),
                fit: BoxFit.cover,
              )
                  : null,
              color: const Color(0xFFEFEFEF),
            ),
            child: widget.place.imagePath.isEmpty
                ? const Center(
              child: Icon(Icons.travel_explore,
                  size: 48, color: Colors.grey),
            )
                : null,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.place.location,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(widget.place.description,
                    style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 12),

                /// Toggle visited (disabled if no image)
                GestureDetector(
                  onTap: widget.place.imagePath.isEmpty
                      ? null
                      : _toggleVisitedStatus,
                  child: Opacity(
                    opacity: widget.place.imagePath.isEmpty ? 0.5 : 1.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: widget.place.visited
                            ? Colors.green
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.place.visited
                                ? Icons.check_circle
                                : Icons.schedule,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.place.visited
                                ? 'Visited on ${formatDate(widget.place.visitedDate)}'
                                : 'Pending',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({required Key key}) {
    return Card(
      key: key,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          // DELETE
          Expanded(
            child: InkWell(
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Confirm Delete"),
                    content: const Text(
                        "Are you sure you want to delete this place?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Yes, Delete"),
                      ),
                    ],
                  ),
                );
                if (confirm == true) widget.onDelete();
                setState(() => showActions = false);
              },
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.4),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete, color: Colors.red, size: 32),
                      SizedBox(height: 8),
                      Text('Delete',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // EDIT
          Expanded(
            child: InkWell(
              onTap: () async {
                String imagePath = widget.place.imagePath;

                final updatedPlace = await showModalBottomSheet<Place>(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (context) {
                    final locationController = TextEditingController(
                        text: widget.place.location);
                    final descriptionController = TextEditingController(
                        text: widget.place.description);

                    return Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom:
                        MediaQuery.of(context).viewInsets.bottom + 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Edit Place",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          TextField(
                            controller: locationController,
                            decoration:
                            const InputDecoration(labelText: "Location"),
                          ),
                          TextField(
                            controller: descriptionController,
                            decoration:
                            const InputDecoration(labelText: "Description"),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await _pickImageWithPermission((path) {
                                imagePath = path;
                              });
                            },
                            icon: const Icon(Icons.photo),
                            label: const Text("Pick Photo"),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop(
                                Place(
                                  location: locationController.text,
                                  description: descriptionController.text,
                                  visited: widget.place.visited,
                                  visitedDate: widget.place.visited
                                      ? (widget.place.visitedDate ??
                                      DateTime.now())
                                      : null,
                                  imagePath: imagePath,
                                ),
                              );
                            },
                            icon: const Icon(Icons.save),
                            label: const Text("Save Changes"),
                          ),
                        ],
                      ),
                    );
                  },
                );

                if (updatedPlace != null) {
                  setState(() {
                    widget.place.location = updatedPlace.location;
                    widget.place.description = updatedPlace.description;
                    widget.place.imagePath = updatedPlace.imagePath;
                    widget.place.visited = updatedPlace.visited;
                    widget.place.visitedDate = updatedPlace.visitedDate;
                  });
                  widget.onEdit();
                }

                setState(() => showActions = false);
              },
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.4),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, color: Colors.blue, size: 32),
                      SizedBox(height: 8),
                      Text('Edit',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
