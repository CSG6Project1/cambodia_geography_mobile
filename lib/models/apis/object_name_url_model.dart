class ObjectNameUrlModel {
  final String nameInUrl;
  final String? path;
  final String baseUrl;

  ObjectNameUrlModel({
    required this.nameInUrl,
    required this.path,
    required this.baseUrl,
  });

  String _withBaseUrl(String currentUrl) {
    return baseUrl + currentUrl;
  }

  String fetchOneUrl({required String? id}) {
    String url;
    if (id == null) url = "$path/$nameInUrl";
    url = "$path/$nameInUrl/$id";
    return _withBaseUrl(url);
  }

  String fetchAllUrl() {
    return _withBaseUrl("$path/$nameInUrl");
  }

  String updatelUrl({String? id}) {
    var url = "$path/$nameInUrl";
    if (id != null) url = "$url/$id";
    return _withBaseUrl(url);
  }

  String deletelUrl({String? id}) {
    var url = "$path/$nameInUrl";
    if (id != null) url = "$url/$id";
    return _withBaseUrl(url);
  }

  String createUrl() {
    var url = "$path/$nameInUrl";
    return _withBaseUrl(url);
  }
}
