class Place {
  String location;
  String description;
  bool visited;
  String imagePath;
  DateTime? visitedDate; // <-- Required for date stamping

  Place({
    required this.location,
    required this.description,
    required this.visited,
    required this.imagePath,
    this.visitedDate,
  });
}
