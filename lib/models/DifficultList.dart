import 'Difficult.dart';

class DifficultList {
  final List<Difficult> difficults;
  DifficultList({this.difficults});

  factory DifficultList.fromJson(List<dynamic> parsedJson) {
    List<Difficult> difficults = new List<Difficult>();
    difficults = parsedJson.map((i) => Difficult.fromJson(i)).toList();
    return new DifficultList(
      difficults: difficults,
    );
  }
}
