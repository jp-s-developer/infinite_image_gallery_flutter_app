import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shimmer/shimmer.dart';

import '../home_vm.dart';

class GalleryShimmer extends StatelessWidget {
  final HomeVm vm;
  const GalleryShimmer({
    super.key,
    this.itemCount = 12,
    required this.vm,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {

    return SliverPadding(
      padding: const EdgeInsets.all(12),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: vm.getCrossAxisCount(context),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return const _GalleryShimmerItem();
        },
      ),
    );
  }
}

class _GalleryShimmerItem extends StatelessWidget {
  const _GalleryShimmerItem();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}