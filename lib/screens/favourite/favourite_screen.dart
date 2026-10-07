import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'favourite_vm.dart';

class FavouriteScreen extends StatefulWidget {
  final FavouriteViewModel vm;
  const FavouriteScreen({super.key,required this.vm});

  @override
  State<StatefulWidget> createState() => _FavouriteScreenWidget();
}

class _FavouriteScreenWidget extends State<FavouriteScreen> {

 late final  FavouriteViewModel vm;
  @override
  void initState() {
    vm = widget.vm;
    super.initState();
    vm.isScreenDispose = false;
    WidgetsBinding.instance.addPostFrameCallback((c){
      vm.loadFavourites();
    });
  }

  @override
  void dispose() {
    vm.isScreenDispose = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: ChangeNotifierProvider.value(
        value: vm,
        child: Consumer<FavouriteViewModel>(
          builder: (context, vm, child) {
            if (vm.favouriteList.isEmpty) {
              return const Center(child: Text('No favourites'));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: vm.getCrossAxisCount(context),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: vm.favouriteList.length,
              itemBuilder: (context, index) {
                final hit = vm.favouriteList[index];

                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: hit.webformatURL ?? '',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          if (hit.id != null) {
                            vm.removeFavourite(hit.id!);
                          }
                        },
                        child: const Icon(Icons.favorite, color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
