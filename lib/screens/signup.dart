import 'package:flutter/material.dart';
import 'package:mkp_hris/bloc/bloc.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/router.dart';
import 'package:mkp_hris/utils/theme.dart';
import 'package:mkp_hris/utils/lib.dart';
import 'package:mkp_hris/widgets/widgets.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final AuthCubit _authCubit = getIt<AuthCubit>();
  final TextEditingController _emailController = TextEditingController();

  void _checkEmail() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show();

      _authCubit.emailValidation(_emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is EmailValidationFailed) {
          EasyLoading.dismiss();
          CustomSnackbar.buildErrorSnackbar(
            context,
            state.errorModel.errorMessage,
          );
          _authCubit.resetState();
        } else if (state is EmailValidationSuccess) {
          EasyLoading.dismiss();
          _authCubit.resetState();
          Navigator.of(context).pushNamed(
            setPasswordPageRoute,
            arguments: state.email,
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.all(20),
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
                      "Daftar Karyawan",
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
                  Center(
                    child: TextButton(
                      onPressed: () {
                        _emailController.clear();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Saya sudah memiliki akun",
                        style: primaryTextStyle,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor,
                      ),
                      onPressed: _checkEmail,
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
