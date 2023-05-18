class Banner {
  List<Desc>? title;
  List<Desc>? subtitle;
  String? sId;
  String? appId;
  List<Desc>? desc;
  String? imageUrl;
  String? imageAlt;
  int? sequence;
  String? dateCreated;

  Banner(
      {this.title,
      this.subtitle,
      this.sId,
      this.appId,
      this.desc,
      this.imageUrl,
      this.imageAlt,
      this.sequence,
      this.dateCreated});

  Banner.fromJson(Map<String, dynamic> json) {
    if (json['title'] != null) {
      title = <Desc>[];
      json['title'].forEach((v) {
        title!.add(Desc.fromJson(v));
      });
    }
    if (json['subtitle'] != null) {
      subtitle = <Desc>[];
      json['subtitle'].forEach((v) {
        subtitle!.add(Desc.fromJson(v));
      });
    }
    sId = json['_id'];
    appId = json['appId'];
    if (json['desc'] != null) {
      desc = <Desc>[];
      json['desc'].forEach((v) {
        desc!.add(Desc.fromJson(v));
      });
    }
    imageUrl = json['imageUrl'];
    imageAlt = json['imageAlt'];
    sequence = json['sequence'];
    dateCreated = json['dateCreated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (title != null) {
      data['title'] = title!.map((v) => v.toJson()).toList();
    }
    if (subtitle != null) {
      data['subtitle'] = subtitle!.map((v) => v.toJson()).toList();
    }
    data['_id'] = sId;
    data['appId'] = appId;
    if (desc != null) {
      data['desc'] = desc!.map((v) => v.toJson()).toList();
    }
    data['imageUrl'] = imageUrl;
    data['imageAlt'] = imageAlt;
    data['sequence'] = sequence;
    data['dateCreated'] = dateCreated;
    return data;
  }
}

class Desc {
  String? lan;
  String? text;

  Desc({this.lan, this.text});

  Desc.fromJson(Map<String, dynamic> json) {
    lan = json['lan'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lan'] = lan;
    data['text'] = text;
    return data;
  }
}
