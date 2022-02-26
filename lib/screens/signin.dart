import 'package:flutter/material.dart';
import 'package:mkp_hris/bloc/bloc.dart';
import 'package:mkp_hris/injection.dart';
import 'package:mkp_hris/router.dart';
import 'package:mkp_hris/widgets/widgets.dart';

import '../utils/theme.dart';
import '../utils/lib.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthCubit _authCubit = getIt<AuthCubit>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //local state
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
  }

  void _signin() async {
    if (_formKey.currentState!.validate()) {
      _authCubit.signinUser(_emailController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailed) {
          //dismiss loading
          EasyLoading.dismiss();

          //reset state
          _authCubit.resetState();

          CustomSnackbar.buildErrorSnackbar(
            context,
            state.errorModel.errorMessage,
          );
        } else if (state is AuthSuccess) {
          //dismiss loading
          EasyLoading.dismiss();

          //navigate ke halaman main
          Navigator.of(context).pushReplacementNamed(mainPageRoute);
        } else if (state is AuthLoading) {
          //show loading
          EasyLoading.show();
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(child: Container()),
                  Image.asset(
                    "assets/mkp_logo.png",
                    width: 200,
                  ),
                  Text(
                    "Login Karyawan",
                    style: blackTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
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
                  TextFormField(
                    obscureText: isPasswordVisible ? false : true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Password harus diisi';
                      } else if (value.length < 5) {
                        return "*Password minimal 5 karakter";
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
                  Text(
                    "*Masukan email MKP anda yang sudah terdaftar oleh pihak HR.",
                    style: blackTextStyle,
                  ),
                  Expanded(child: Container()),
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pushNamed(forgotPasswordPageRoute);
                  //   },
                  //   child: Text(
                  //     "Saya lupa password akun saya",
                  //     style: primaryTextStyle,
                  //   ),
                  // ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(signupPageRoute);
                    },
                    child: Text(
                      "Saya belum memiliki akun",
                      style: primaryTextStyle,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor,
                      ),
                      onPressed: _signin,
                      child: Text(
                        "Masuk",
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
