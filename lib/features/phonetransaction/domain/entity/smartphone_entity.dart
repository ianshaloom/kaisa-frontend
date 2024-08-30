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

// list of smartphones

List<SmartphoneEntity> smartps = [
  SmartphoneEntity(
    id: '010',
    name: 'Samsung Galaxy A05',
    brand: 'Samsung',
    model: 'Galaxy A05',
    ram: '4GB',
    storage: '64GB',
    imageUrl: 'Galaxy-A05-4-64.png',
    display: '6.7 inch, LCD, 90Hz',
    mainCamera: '50 MP + 2 MP',
    frontCamera: '8 MP',
    battery: '5,000 mAh',
  ),
  SmartphoneEntity(
    id: '011',
    name: 'Samsung Galaxy A05',
    brand: 'Samsung',
    model: 'Galaxy A05',
    ram: '4GB',
    storage: '128GB',
    imageUrl: 'Galaxy-A05-4-128.png',
    display: '6.7 inch, LCD, 90Hz',
    mainCamera: '50 MP + 2 MP',
    frontCamera: '8 MP',
    battery: '5,000 mAh',
  ),
  SmartphoneEntity(
    id: '020',
    name: 'Samsung Galaxy A05s',
    brand: 'Samsung',
    model: 'Galaxy A05s',
    ram: '4GB',
    storage: '64GB',
    imageUrl: 'Galaxy-A05s-4-64.png',
    display: '6.7 inch, LCD, 90Hz',
    mainCamera: '50 MP + 2 MP+ 2 MP',
    frontCamera: '13 MP',
    battery: '5000 mAh',
  ),
  SmartphoneEntity(
    id: '021',
    name: 'Samsung Galaxy A05s',
    brand: 'Samsung',
    model: 'Galaxy A05s',
    ram: '4GB',
    storage: '128GB',
    imageUrl: 'Galaxy-A05s-4-128.png',
    display: '6.7 inch, LCD, 90Hz',
    mainCamera: '50 MP + 2 MP+ 2 MP',
    frontCamera: '13 MP',
    battery: '5000 mAh',
  ),
  SmartphoneEntity(
    id: '030',
    name: 'Samsung Galaxy A25',
    brand: 'Samsung',
    model: 'Galaxy A25',
    ram: '6GB',
    storage: '128GB',
    imageUrl: 'Samsung-Galaxy-A25-5G-6-128.png',
    display: '6.5 inch',
    mainCamera: '50MP + 8MP + 2MP',
    frontCamera: '13 MP',
    battery: '5000 mAh',
  ),
  SmartphoneEntity(
    id: '031',
    name: 'Samsung Galaxy A25',
    brand: 'Samsung',
    model: 'Galaxy A25',
    ram: '8GB',
    storage: '256GB',
    imageUrl: 'Samsung-Galaxy-A25-5G-8-256.png',
    display: '6.5 inch',
    mainCamera: '50MP + 8MP + 2MP',
    frontCamera: '13 MP',
    battery: '5000 mAh',
  ),
  SmartphoneEntity(
    id: '040',
    name: 'Samsung Galaxy A35 5G',
    brand: 'Samsung',
    model: 'Galaxy A35 5G',
    ram: '6GB',
    storage: '128GB',
    imageUrl: 'Samsung-Galaxy-A35-5G-6-128.png',
    display: ' 6.6 inches, 120 Hz',
    mainCamera: '50MP + 8MP + 5MP',
    frontCamera: '13MP',
    battery: '5000 mAh',
  ),
  SmartphoneEntity(
    id: '041',
    name: 'Samsung Galaxy A35 5G',
    brand: 'Samsung',
    model: 'Galaxy A35 5G',
    ram: '8GB',
    storage: '256GB',
    imageUrl: 'Samsung-Galaxy-A35-5G-8-256.png',
    display: ' 6.6 inches, 120 Hz',
    mainCamera: '50MP + 8MP + 5MP',
    frontCamera: '13MP',
    battery: '5000 mAh',
  ),
  SmartphoneEntity(
    id: '050',
    name: 'Samsung Galaxy A55 5G',
    brand: 'Samsung',
    model: 'Galaxy A55 5G',
    ram: '8GB',
    storage: '128GB',
    imageUrl: 'Samsung-Galaxy-A55-5G-8-128.png',
    display: '6 inches, 120 Hz',
    mainCamera: '50 MP + 12MP + 5 MP',
    frontCamera: '32MP',
    battery: '5000 mAh',
  ),
  SmartphoneEntity(
    id: '051',
    name: 'Samsung Galaxy A55 5G',
    brand: 'Samsung',
    model: 'Galaxy A55 5G',
    ram: '8GB',
    storage: '256GB',
    imageUrl: 'Samsung-Galaxy-A55-5G-8-256.png',
    display: '6 inches, 120 Hz',
    mainCamera: '50 MP + 12MP + 5 MP',
    frontCamera: '32MP',
    battery: '5000 mAh',
  ),
];
