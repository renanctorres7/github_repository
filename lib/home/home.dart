import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:github_repository/data/repository.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Repository> repository;
  var list = List<Repository>();
  bool enable;
  int items = 10;
  ScrollController controller;
  bool floatVisible = true;


  // ignore: missing_return
  Future<Repository> getData() async {
    final response = await http.get('https://api.github.com/repositories');

    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      list = decoded.map<Repository>((e) {
        return Repository.fromJson(e);
      }).toList();
      print(list);
    } else {
      throw Exception('Erro ao carregar');
    }
  }

  launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch url";
    }
  }

  isButtonDisabled(int count) {
    setState(() {
      enable = true;
      items = count;
    });
  }

  void backTop () {
    setState(() {
      controller.animateTo(controller.position.minScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn);
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    repository = getData();
    enable = false;
    controller = ScrollController();
    controller.addListener(() {
      setState(() {
        floatVisible = controller.position.userScrollDirection == ScrollDirection.reverse;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          floatingActionButton: AnimatedOpacity(
            child: FloatingActionButton(
              onPressed: () {
                backTop();
              },
              child: Icon(Icons.arrow_upward),
              backgroundColor: Color.fromRGBO(4, 38, 76, 1),
            ),

            duration: Duration(milliseconds: 300),
            opacity: floatVisible ? 1 : 0,
          ),
          body: NestedScrollView(
            controller: controller,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 150,
                  flexibleSpace: const FlexibleSpaceBar(
                    title: ListTile(
                      title: const Text(
                        "GitHub",
                        style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      subtitle: const Text(
                        "Repositórios",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    centerTitle: true,
                  ),
                )
              ];
            },
            body: Container(
              child: FutureBuilder<Repository>(
                future: repository,
                builder: (context, snapshot) {
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
                      final innerScrollController =
                          PrimaryScrollController.of(context);

                      return ListView(
                        controller: innerScrollController,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 70,
                                padding: const EdgeInsets.only(right: 8.0),
                                child: RaisedButton(
                                  color:
                                      items == 10 ? Colors.white : Colors.white54,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () {
                                    isButtonDisabled(10);
                                  },
                                  child: Text("10"),
                                ),
                              ),
                              Container(
                                width: 70,
                                padding: const EdgeInsets.only(right: 8.0),
                                child: RaisedButton(
                                  color:
                                      items == 50 ? Colors.white : Colors.white54,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () {
                                    isButtonDisabled(50);
                                  },
                                  child: Text("50"),
                                ),
                              ),
                              Container(
                                width: 70,
                                child: RaisedButton(
                                  color:
                                      items == 100 ? Colors.white : Colors.white54,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () {
                                    isButtonDisabled(100);
                                  },
                                  child: Text("100"),
                                ),
                              )
                            ],
                          ),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(130)),
                            child: Container(
                              color: Colors.white,
                              child: Container(
                                padding: const EdgeInsets.only(top: 40),
                                margin: const EdgeInsets.only(left: 40),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: items,
                                    itemBuilder: (context, index) {
                                      String avatar = list[index].avatar;
                                      String name = list[index].name;
                                      String url = list[index].url;
                                      String repo = list[index].repo;

                                      return InkWell(
                                        onTap: () {
                                          launchUrl(url);
                                        },
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.all(10),
                                          leading: CircleAvatar(
                                            radius: 40,
                                            backgroundImage: NetworkImage(avatar),
                                          ),
                                          title: Text(repo.toUpperCase(), style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                          ),),
                                          subtitle: Text("Autor: $name", style: TextStyle(
                                            fontSize: 14
                                          ),),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ),
                        ],
                      );
                  }
                },
              ),
            ),
          ),
    ));
  }
}
