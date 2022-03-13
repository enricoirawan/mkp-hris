import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';

import 'package:mkp_hris/bloc/bloc.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/router.dart';
import 'package:mkp_hris/utils/constant.dart';
import 'package:mkp_hris/utils/lib.dart';

import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: anonKey,
  );

  //locator
  setup();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black54,
      statusBarColor: Color.fromARGB(255, 1, 66, 177), // status bar color
    ),
  );

  //hydrated bloc & bloc observer setup
  final storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  HydratedBlocOverrides.runZoned(
    () {
      BlocOverrides.runZoned(
        () {
          runApp(const MyApp());
          configLoading();
        },
        blocObserver: MyBlocObserver(),
      );
    },
    storage: storage,
  );
}

void configLoading() {
  EasyLoading.instance
    ..backgroundColor = kPrimaryColor
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..userInteractions = false
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = kPrimaryColor
    ..indicatorColor = kWhiteColor
    ..textColor = kWhiteColor
    ..progressColor = kWhiteColor
    ..maskType = EasyLoadingMaskType.custom
    ..maskColor = kWhiteColor.withOpacity(0.5);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => getIt.get<AuthCubit>(),
        ),
        BlocProvider<BottomNavCubit>(
          create: (_) => getIt.get<BottomNavCubit>(),
        ),
        BlocProvider<KaryawanCubit>(
          create: (_) => getIt.get<KaryawanCubit>(),
        ),
        BlocProvider<AbsensiCubit>(
          create: (_) => getIt.get<AbsensiCubit>(),
        ),
        BlocProvider<PengumumanCubit>(
          create: (_) => getIt.get<PengumumanCubit>(),
        ),
        BlocProvider<GajiCubit>(
          create: (_) => getIt.get<GajiCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'MKP - HRIS',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouterGenerator.generateRoute,
        initialRoute: splashPageRoute,
        builder: EasyLoading.init(),
      ),
    );
  }
}
