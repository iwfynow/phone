import 'package:flutter/material.dart';
import 'package:phone_book/generated/l10n.dart';
import 'package:phone_book/repositories/speech_repository.dart';
import 'package:phone_book/viewmodels/contact_view_model.dart';
import 'package:phone_book/viewmodels/message_view_model.dart';
import 'package:phone_book/viewmodels/navigation_view_model.dart';
import 'package:phone_book/viewmodels/speech_recognition_view_model.dart';
import 'package:phone_book/viewmodels/setting_view_model.dart';
import 'package:provider/provider.dart';
import 'viewmodels/filtration_viewmodel.dart';
import 'views/pages/favourites/favorites_page.dart';
import 'views/pages/recent/recents_page.dart';
import 'views/pages/contacts_page.dart';
import 'views/bottom_navigation.dart';
import 'views/dialing_pad.dart';
import 'views/pages/search_app_bar/search_app_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SettingViewModel().initSetting();
  await dotenv.load(fileName: "assets/api.env");
  SpeechRepository().deepgramApiKey = dotenv.env['API_TOKEN'] ?? "";
  runApp(
    MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => NavigationViewModel()),
      ChangeNotifierProvider(create: (_) => Filtration()),
      ChangeNotifierProvider(create: (_) => SpeechRecognitionViewModel()),
      ChangeNotifierProvider(create: (_) => MessageViewModel()),
      ChangeNotifierProvider(create: (_) => SettingViewModel()),
      ChangeNotifierProvider(create: (_) {
        ContactViewModel().init();
        return ContactViewModel();
      }),
      ],
    child: const MyHomePage(),
      )
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  List pageList = [const Favorites(), const Recents(), const Contacts()];
  @override
  Widget build(BuildContext context){
    final settingViewModel = Provider.of<SettingViewModel>(context);
    return MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: SettingViewModel().currentLocal,
        theme: settingViewModel.lightTheme,
        darkTheme: settingViewModel.darkTheme,
        themeMode: context.watch<SettingViewModel>().currentThemeMode,
      home: Scaffold(
            appBar: const SearchAppBar(),
            body: context
                        .watch<SpeechRecognitionViewModel>()
                        .isVisibleAnimation ==
                    false
                ? Consumer<NavigationViewModel>(
        builder: (context, navigationModel, child) {
          return pageList.elementAt(navigationModel.currentIndexPage);
                    },
                  )
                : Center(
                    child: Lottie.asset("assets/animations/listening.json"),
                  ),
            floatingActionButton: const DialingPad(),
            bottomNavigationBar: const CustomBottomNavigationBar())
    );
  }
}
