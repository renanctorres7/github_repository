

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


}
