class OpenAiErrorModel {
  OpenAiErrorModel({
    this.error,
  });

  OpenAiErrorModel.fromJson(Map<String, dynamic> json) {
    error = json["error"] != null ? Error.fromJson(json["error"]) : null;
  }

  Error? error;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    if (error != null) {
      map["error"] = error?.toJson();
    }
    return map;
  }
}

class Error {
  Error({
    this.code,
    this.message,
    this.param,
    this.type,
  });

  Error.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    message = json["message"];
    param = json["param"];
    type = json["type"];
  }

  String? code;
  String? message;
  dynamic param;
  String? type;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["code"] = code;
    map["message"] = message;
    map["param"] = param;
    map["type"] = type;
    return map;
  }
}
