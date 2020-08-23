import 'dart:convert';

class Difficult {
  final int id;
  final String difficult;
  final String difficult_name;
  final String name;
  final String long;
  final String link;
  Difficult(
      {this.id,
      this.difficult,
      this.difficult_name,
      this.name,
      this.long,
      this.link});
  factory Difficult.fromJson(Map<String, dynamic> json) {
    return Difficult(
      id: json['id'],
      difficult: json['difficult'],
      difficult_name: json['difficult_name'],
      name: json['name'],
      long: json['long'],
      link: json['link'],
    );
  }
}
