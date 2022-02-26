import 'package:flutter/material.dart';
import 'package:mkp_hris/bloc/bloc.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/router.dart';
import 'package:mkp_hris/widgets/widgets.dart';

import '../utils/theme.dart';
import '../utils/lib.dart';

class SetPasswordScreen extends StatefulWidget {
  final String email;

  const SetPasswordScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthCubit _authCubit = getIt<AuthCubit>();
  final TextEditingController _passwordController = TextEditingController();

  //local state
  bool isPasswordVisible = false;

  Future<void> _onPressed() async {
    if (_formKey.currentState!.validate()) {
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

      EasyLoading.show();

      _authCubit.signupUser(widget.email, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignupFailed) {
          EasyLoading.dismiss();
          CustomSnackbar.buildErrorSnackbar(
            context,
            state.errorModel.errorMessage,
          );
          _authCubit.resetState();
        } else if (state is SignupSuccess) {
          EasyLoading.dismiss();
          CustomSnackbar.buildSuccessSnackbar(
            context,
            "Akun berhasil terdaftar. Silahkan login menggunakan email yang sudah terdaftar",
          );
          _authCubit.resetState();
          Navigator.of(context)
              .pushNamedAndRemoveUntil(signinPageRoute, (route) => false);
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.all(
              20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(child: Container()),
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    "assets/mkp_logo.png",
                    width: 200,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Masukan password akun ${widget.email}",
                    style: blackTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: isPasswordVisible ? false : true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Password harus diisi';
                      } else if (value.length < 5) {
                        return "*Password minimal 6 karakter";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: kPrimaryColor, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(color: kRedColor, width: 2),
                      ),
                      errorStyle: redTextStyle,
                      hintText: "Password",
                      label: const Text("Password"),
                      suffixIcon: InkWell(
                        child: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(child: Container()),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor,
                      ),
                      onPressed: _onPressed,
                      child: Text(
                        "Daftar",
                        style: whiteTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
