import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_image_gallery_app/model/gallery_base_model.dart';

class ImageWidget extends StatelessWidget {
  final Hits hit;
  const ImageWidget({super.key,required this.hit});

  @override
  Widget build(BuildContext context) {
    return  AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      color: Colors.black,
      child: Hero(
        tag: '${hit.id}',
        child: AspectRatio(
          aspectRatio: _imageAspectRatio(),
          child: CachedNetworkImage(
            imageUrl: hit.largeImageURL ?? hit.webformatURL ?? '',
            fit: BoxFit.contain,

            progressIndicatorBuilder: (context, url, p) => Center(
              child: CircularProgressIndicator(
                value: p.progress,
                constraints: BoxConstraints(
                  minHeight: 18,
                  maxHeight: 22,
                  maxWidth: 22,
                  minWidth: 18,
                ),
              ),
            ),

            errorWidget: (context, url, error) {
              return const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  color: Colors.white,
                  size: 60,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  double _imageAspectRatio() {
    final width = hit.imageWidth;
    final height = hit.imageHeight;

    if (width != null && height != null && width > 0 && height > 0) {
      return width / height;
    }

    return 1;
  }
}
