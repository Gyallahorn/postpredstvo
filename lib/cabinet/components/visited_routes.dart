import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:pospredsvto/models/Routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../network/url_helper.dart';
import 'dart:convert' as convert;
import '../../models/UserData.dart';

class VisitedRoutes extends StatefulWidget {
  @override
  _VisitedRoutesState createState() => _VisitedRoutesState();
}

class _VisitedRoutesState extends State<VisitedRoutes> {
  bool userDataGetted = false;
  bool routesGetted = false;
  var visited = [];
  var user;
  var routes;
  fetchUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    final response = await http.get(urlHost + getProfile, headers: {
      'Authorization': 'Bearer $token',
    });
    final response2 =
        await http.get(urlHost + '/api/routes/getRoutes/normal', headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200 && response2.statusCode == 200) {
      final userData =
          userDataFromJson(convert.utf8.decode(response.bodyBytes));
      final RoutesData =
          routesFromJson(convert.utf8.decode(response2.bodyBytes));
      if (mounted)
        setState(() {
          user = userData;
          userDataGetted = true;
          routes = RoutesData;
          routesGetted = true;
        });
    } else {
      throw Exception('Failed to load post');
    }
  }

  Dispose() {
    Stopwatch();
  }

  compareRoutes() async {
    for (int i = 0; i < user.user.lng.length; i++) {
      for (int j = 0; j < routes.length; j++) {
        if (user.user.lng[i] == routes[j].lng &&
            user.user.ltd[i] == routes[j].ltd) {
          print(user.user.lng[i]);
          visited.add(j);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!routesGetted && !userDataGetted) fetchUserData();
    if (routesGetted && userDataGetted) {
      compareRoutes();
    }
    return (routesGetted && userDataGetted)
        ? Container(
            child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    height: 50,
                    child: Center(child: Text(routes[visited[index]].name)),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[100],
                            blurRadius:
                                1.0, // has the effect of softening the shadow
                            spreadRadius:
                                1.0, // has the effect of extending the shadow
                            offset: Offset(
                              1.0, // horizontal, move right 1
                              1.0, // vertical, move down 10
                            ),
                          )
                        ],
                        border: Border.all(
                          color: Colors.grey[100],
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8)),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 10,
                  );
                },
                itemCount: visited.length),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
