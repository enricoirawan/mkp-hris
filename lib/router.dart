import 'package:flutter/material.dart';
import 'package:mkp_hris/screens/set_password.dart';
import 'package:page_transition/page_transition.dart';
import 'screens/screens.dart';

const String splashPageRoute = "/";
const String signinPageRoute = "/login";
const String signupPageRoute = "/signup";
const String setPasswordPageRoute = "/setPassword";
const String forgotPasswordPageRoute = "/forgotPassword";
const String mainPageRoute = "/main";
const String profilPageRoute = "/profil";
const String detailPengumumanPageRoute = "/detailPengumuman";

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashPageRoute:
        return PageTransition(
          child: const SplashScreen(),
          type: PageTransitionType.fade,
        );

      case signupPageRoute:
        return PageTransition(
          child: SignUpScreen(),
          type: PageTransitionType.rightToLeft,
        );

      case signinPageRoute:
        return PageTransition(
          child: const SignInScreen(),
          type: PageTransitionType.bottomToTop,
        );

      case setPasswordPageRoute:
        final String emailArgument = settings.arguments as String;

        return PageTransition(
          child: SetPasswordScreen(
            email: emailArgument,
          ),
          type: PageTransitionType.rightToLeft,
        );

      case forgotPasswordPageRoute:
        return PageTransition(
          child: ForgotPasswordScreen(),
          type: PageTransitionType.rightToLeft,
        );

      case mainPageRoute:
        return PageTransition(
          child: const MainScreen(),
          type: PageTransitionType.fade,
        );

      case profilPageRoute:
        final int karyawanIdArgument = settings.arguments as int;

        return PageTransition(
          child: ProfilScreen(
            idKaryawan: karyawanIdArgument,
          ),
          type: PageTransitionType.leftToRight,
        );

      case detailPengumumanPageRoute:
        return PageTransition(
          child: PengumumanDetail(),
          type: PageTransitionType.fade,
        );

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
