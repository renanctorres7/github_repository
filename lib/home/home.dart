import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:github_repository/data/repository.dart';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Repository> repository;
  var list = List<Repository>();

  Future<Repository> getData() async {
    final response = await http.get('https://api.github.com/repositories');

    if(response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      list = decoded.map<Repository>((e) {
        return Repository.fromJson(e);
      }).toList();
      print(list);
    } else {
      throw Exception('Erro ao carregar');
    }
  }

  @override
  void initState() {

    super.initState();
    getData();
    repository = getData();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Container(
            child: FutureBuilder<Repository>(
              future: repository,
              builder: (context, snapshot) {
                print('###################### $snapshot');

                if (snapshot.hasError) {
                  return const Center(
                    child: const Text('Erro na data'),
                  );
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.none:
                    return const Center(
                      child: const Text('Erro'),
                    );
                  default:
                    return ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          String avatar = list[index].avatar;
                          String name = list[index].name;
                          // String url = snapshot.data.url;
                          String repo = list[index].repo;


                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: ListTile(
                              leading: Container(
                                child: Image.network(avatar),
                              ),
                              title: Text("Repositório: $repo"),
                              subtitle: Text("Autor: $name"),
                            ),
                          );
                        }
                    );
                }

              },
            ),
          ),
        )
    );
  }
}
