import 'package:flutter/material.dart';

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({
    Key key,
    @required int currentIndex,
    this.onTabTapped,
  })  : _currentIndex = currentIndex,
        super(key: key);
  final Function onTabTapped;
  final int _currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: onTabTapped,
      currentIndex: _currentIndex,
      selectedItemColor: Colors.black,
      unselectedIconTheme: IconThemeData(color: Colors.grey),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Карта")),
        BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("Тест")),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), title: Text("Кабинет"))
      ],
    );
  }
}
