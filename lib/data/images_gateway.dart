import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:minly_gallery/data/endpoints.dart';
import 'package:minly_gallery/data/minly_exceptions.dart';
import 'package:minly_gallery/data/minly_image.dart';

class ImageGateway {
  final http.Client client;
  final http.MultipartRequest uploadRequest;

  static ImageGateway shared = ImageGateway(
      client: http.Client(),
      uploadRequest: http.MultipartRequest('POST', Endpoints.uploadImage.uri));

  ImageGateway({required this.client, required this.uploadRequest});

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

  Future<void> uploadImage(String data) {
    uploadRequest.files.add(http.MultipartFile.fromString("image", data));
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
