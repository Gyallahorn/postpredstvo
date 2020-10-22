// To parse this JSON data, do
//
//     final test = testFromJson(jsonString);

import 'dart:convert';

List<Test> testFromJson(String str) =>
    List<Test>.from(json.decode(str).map((x) => Test.fromJson(x)));

String testToJson(List<Test> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Test {
  Test({
    this.test,
    this.id,
    this.name,
  });

  List<List<String>> test;
  String id;
  String name;

  factory Test.fromJson(Map<String, dynamic> json) => Test(
        test: List<List<String>>.from(
            json["test"].map((x) => List<String>.from(x.map((x) => x)))),
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "test": List<dynamic>.from(
            test.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "_id": id,
        "name": name,
      };
}
