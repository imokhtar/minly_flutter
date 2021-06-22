enum NetworkingStatus { inital, loading, succeded, failed }

class GalleryState extends Equatable {
  final NetworkingStatus networkingStatus;
  final List<Uint8List>? images;
  final String? failureMessage;

  GalleryState(this.networkingStatus, this.images, this.failureMessage);

  @override
  List<Object?> get props => [networkingStatus, images, failureMessage];
}
