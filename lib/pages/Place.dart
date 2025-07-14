class Place {
  String location;
  String description;
  bool visited;
  String imagePath;

  Place({
    required this.location,
    required this.description,
    this.visited = false,
    required this.imagePath,
  });
}
