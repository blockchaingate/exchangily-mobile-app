class Banner {
  List<Desc> title;
  List<Desc> subtitle;
  String sId;
  String appId;
  List<Desc> desc;
  String imageUrl;
  String imageAlt;
  int sequence;
  String dateCreated;

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
      title = new List<Desc>();
      json['title'].forEach((v) {
        title.add(new Desc.fromJson(v));
      });
    }
    if (json['subtitle'] != null) {
      subtitle = new List<Desc>();
      json['subtitle'].forEach((v) {
        subtitle.add(new Desc.fromJson(v));
      });
    }
    sId = json['_id'];
    appId = json['appId'];
    if (json['desc'] != null) {
      desc = new List<Desc>();
      json['desc'].forEach((v) {
        desc.add(new Desc.fromJson(v));
      });
    }
    imageUrl = json['imageUrl'];
    imageAlt = json['imageAlt'];
    sequence = json['sequence'];
    dateCreated = json['dateCreated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.title != null) {
      data['title'] = this.title.map((v) => v.toJson()).toList();
    }
    if (this.subtitle != null) {
      data['subtitle'] = this.subtitle.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['appId'] = this.appId;
    if (this.desc != null) {
      data['desc'] = this.desc.map((v) => v.toJson()).toList();
    }
    data['imageUrl'] = this.imageUrl;
    data['imageAlt'] = this.imageAlt;
    data['sequence'] = this.sequence;
    data['dateCreated'] = this.dateCreated;
    return data;
  }
}

class Desc {
  String lan;
  String text;

  Desc({this.lan, this.text});

  Desc.fromJson(Map<String, dynamic> json) {
    lan = json['lan'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lan'] = this.lan;
    data['text'] = this.text;
    return data;
  }
}
