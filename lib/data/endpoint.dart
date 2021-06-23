class Endpoint {
  final String host;
  final String path;

  const Endpoint({
    this.host = "http://10.0.2.2:3000/",
    required this.path,
  });

  Uri get uri {
    final fullLink = host + (path);
    return Uri.parse(fullLink);
  }
}
