import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Restaurant> fetchRestaurant() async {
  final response =
      await http.get('http://www.charlottelunchrandomizer.com/api/restaurants/random?neighborhood_id=1');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return Restaurant.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    print(response.statusCode);
    throw Exception('Failed to load Post');
  }
}

class Restaurant {
  final int id;
  final String name;
  final String address;
  final String directions;
  final int neighborhoodId;
  final String createdAt;
  final String updatedAt;
  final String website;
  final String hashtag;

  Restaurant({this.id, this.name, this.address, this.directions, this.neighborhoodId, this.createdAt, this.updatedAt, this.website, this.hashtag});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      directions: json['directions'],
      neighborhoodId: json['neighborhood_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      website: json['website'],
      hashtag: json['hashtag'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
Future<Restaurant> restaurant;

  @override
  void initState() {
    super.initState();
    restaurant = fetchRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Charlotte Lunch Randomizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Charlotte Lunch Randomizer'),
        ),
        body: ListView(
          children: <Widget>[
            FutureBuilder<Restaurant>(
            future: restaurant,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      Container(
                        height: 50,
                        color: Colors.blue,
                        child: Center(child: Text(snapshot.data.name??'')),
                      ),
                      Container(
                        height: 50,
                        color: Colors.lightBlueAccent,
                        child: Center(child: Text(snapshot.data.website??'')),
                      ),
                    ],
                  );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
            ),
          SizedBox(height: 20.0),
          RaisedButton(
            child: Text("Pick again!"),
            color: Colors.blue,
            onPressed: () {
              setState(() {
                restaurant = fetchRestaurant();
              });
            },
          )
          ]
        ),
      ),
    );
  }
}
