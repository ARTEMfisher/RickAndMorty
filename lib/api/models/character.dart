import 'package:rick_and_morty/api/sqlite.dart';

class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  bool isFavorite;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    this.isFavorite = false,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'image': image,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'],
      name: map['name'],
      status: map['status'],
      species: map['species'],
      image: map['image'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}
