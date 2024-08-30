// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_elux_app/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_elux_app/Widgets/custom_navbar.dart';
import 'package:flutter_elux_app/firebase_options.dart';
import 'Config/helper_functions.dart';
import 'config/app_routes.dart';
import 'config/constants.dart';

bool _isSignedIn = false;
Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom,
    SystemUiOverlay.top,
  ]);
  await getUserLoggedInStatus();
  await preloadAssetFolder(imagesFolderPath);
  await  preloadAssetFolder(iconsFolderPath);

  await loadFonts();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

getUserLoggedInStatus() async {
  await HelperFunctions.getUserLoggedInStatus().then((value) {
    if (value != null) {

        _isSignedIn = value;

    }
  });
}

Future<void> preloadAssetFolder(String folderPath) async {
  final assetManifest = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(assetManifest);

  final assets = manifestMap.keys
      .where((String key) => key.startsWith(folderPath))
      .toList();

  for (final assetPath in assets) {
    final imageProvider = AssetImage(assetPath);
    final imageStream = imageProvider.resolve(ImageConfiguration.empty);
    imageStream.addListener(
      ImageStreamListener((info, synchronousCall) {
        if (kDebugMode) {
          print('Asset preloaded and cached: $assetPath');
        }
      }),
    );
  }
}

Future<void> loadFonts() async {
  final fontLoader = FontLoader('Roboto');
  fontLoader.addFont(
    rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
  );
  fontLoader.addFont(
    rootBundle.load('assets/fonts/Roboto-Medium.ttf'),
  );
  await fontLoader.load();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Elux',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ThemeData.light().colorScheme.copyWith(
                primary: Colors.white,
                onPrimary: Colors.white,
                secondary: Colors.black,
                onSecondary: Colors.white,
              ),
          useMaterial3: true,
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          }),
        ),
        onGenerateRoute: AppRouter.onGenerateRoute,
        home: _isSignedIn ? const CustomNavBar() : const WelcomeScreen(),
      ),
    );
  }
}











// If you want to load images one by one this is suitable for that.
// void preloadImages(List<String> imageUrls) {
//   for (var url in imageUrls) {
//     final ImageProvider imageProvider = AssetImage(url);
//     final ImageStream stream = imageProvider.resolve(ImageConfiguration.empty);
//     stream.addListener(ImageStreamListener((info, synchronousCall) {}));
//     if (kDebugMode) {
//       print('images loaded');
//     }
//   }
// }
