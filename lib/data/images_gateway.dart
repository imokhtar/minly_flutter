import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:minly_gallery/data/endpoints.dart';
import 'package:minly_gallery/data/minly_exceptions.dart';
import 'package:minly_gallery/data/minly_image.dart';
import 'package:http_parser/http_parser.dart';

class ImageGateway {
  final http.Client client;

  static ImageGateway shared = ImageGateway(
    client: http.Client(),
  );

  ImageGateway({required this.client});

  Future<List<MinlyImage>> getImages() {
    final getImagesFuture = client.get(Endpoints.images.uri).then((res) {
      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        final imagesJson = List<Map<String, dynamic>>.from(body);
        final images = imagesJson.map((e) => MinlyImage.from(json: e)).toList();
        return images;
      }

      if (res.statusCode == 500) {
        throw MinlyExceptions.internalServerError;
      }

      if (res.statusCode == 400) {
        throw MinlyExceptions.badRequest;
      }

      throw MinlyExceptions.unknownError;
    }).catchError((err) {
      throw MinlyExceptions.unknownError;
    });
    return getImagesFuture;
  }

  Future<void> uploadImage(Uint8List data) {
    final uploadRequest =
        http.MultipartRequest('POST', Endpoints.uploadImage.uri);
    uploadRequest.files.add(http.MultipartFile.fromBytes("image", data,
        contentType: MediaType('image', 'png'), filename: "img.png"));
    final uploadImagesFuture = uploadRequest.send().then((res) {
      if (res.statusCode == 201) {
        return print(res.statusCode);
      }

      if (res.statusCode == 500) {
        throw MinlyExceptions.internalServerError;
      }

      if (res.statusCode == 400) {
        throw MinlyExceptions.badRequest;
      }

      throw MinlyExceptions.unknownError;
    }).catchError((err) {
      throw MinlyExceptions.unknownError;
    });
    return uploadImagesFuture;
  }
}
