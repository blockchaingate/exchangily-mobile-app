class AppUpdateModel {
  String? os;
  String? version;
  bool? forceUpdate;
  String? app;
  List<Link>? link;

  AppUpdateModel(
      {this.os, this.version, this.forceUpdate, this.app, this.link});

  AppUpdateModel.fromJson(Map<String, dynamic> json) {
    os = json['os'];
    version = json['version'];
    forceUpdate = json['forceUpdate'];
    app = json['app'];
    if (json['link'] != null) {
      link = [];
      json['link'].forEach((v) {
        link!.add(Link.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['os'] = os;
    data['version'] = version;
    data['forceUpdate'] = forceUpdate;
    data['app'] = app;
    if (link != null) {
      data['link'] = link!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Link {
  String? name;
  String? link;
  bool? ready;

  Link({this.name, this.link, this.ready});

  Link.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    link = json['link'];
    ready = json['ready'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['link'] = link;
    data['ready'] = ready;
    return data;
  }
}
