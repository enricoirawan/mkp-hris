import 'package:flutter/material.dart';
import 'package:mkp_hris/bloc/bloc.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/router.dart';
import 'package:mkp_hris/utils/theme.dart';

import '../utils/lib.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthCubit _authCubit = getIt<AuthCubit>();

  @override
  void initState() {
    super.initState();
    _authCubit.recoverSession();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pushReplacementNamed(mainPageRoute);
          });
        } else {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pushReplacementNamed(signinPageRoute);
          });
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.all(20),
            color: kWhiteColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/mkp_logo.png",
                  width: 200,
                  height: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(child: Container()),
                Text(
                  "MKP HRIS",
                  style: primaryTextStyle.copyWith(
                    letterSpacing: 2,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Human Resource Information System",
                  style: primaryTextStyle.copyWith(
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                Expanded(child: Container()),
                Text(
                  "Powered By Enrico Irawan",
                  style: primaryTextStyle.copyWith(
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
