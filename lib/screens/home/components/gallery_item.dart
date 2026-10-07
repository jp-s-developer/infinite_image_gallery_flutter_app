import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_image_gallery_app/model/gallery_base_model.dart';
import 'package:infinite_image_gallery_app/screens/home/home_vm.dart';

class GalleryItem extends StatefulWidget {
  final Hits image;
  final HomeVm vm;

  const GalleryItem({super.key, required this.image, required this.vm});

  @override
  State<StatefulWidget> createState() => _GalleryItemWidget();
}

class _GalleryItemWidget extends State<GalleryItem> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Hero(
              tag: '${widget.image.id}',
              child: CachedNetworkImage(
                imageUrl: widget.image.webformatURL ?? '',
                fit: BoxFit.cover,

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

                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.broken_image_outlined, size: 40),
                ),
              ),
            ),
          ),

          Positioned(
            top: 8,
            right: 8,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                onTap: () {
                  if (widget.image.isFavourite == true) {
                    widget.vm.favouriteViewModel.removeFavourite(
                      widget.image.id!,
                    );
                    widget.image.isFavourite = false;
                  } else {
                    widget.vm.favouriteViewModel.toggleFavourite(widget.image);
                    widget.image.isFavourite = true;
                  }
                  setState(() {});
                },
                child: widget.image.isFavourite == true
                    ? Icon(Icons.favorite, color: Colors.white, size: 20)
                    : Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 20,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
