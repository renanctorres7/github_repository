import 'package:http/http.dart' as http;
import 'dart:convert';

class Repository {
  final String name;
  final String avatar;
  final String url;
  final String repo;

  Repository({this.name, this.avatar, this.url, this.repo});

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
        name: json["owner"]["login"],
        avatar: json["owner"]["avatar_url"],
        url: json["html_url"],
        repo: json["name"]
    );
  }

  Map toJson() {
    return {
      'name': name,
      'avatar': avatar,
      'url': url,
      'repo': repo,
    };
  }

  Future<Repository> getData(List list) async {
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
}
