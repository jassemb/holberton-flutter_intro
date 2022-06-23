// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:breaking_bad/character_tile.dart';
import 'package:breaking_bad/models.dart';
import 'package:breaking_bad/quotes_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  Future fetchBbCharacters() async {
    var characList = [];
    final response = await http.get(
      Uri.parse('https://www.breakingbadapi.com/api/characters'),
    );
    var resJson = jsonDecode(response.body);
    for (var index in resJson) {
      Character character = Character(
          id: index['char_id'], name: index['name'], imgUrl: index['img']);

      characList.add(character);
    }
    return characList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('breaking bad quotes')),
      body: FutureBuilder(
          future: fetchBbCharacters(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: Text('An error occured'),
                );
              } else {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, index) {
                    return GestureDetector(
                      child: (CharacterTile(
                        character: snapshot.data[index],
                      )),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuotesScreen(
                                    id: snapshot.data[index].id,
                                    name: snapshot.data[index].name)));
                      },
                    );
                  },
                );
              }
            }
          }),
    );
  }
}
