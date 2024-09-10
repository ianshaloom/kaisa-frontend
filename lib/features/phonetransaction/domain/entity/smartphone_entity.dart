import 'package:cloud_firestore/cloud_firestore.dart';

class SmartphoneEntity {
  final String id;
  final String name;
  final String brand;
  final String model;
  final String ram;
  final String storage;
  final String display;
  final String mainCamera;
  final String frontCamera;
  final String battery;
  final String imageUrl;

  SmartphoneEntity({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.ram,
    required this.storage,
    required this.display,
    required this.mainCamera,
    required this.frontCamera,
    required this.battery,
    required this.imageUrl,
  });

  static SmartphoneEntity get empty => SmartphoneEntity(
        id: '',
        name: '',
        brand: '',
        model: '',
        ram: '',
        storage: '',
        imageUrl: '',
        display: '',
        mainCamera: '',
        frontCamera: '',
        battery: '',
      );

  SmartphoneEntity copyWith({
    String? id,
    String? name,
    String? brand,
    String? model,
    String? ram,
    String? storage,
    String? imageUrl,
    String? display,
    String? mainCamera,
    String? frontCamera,
    String? battery,
  }) {
    return SmartphoneEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      ram: ram ?? this.ram,
      storage: storage ?? this.storage,
      imageUrl: imageUrl ?? this.imageUrl,
      display: display ?? this.display,
      mainCamera: mainCamera ?? this.mainCamera,
      frontCamera: frontCamera ?? this.frontCamera,
      battery: battery ?? this.battery,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'model': model,
      'ram': ram,
      'storage': storage,
      'imageUrl': imageUrl,
      'display': display,
      'mainCamera': mainCamera,
      'frontCamera': frontCamera,
      'battery': battery,
    };
  }

  factory SmartphoneEntity.fromMap(Map<String, dynamic> map) {
    return SmartphoneEntity(
      id: map['id'],
      name: map['name'],
      brand: map['brand'],
      model: map['model'],
      ram: map['ram'],
      storage: map['storage'],
      imageUrl: map['imageUrl'],
      display: map['display'],
      mainCamera: map['mainCamera'],
      frontCamera: map['frontCamera'],
      battery: map['battery'],
    );
  }

  SmartphoneEntity.fromQuerySnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : id = documentSnapshot.id,
        name = documentSnapshot['name'],
        brand = documentSnapshot['brand'],
        model = documentSnapshot['model'],
        ram = documentSnapshot['ram'],
        storage = documentSnapshot['storage'],
        imageUrl = documentSnapshot['imageUrl'],
        display = documentSnapshot['display'],
        mainCamera = documentSnapshot['mainCamera'],
        frontCamera = documentSnapshot['frontCamera'],
        battery = documentSnapshot['battery'];
}
