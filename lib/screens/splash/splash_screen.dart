import 'package:flutter/material.dart';
import 'package:infinite_image_gallery_app/screens/splash/splash_vm.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashVm vm = SplashVm();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((c) {
      vm.moveToHomeScreen(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Infinite Image \n Gallery App",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CircularProgressIndicator(
                  constraints: BoxConstraints(
                    minHeight: 18,
                    maxHeight: 18,
                    maxWidth: 18,
                    minWidth: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
