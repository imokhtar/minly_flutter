import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minly_gallery/data/images_gateway.dart';
import 'package:minly_gallery/presentation/gallery_cubit.dart';

import '../helpers.dart/circular_progress.dart';
import 'gallery_state.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GalleryCubit(gateway: ImageGateway.shared),
      child: GalleryViewContainer(),
    );
  }
}

class GalleryViewContainer extends StatefulWidget {
  final title = 'Minly Gallery';
  final _picker = ImagePicker();

  GalleryViewContainer({Key? key}) : super(key: key);

  @override
  GalleryViewContainerState createState() => GalleryViewContainerState();
}

class GalleryViewContainerState extends State<GalleryViewContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(
        (_) => BlocProvider.of<GalleryCubit>(context).getImages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GalleryView(),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void pickImage() {
    widget._picker.getImage(source: ImageSource.gallery).then((pickedFile) {
      pickedFile?.readAsBytes().then(
          (bytes) => BlocProvider.of<GalleryCubit>(context).uploadImage(bytes));
    }).catchError((err) {
      print(err);
    });
  }
}

class GalleryView extends StatelessWidget {
  const GalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GalleryCubit, GalleryState>(
      listener: (context, state) {
        if (state.networkingStatus == NetworkingStatus.loading) {
          showLoading(context);
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
                  .map((imageBytes) => FittedBox(
                        child: Image.memory(imageBytes),
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

  Future showLoading(BuildContext context) {
    return showDialog(
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
  }
}
