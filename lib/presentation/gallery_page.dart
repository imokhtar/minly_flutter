import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minly_gallery/data/images_gateway.dart';
import 'package:minly_gallery/presentation/gallery_page_bloc.dart';

import '../helpers.dart/circular_progress.dart';
import 'gallery_state.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GalleryCubit(gateway: ImageGateway.shared),
      child: GalleryPageContainer(),
    );
  }
}

class GalleryPageContainer extends StatefulWidget {
  const GalleryPageContainer({Key? key}) : super(key: key);

  @override
  GalleryPageContainerState createState() => GalleryPageContainerState();
}

class GalleryPageContainerState extends State<GalleryPageContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(
        (_) => BlocProvider.of<GalleryCubit>(context).getImages());
  }

  @override
  Widget build(BuildContext context) {
    return GalleryView();
  }
}

class GalleryView extends StatelessWidget {
  const GalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GalleryCubit, GalleryState>(
      listener: (context, state) {
        if (state.networkingStatus == NetworkingStatus.loading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            useRootNavigator: false,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () async => false,
                child: CircularProgress(),
              );
            },
          );
          return;
        }
        if (state.networkingStatus == NetworkingStatus.failed) {
          Navigator.of(context).pop();
          return;
        }
        if (state.networkingStatus == NetworkingStatus.succeded) {
          Navigator.of(context).pop();
          return;
        }
      },
      builder: (context, state) {
        switch (state.networkingStatus) {
          case NetworkingStatus.inital:
            return Container(
              color: Colors.white,
            );
          case NetworkingStatus.loading:
            return Container(
              color: Colors.white,
            );
          case NetworkingStatus.succeded:
            return GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: state.images!
                  .map((image) => FittedBox(
                        child: Image.memory(image),
                        fit: BoxFit.fill,
                      ))
                  .toList(),
            );
          case NetworkingStatus.failed:
            return Container(
              color: Colors.white,
            );
        }
      },
    );
  }
}
