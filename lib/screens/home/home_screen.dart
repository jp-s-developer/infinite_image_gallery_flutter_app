import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_image_gallery_app/core/router/app_router.dart';
import 'package:infinite_image_gallery_app/screens/home/components/gallery_shimmer.dart';
import 'package:infinite_image_gallery_app/screens/home/home_vm.dart';
import 'package:provider/provider.dart';

import 'dart:io';

import 'components/gallery_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final HomeVm vm = HomeVm();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      vm.isScreenDispose = false;
      vm.onInitHome();
      scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          vm.fetchImages(search: textEditingController.text);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider.value(
        value: vm,
        child: Consumer<HomeVm>(
          builder: (c, v, s) => RefreshIndicator(
            onRefresh: () =>
                vm.onInitHome(search: textEditingController.text),
            child: CustomScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  title: const Text('Gallery App'),
                  pinned: true,
                  floating: true,
                  actions: [
                    IconButton(
                      onPressed: () => vm.moveToFavouriteScreen(context: context),
                      icon: const Icon(Icons.favorite_border_rounded),
                    ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverToBoxAdapter(
                    child: TextField(
                      controller: textEditingController,
                      onChanged: (value) async {
                        await Future.delayed(const Duration(seconds: 1));
                        vm.onInitHome(search: value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search for images',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: textEditingController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  textEditingController.clear();
                                  vm.onInitHome();
                                },
                                icon: const Icon(Icons.clear),
                              )
                            : SizedBox(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                if (vm.imageList.isEmpty && vm.isPaginationLoading)
                  GalleryShimmer(vm: vm)
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(12),
                    sliver: SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: vm.getCrossAxisCount(context),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: vm.imageList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            vm.moveToImageDetails(
                              context,
                              vm.imageList[index],
                            );
                          },
                          child: GalleryItem(
                            image: vm.imageList[index],
                            vm: vm,
                          ),
                        );
                      },
                    ),
                  ),
                if (vm.imageList.isNotEmpty && vm.isPaginationLoading)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  )
                else
                  const SliverToBoxAdapter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    textEditingController.dispose();
    vm.isScreenDispose = true;
    super.dispose();
  }
}
