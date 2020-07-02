import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Destination {
  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Home', Icons.location_on, Colors.teal),
  Destination('Business', Icons.casino, Colors.cyan),
  Destination('School', Icons.school, Colors.orange),
  Destination('Flight', Icons.flight, Colors.blue)
];
