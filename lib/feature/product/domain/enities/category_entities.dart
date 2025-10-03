import 'package:equatable/equatable.dart';

class CategoryEntities extends Equatable {
  final String category;
  String uid;
  String description;
  String imageUrl;
  final bool isCached;
  CategoryEntities({
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.uid,
    this.isCached = false,
  });
  Map<String, dynamic> toMap() => {
    'name': category,
    'imageurl': imageUrl,
    'description': description,
    'isCached': isCached,
  };

  factory CategoryEntities.fromMap(Map<String, dynamic> map, String id) =>
      CategoryEntities(
        category: id,
        uid: map['name'] as String,
        imageUrl: map['imageurl'] as String,
        description: map['description'] as String,
        isCached: map['isCached'] as bool? ?? false,
      );
  @override
  List<Object> get props => [category, uid, description, imageUrl];
}

List<CategoryEntities> parseCategories(List<Map<String, dynamic>> docs) {
  return docs.map((data) {
    return CategoryEntities(
      uid: data['uid'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }).toList();
}