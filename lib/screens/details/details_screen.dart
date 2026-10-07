import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_image_gallery_app/core/app_colors.dart';
import 'package:infinite_image_gallery_app/screens/details/components/image_widget.dart';
import 'package:provider/provider.dart';

import '../../model/gallery_base_model.dart';
import 'components/info_row.dart';
import 'components/stat_item.dart';
import 'details_vm.dart';

class ImageDetailScreen extends StatefulWidget {
  const ImageDetailScreen({super.key, required this.hit});

  final Hits hit;

  @override
  State<StatefulWidget> createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  final DetailsVm vm = DetailsVm();
  late final Hits hit;

  @override
  void initState() {
    hit = widget.hit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 60,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.black,

            elevation: 0,
            title: const Text(
              'Image Details',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  vm.onTapShare(hit, context);
                },
                icon: Icon(Icons.share_outlined, color: Colors.white),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageWidget(hit: hit),
                _buildContent(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserSection(context),

          const SizedBox(height: 20),

          _buildDescription(context),

          const SizedBox(height: 20),

          _buildTags(context),

          const SizedBox(height: 24),

          _buildStatistics(context),

          const SizedBox(height: 24),

          _buildImageInformation(context),

          const SizedBox(height: 24),

          ChangeNotifierProvider.value(
            value: vm,
            child: Consumer<DetailsVm>(
              builder: (context, vm, child) {
                return Column(
                  children: [
                    if (vm.isDownloading) ...[
                      LinearProgressIndicator(value: vm.downloadProgress),

                      const SizedBox(height: 8),

                      Text(
                        'Downloading ${(vm.downloadProgress * 100).toInt()}%',
                      ),

                      const SizedBox(height: 12),
                    ],

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: vm.isDownloading
                            ? null
                            : () {
                                vm.downloadImage(
                                  hit.largeImageURL ?? hit.webformatURL ?? '',
                                );
                              },
                        icon: const Icon(Icons.download_outlined),
                        label: Text(
                          vm.isDownloading
                              ? 'Downloading...'
                              : 'Download Image',
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: hit.userImageURL != null
              ? CachedNetworkImageProvider(hit.userImageURL!)
              : null,
          child: hit.userImageURL == null
              ? const Icon(Icons.person_outline)
              : null,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(hit.user ?? 'Unknown User', style: textTheme.titleMedium),

              const SizedBox(height: 4),

              Text(
                hit.type ?? 'Image',
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description', style: textTheme.titleLarge),

        const SizedBox(height: 8),

        Text(
          hit.tags?.isNotEmpty == true
              ? 'This image contains ${hit.tags}.'
              : 'No description available for this image.',
          style: textTheme.bodyMedium?.copyWith(
            height: 1.6,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildTags(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (hit.tags == null || hit.tags!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final tags = hit.tags!
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tags', style: textTheme.titleLarge),

        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(tag, style: textTheme.labelMedium),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatistics(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Statistics', style: textTheme.titleLarge),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: StatItem(
                icon: Icons.visibility_outlined,
                title: 'Views',
                value: vm.formatNumber(hit.views),
              ),
            ),

            Expanded(
              child: StatItem(
                icon: Icons.download_outlined,
                title: 'Downloads',
                value: vm.formatNumber(hit.downloads),
              ),
            ),

            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (hit.isFavourite == true) {
                    vm.favouriteViewModel.removeFavourite(hit.id!);
                    hit.isFavourite = false;
                    hit.likes = (hit.likes ?? 0) -1;
                  } else {
                    vm.favouriteViewModel.toggleFavourite(hit);
                    hit.isFavourite = true;
                    hit.likes = (hit.likes ?? 0) +1;
                  }
                  setState(() {

                  });
                },
                child: StatItem(
                  icon: hit.isFavourite == true
                      ? Icons.favorite
                      : Icons.favorite_border,
                  title: 'Likes',
                  value: vm.formatNumber(hit.likes),
                  colors: hit.isFavourite == true
                      ? Colors.red
                      : Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: StatItem(
                icon: Icons.collections_outlined,
                title: 'Collections',
                value: vm.formatNumber(hit.collections),
              ),
            ),

            Expanded(
              child: StatItem(
                icon: Icons.comment_outlined,
                title: 'Comments',
                value: vm.formatNumber(hit.comments),
              ),
            ),

            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildImageInformation(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Image Information', style: textTheme.titleLarge),

        const SizedBox(height: 12),

        InfoRow(title: 'Image ID', value: hit.id?.toString() ?? '-'),

        InfoRow(title: 'Type', value: hit.type ?? '-'),

        InfoRow(title: 'Dimensions', value: vm.dimensions(hit)),

        InfoRow(title: 'File Size', value: vm.fileSize(hit)),

        InfoRow(title: 'User ID', value: hit.userId?.toString() ?? '-'),
      ],
    );
  }
}
