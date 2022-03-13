import 'package:flutter/material.dart';
import 'package:mkp_hris/model/model.dart';
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
const String buatPengumumanPageRoute = "/buatPengumuman";
const String karyawanPageRoute = "/karyawan";
const String detailKaryawanPageRoute = "/detailKaryawan";
const String addKaryawanPageRoute = "/addKaryawan";
const String updateKaryawanPageRoute = "/updateKaryawan";
const String inputGajiPageRoute = "/inputGaji";
const String riwayatGajiPageRoute = "/riwayatGaji";
const String inputGajiFormPageRoute = "/inputGajiForm";

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
        final PengumumanModel pengumumanModelArgument =
            settings.arguments as PengumumanModel;

        return PageTransition(
          child: PengumumanDetail(
            pengumumanModel: pengumumanModelArgument,
          ),
          type: PageTransitionType.fade,
        );

      case buatPengumumanPageRoute:
        final String namaArgument = settings.arguments as String;

        return PageTransition(
          child: BuatPengumuman(nama: namaArgument),
          type: PageTransitionType.fade,
        );

      case karyawanPageRoute:
        return PageTransition(
          child: const KaryawanScreen(),
          type: PageTransitionType.fade,
        );

      case detailKaryawanPageRoute:
        final KaryawanModel karyawanArgument =
            settings.arguments as KaryawanModel;

        return PageTransition(
          child: DetailKaryawanScreen(karyawan: karyawanArgument),
          type: PageTransitionType.fade,
        );

      case addKaryawanPageRoute:
        return PageTransition(
          child: const AddKaryawanScreen(),
          type: PageTransitionType.fade,
        );

      case updateKaryawanPageRoute:
        final KaryawanModel karyawanArgument =
            settings.arguments as KaryawanModel;

        return PageTransition(
          child: UpdateKaryawanScreen(karyawan: karyawanArgument),
          type: PageTransitionType.fade,
        );

      case inputGajiPageRoute:
        return PageTransition(
          child: const InputGajiScreen(),
          type: PageTransitionType.fade,
        );

      case riwayatGajiPageRoute:
        final KaryawanModel karyawanArgument =
            settings.arguments as KaryawanModel;

        return PageTransition(
          child: RiwayatGajiKaryawan(karyawan: karyawanArgument),
          type: PageTransitionType.fade,
        );

      case inputGajiFormPageRoute:
        final KaryawanModel karyawanArgument =
            settings.arguments as KaryawanModel;

        return PageTransition(
          child: InputgajiFormScreen(karyawan: karyawanArgument),
          type: PageTransitionType.fade,
        );

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
