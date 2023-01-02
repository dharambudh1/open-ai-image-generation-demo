class OpenAiResponseModel {
  OpenAiResponseModel({
    this.created,
    this.data,
  });

  OpenAiResponseModel.fromJson(Map<String, dynamic> json) {
    created = json["created"];
    if (json["data"] != null) {
      data = <Data>[];
      json["data"].forEach((dynamic v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  int? created;
  List<Data>? data;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["created"] = created;
    if (data != null) {
      map["data"] = data?.map((Data v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  Data({
    this.url,
  });

  Data.fromJson(Map<String, dynamic> json) {
    url = json["url"];
  }

  String? url;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["url"] = url;
    return map;
  }
}
