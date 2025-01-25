class Translation {
  final String english;
  final String mon;
  final String audio;

  Translation({required this.english, required this.mon, required this.audio});

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      english: json['english'],
      mon: json['mon'],
      audio: json['audio'],
    );
  }
}
