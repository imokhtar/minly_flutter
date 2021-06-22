class MinlyImage {
  final String base64;

  MinlyImage(this.base64);

  factory MinlyImage.from({required Map<String, dynamic> json}) {
    final base64 = json["base64"];
    return MinlyImage(base64);
  }
}
