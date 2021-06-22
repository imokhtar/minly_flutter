import 'dart:convert';
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
      final decoder = Base64Decoder();
      final imagesBytes =
          loadedImages.map((e) => decoder.convert(e.base64)).toList();
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
}
