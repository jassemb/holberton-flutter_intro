class Character {
  final String? name;
  final String? imgUrl;
  final int? id;

  Character({this.name, this.imgUrl, this.id});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] as String,
      imgUrl: json['img'] as String,
      id: json['char_id'] as int,
    );
  }
}


