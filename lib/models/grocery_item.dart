class GroceryItem {
  final String name;
  final String addedBy;
  final bool isDone;

  GroceryItem({required this.name, required this.addedBy, this.isDone = false});

  Map<String, dynamic> toJson() => {
    'name': name,
    'addedBy': addedBy,
    'isDone': isDone,
  };

  factory GroceryItem.fromJson(Map<String, dynamic> json) => GroceryItem(
    name: json['name'],
    addedBy: json['addedBy'],
    isDone: json['isDone'],
  );
}
