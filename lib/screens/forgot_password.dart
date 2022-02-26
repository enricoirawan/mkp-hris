import 'package:flutter/material.dart';
import 'package:mkp_hris/bloc/bloc.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/widgets/widgets.dart';

import '../utils/lib.dart';
import '../utils/theme.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  final AuthCubit _authCubit = getIt<AuthCubit>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _onPressed() async {
    _authCubit.emailValidationForResetPassword(_emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is EmailValidationForResetPasswordFailed) {
          EasyLoading.dismiss();

          CustomSnackbar.buildErrorSnackbar(
            context,
            state.errorModel.errorMessage,
          );
        } else if (state is EmailValidationForResetPasswordSuccess) {
          _emailController.clear();
          EasyLoading.dismiss();

          CustomSnackbar.buildSuccessSnackbar(
            context,
            state.message,
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: const Icon(Icons.arrow_back),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Expanded(child: Container()),
                  Center(
                    child: Image.asset(
                      "assets/mkp_logo.png",
                      width: 200,
                    ),
                  ),
                  Center(
                    child: Text(
                      "Reset Password",
                      style: blackTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Email harus diisi';
                      } else if (!value.contains("@")) {
                        return "*Email tidak valid";
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
                      hintText: "Email",
                      label: const Text("Email"),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "*Masukan email MKP anda yang sudah terdaftar oleh pihak HR.",
                    style: blackTextStyle,
                  ),
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
                        "Reset Password",
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
