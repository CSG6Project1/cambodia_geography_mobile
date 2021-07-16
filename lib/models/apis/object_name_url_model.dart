class ObjectNameUrlModel {
  final String nameInUrl;
  final String? path;

  ObjectNameUrlModel({
    required this.nameInUrl,
    required this.path,
  });

  String fetchOneUrl({required String? id}) {
    if (id == null) return "$path/$nameInUrl";
    return "$path/$nameInUrl/$id";
  }

  String fetchAllUrl() {
    return "$path/$nameInUrl";
  }

  String updatelUrl({String? id}) {
    var url = "$path/$nameInUrl";
    if (id != null) url = "$url/$id";
    return url;
  }

  String deletelUrl({String? id}) {
    var url = "$path/$nameInUrl";
    if (id != null) url = "$url/$id";
    return url;
  }

  String createUrl() {
    var url = "$path/$nameInUrl";
    return url;
  }
}
