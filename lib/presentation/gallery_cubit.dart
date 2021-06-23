import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minly_gallery/data/images_gateway.dart';
import 'package:minly_gallery/data/minly_exceptions.dart';

import 'gallery_state.dart';

class GalleryCubit extends Cubit<GalleryState> {
  ImageGateway gateway;

  GalleryCubit({
    required this.gateway,
  }) : super(
          GalleryState(NetworkingStatus.inital, null, null),
        );

  Future<void> getImages() async {
    emit(
      GalleryState(NetworkingStatus.loading, null, null),
    );

    gateway.getImages().then((loadedImages) {
      final imagesBytes =
          loadedImages.map((e) => base64Decode(e.base64)).toList();
      emit(
        GalleryState(
          NetworkingStatus.succeded,
          imagesBytes,
          null,
        ),
      );
    }).catchError((err) {
      final errorMessage = (err as MinlyException).toString();
      emit(
        GalleryState(
          NetworkingStatus.failed,
          null,
          errorMessage,
        ),
      );
    });
  }

  Future<void> uploadImage(Uint8List? bytes) async {
    emit(
      GalleryState(NetworkingStatus.loading, null, null),
    );

    if (bytes == null) {
      emit(
        GalleryState(
          NetworkingStatus.failed,
          null,
          "Picked file is corrupted",
        ),
      );
      return;
    }

    gateway
        .uploadImage(bytes)
        .then((value) => this.getImages())
        .catchError((err) {
      final errorMessage = (err as MinlyException).toString();
      emit(
        GalleryState(
          NetworkingStatus.failed,
          null,
          errorMessage,
        ),
      );
    });
  }
}
